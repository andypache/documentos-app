import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/item/item_tax_model.dart';
import 'package:hdocumentos/src/model/item/system_parameter_model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

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
  List<SystemParameterModel> _availableTaxes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTaxes();
  }

  Future<void> _loadTaxes() async {
    setState(() => _isLoading = true);

    // TODO: Reemplazar con llamada real al servicio
    await Future.delayed(const Duration(milliseconds: 500));

    // Datos de ejemplo basados en la tabla proporcionada
    _availableTaxes = [
      SystemParameterModel(
        systemParameterId: "1",
        name: "IVA 0",
        description: "Impuesto al valor agregado de una venta",
        companySystemParameter: "1",
        numberParameter: 0,
        isTaxSale: "S",
        taxCode: "2",
        percentageCode: "0",
      ),
      SystemParameterModel(
        systemParameterId: "2",
        name: "IVA 12",
        description: "Impuesto al valor agregado de una venta",
        companySystemParameter: "2",
        numberParameter: 12,
        isTaxSale: "S",
        taxCode: "2",
        percentageCode: "2",
      ),
      SystemParameterModel(
        systemParameterId: "3",
        name: "IVA 14",
        description: "Impuesto al valor agregado de una venta",
        companySystemParameter: "3",
        numberParameter: 14,
        isTaxSale: "S",
        taxCode: "2",
        percentageCode: "4",
      ),
      SystemParameterModel(
        systemParameterId: "4",
        name: "NO OBJETO IVA",
        description: "Impuesto al valor agregado de una venta",
        companySystemParameter: "4",
        numberParameter: 0,
        isTaxSale: "S",
        taxCode: "2",
        percentageCode: "6",
      ),
      SystemParameterModel(
        systemParameterId: "5",
        name: "EXENTO IVA",
        description: "Impuesto al valor agregado de una venta",
        companySystemParameter: "5",
        numberParameter: 0,
        isTaxSale: "S",
        taxCode: "2",
        percentageCode: "7",
      ),
      SystemParameterModel(
        systemParameterId: "6",
        name: "ICE Perfumes y Aguas de Tocador",
        description: "Impuesto a los consumos especiales",
        companySystemParameter: "6",
        numberParameter: 20,
        isTaxSale: "S",
        taxCode: "3",
        percentageCode: "3610",
      ),
      SystemParameterModel(
        systemParameterId: "7",
        name: "ICE Bebidas Energizantes",
        description: "Impuesto a los consumos especiales",
        companySystemParameter: "7",
        numberParameter: 10,
        isTaxSale: "S",
        taxCode: "3",
        percentageCode: "3101",
      ),
      SystemParameterModel(
        systemParameterId: "8",
        name: "ICE Bebidas No Alcohólicas",
        description: "Impuesto a los consumos especiales",
        companySystemParameter: "8",
        numberParameter: 0.18,
        isTaxSale: "S",
        taxCode: "3",
        percentageCode: "3111",
      ),
      SystemParameterModel(
        systemParameterId: "9",
        name: "ICE FUNDAS PLÁSTICAS",
        description: "Impuesto a los consumos especiales",
        companySystemParameter: "9",
        numberParameter: 0.04,
        isTaxSale: "S",
        taxCode: "3",
        percentageCode: "3680",
      ),
      SystemParameterModel(
        systemParameterId: "10",
        name: "ICE Perfumes Aguas de Tocador Cae",
        description: "Impuesto a los consumos especiales",
        companySystemParameter: "10",
        numberParameter: 20,
        isTaxSale: "S",
        taxCode: "3",
        percentageCode: "3710",
      ),
      SystemParameterModel(
        systemParameterId: "11",
        name: "ICE BEBIDAS NO ALCOHOLICAS SENAE",
        description: "Impuesto a los consumos especiales",
        companySystemParameter: "11",
        numberParameter: 0.18,
        isTaxSale: "S",
        taxCode: "3",
        percentageCode: "3602",
      ),
      SystemParameterModel(
        systemParameterId: "19",
        name: "IVA 8",
        description: "Impuesto al valor agregado de una venta diferenciado",
        companySystemParameter: "19",
        numberParameter: 8,
        isTaxSale: "S",
        taxCode: "2",
        percentageCode: "8",
      ),
      SystemParameterModel(
        systemParameterId: "20",
        name: "IVA 15",
        description: "Impuesto al valor agregado de una venta",
        companySystemParameter: "20",
        numberParameter: 15,
        isTaxSale: "S",
        taxCode: "2",
        percentageCode: "4",
      ),
    ];

    setState(() => _isLoading = false);
  }

  // Obtener los tax_code ya utilizados en los impuestos actuales
  Set<String> _getUsedTaxCodes() {
    return widget.currentTaxes
        .where((tax) =>
            tax.companySystemParameter?.systemParameter?.taxCode != null)
        .map((tax) => tax.companySystemParameter!.systemParameter!.taxCode!)
        .toSet();
  }

  // Verificar si un impuesto puede ser seleccionado
  bool _canSelectTax(SystemParameterModel tax) {
    final usedTaxCodes = _getUsedTaxCodes();
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

  String _getTaxGroupName(String taxCode) {
    switch (taxCode) {
      case '2':
        return 'IVA (Impuesto al Valor Agregado)';
      case '3':
        return 'ICE (Impuesto a Consumos Especiales)';
      default:
        return 'Otros Impuestos';
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedTaxes = _groupTaxesByCode();
    final usedTaxCodes = _getUsedTaxCodes();

    return Dialog(
      backgroundColor: AppTheme.secondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
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
                  const Icon(Icons.percent,
                      color: AppTheme.primaryButton, size: 30),
                  const SizedBox(width: 15),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seleccionar Impuesto',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Solo puede agregar un impuesto por grupo',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryButton,
                      ),
                    )
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
                                      _getTaxGroupName(taxCode),
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
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.orange,
                                          width: 1,
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.lock_outline,
                                            color: Colors.orange,
                                            size: 14,
                                          ),
                                          SizedBox(width: 4),
                                          Text(
                                            'Ya asignado',
                                            style: TextStyle(
                                              color: Colors.orange,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                            ),

                            // Lista de impuestos del grupo
                            ...taxes.map((tax) {
                              final canSelect = _canSelectTax(tax);
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
                    '${tax.numberParameter?.toStringAsFixed(tax.numberParameter! % 1 == 0 ? 0 : 2)}%',
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
