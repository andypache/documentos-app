import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/share/preference.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/common/loading_widget.dart';

///Diálogo para seleccionar impuestos
class TaxSelectionDialogWidget extends StatefulWidget {
  final List<ItemTaxModel> currentTaxes;
  final Function(SystemParameterModel) onTaxSelected;

  const TaxSelectionDialogWidget({
    Key? key,
    required this.currentTaxes,
    required this.onTaxSelected,
  }) : super(key: key);

  @override
  State<TaxSelectionDialogWidget> createState() =>
      _TaxSelectionDialogWidgetState();
}

class _TaxSelectionDialogWidgetState extends State<TaxSelectionDialogWidget> {
  final CompanyService _companyService = CompanyService();
  List<CompanySaleParameterModel> _companySaleParameters = [];
  final List<SystemParameterModel> _availableTaxes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTaxes();
  }

  Future<void> _loadTaxes() async {
    setState(() => _isLoading = true);

    _companySaleParameters =
        Preferences.userSession.company?.saleParameters ?? [];

    if (_companySaleParameters.isEmpty) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      return;
    }

    final catalog =
        await _companyService.getCatalogs(context) ?? CatalogModelList();

    // Índices para búsqueda O(1)
    final saleParamByCode = {
      for (final sp in catalog.saleParameters) sp.code: sp,
    };
    final systemParamByCode = {
      for (final sp in catalog.systemParameters) sp.code: sp,
    };

    _availableTaxes.clear();

    for (final companySaleParam in _companySaleParameters) {
      final saleParam = saleParamByCode[companySaleParam.saleParameterId];
      if (saleParam == null) continue;

      final systemParamId = saleParam.value?['system_parameter_id'] as String?;
      if (systemParamId == null) continue;

      final systemParam = systemParamByCode[systemParamId];
      if (systemParam == null) continue;

      _availableTaxes.add(SystemParameterModel(
        systemParameterId: systemParamId,
        name: saleParam.description,
        description: systemParam.description,
        companySystemParameterId: null,
        companySaleParameterId: companySaleParam.id,
        numberParameter: double.tryParse(
            saleParam.value?['number_parameter']?.toString() ?? ''),
        isTaxSale: 'S',
        taxCode: systemParamId,
        percentageCode: saleParam.value?['percentage_code'] as String?,
      ));
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  // Obtener los tax_code ya utilizados en los impuestos actuales.
  // Cruza los idCompanySaleParameter de los impuestos actuales con
  // _availableTaxes para obtener el taxCode de grupo bloqueado.
  Set<String> _getUsedTaxCodes() {
    final usedIds = widget.currentTaxes
        .map((tax) => tax.idCompanySaleParameter)
        .whereType<String>()
        .toSet();

    return _availableTaxes
        .where((tax) => usedIds.contains(tax.companySaleParameterId))
        .map((tax) => tax.taxCode)
        .whereType<String>()
        .toSet();
  }

  // Verificar si un impuesto puede ser seleccionado dado el set de códigos usados
  bool _canSelectTax(SystemParameterModel tax, Set<String> usedTaxCodes) {
    return !usedTaxCodes.contains(tax.taxCode);
  }

  // Agrupar impuestos por tax_code
  Map<String, List<SystemParameterModel>> _groupTaxesByCode() {
    final Map<String, List<SystemParameterModel>> grouped = {};
    for (var tax in _availableTaxes) {
      final code = tax.taxCode ?? 'other';
      if (!grouped.containsKey(code)) {
        grouped[code] = [];
      }
      grouped[code]!.add(tax);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final usedTaxCodes = _getUsedTaxCodes();
    final groupedTaxes = _groupTaxesByCode();

    return Dialog(
      backgroundColor: AppTheme.dialogBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: AppTheme.dialogBorder, width: 1),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryButton.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.percent_rounded,
                      color: AppTheme.primaryButton, size: 30),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Builder(
                      builder: (ctx) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(ctx).selectTaxTitle,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            AppLocalizations.of(ctx).selectTaxSubtitle,
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const ContentLoadingWidget()
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: groupedTaxes.entries.map((entry) {
                        final taxCode = entry.key;
                        final taxes = entry.value;
                        final isGroupDisabled = usedTaxCodes.contains(taxCode);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Título del grupo
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 10, top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.value[0].description ??
                                          AppLocalizations.of(context)
                                              .taxGroupOther,
                                      style: TextStyle(
                                        color: isGroupDisabled
                                            ? Colors.white38
                                            : AppTheme.primaryButton,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  if (isGroupDisabled)
                                    Builder(
                                      builder: (ctx) => Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppTheme.notificationWarning
                                              .withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                            color: AppTheme.notificationWarning,
                                            width: 1,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.lock_outline_rounded,
                                              color:
                                                  AppTheme.notificationWarning,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              AppLocalizations.of(ctx)
                                                  .taxAssigned,
                                              style: const TextStyle(
                                                color: AppTheme
                                                    .notificationWarning,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Lista de impuestos del grupo
                            ...taxes.map((tax) {
                              final canSelect =
                                  _canSelectTax(tax, usedTaxCodes);
                              return _TaxItemWidget(
                                tax: tax,
                                enabled: canSelect,
                                onTap: canSelect
                                    ? () {
                                        widget.onTaxSelected(tax);
                                        Navigator.pop(context);
                                      }
                                    : null,
                              );
                            }).toList(),

                            const SizedBox(height: 10),
                          ],
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

///Widget para mostrar un item de impuesto
class _TaxItemWidget extends StatelessWidget {
  final SystemParameterModel tax;
  final bool enabled;
  final VoidCallback? onTap;

  const _TaxItemWidget({
    Key? key,
    required this.tax,
    required this.enabled,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: enabled
          ? AppTheme.white.withOpacity(0.05)
          : AppTheme.white.withOpacity(0.02),
      elevation: enabled ? 2 : 0,
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              // Icono
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: enabled
                      ? AppTheme.primaryButton.withOpacity(0.2)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text(
                    () {
                      final pct = double.tryParse(tax.percentageCode ?? '');
                      if (pct != null) {
                        final formatted =
                            pct.toStringAsFixed(pct % 1 == 0 ? 0 : 2);
                        return '$formatted%';
                      }
                      return tax.percentageCode ?? '';
                    }(),
                    style: TextStyle(
                      color: enabled ? AppTheme.primaryButton : Colors.white38,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 15),

              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tax.name ?? '',
                      style: TextStyle(
                        color: enabled ? Colors.white : Colors.white38,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      tax.description ?? '',
                      style: TextStyle(
                        color: enabled ? Colors.white60 : Colors.white24,
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // Indicador
              Icon(
                enabled ? Icons.add_circle_outline : Icons.block,
                color: enabled ? AppTheme.primaryButton : Colors.white38,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
