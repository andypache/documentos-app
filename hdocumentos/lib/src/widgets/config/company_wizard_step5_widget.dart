import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/common/key_value_model.dart';
import 'package:hdocumentos/src/model/config/company_model.dart';
import 'package:hdocumentos/src/provider/app_init_provider.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

// ─── Paso 5: Puntos de Emisión ────────────────────────────────────────────────

/// Paso 5: Gestión de puntos de emisión (lista + selección activo)
class CompanyWizardStep5Widget extends StatefulWidget {
  const CompanyWizardStep5Widget({Key? key}) : super(key: key);

  @override
  State<CompanyWizardStep5Widget> createState() =>
      _CompanyWizardStep5WidgetState();
}

class _CompanyWizardStep5WidgetState extends State<CompanyWizardStep5Widget> {
  /// null = formulario oculto, non-null = editando/creando ese punto
  CompanyEmissionPointModel? _editingPoint;
  bool _isNewPoint = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyFormProvider>().initEmissionPointSelection();
    });
  }

  void _openNewForm() {
    setState(() {
      _isNewPoint = true;
      _editingPoint = const CompanyEmissionPointModel(
        isActive: true,
        currentSequential: 1,
      );
    });
  }

  void _openEditForm(CompanyEmissionPointModel point) {
    setState(() {
      _isNewPoint = false;
      _editingPoint = point;
    });
  }

  void _closeForm() {
    setState(() {
      _editingPoint = null;
      _isNewPoint = false;
    });
  }

  void _savePoint(BuildContext context, CompanyEmissionPointModel point) {
    final provider = context.read<CompanyFormProvider>();
    provider.upsertEmissionPoint(point);
    if (provider.emissionPoints.length == 1 ||
        provider.selectedEmissionPointIndex == null) {
      provider.selectActiveEmissionPoint(point);
    }
    _closeForm();
  }

  void _deletePoint(
      BuildContext context, CompanyEmissionPointModel point, int index) {
    final l10n = AppLocalizations.of(context);
    showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.cardBackground,
        title: Text(
          l10n.emissionPointDeleteConfirm,
          style: const TextStyle(color: AppTheme.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.emissionPointCancelBtn,
                style: const TextStyle(color: AppTheme.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.emissionPointDeleteBtn,
                style: const TextStyle(color: AppTheme.actionDelete)),
          ),
        ],
      ),
    ).then((confirmed) {
      if (confirmed == true && context.mounted) {
        context.read<CompanyFormProvider>().removeEmissionPoint(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CompanyFormProvider>(context);
    final catalogs = context.watch<AppInitProvider>().catalogs;
    final List<KeyValueModel> docTypes = catalogs?.documentTypes
            .map((e) => KeyValueModel(key: e.code, value: e.description))
            .toList() ??
        [];

    return Form(
      key: provider.formKeyStep5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyWizardSectionHeader(
            icon: Icons.point_of_sale_outlined,
            title: l10n.step5Title,
            size: size,
          ),
          SizedBox(height: size.height * 0.018),
          if (_editingPoint == null)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _openNewForm,
                icon: Icon(Icons.add_circle_outline,
                    color: AppTheme.primaryButton, size: size.width * 0.05),
                label: Text(
                  l10n.emissionPointAddBtn,
                  style: TextStyle(
                    color: AppTheme.primaryButton,
                    fontSize: size.width * 0.036,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(
                      color: AppTheme.primaryButton, width: 1.5),
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.014),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          if (_editingPoint == null) ...[
            SizedBox(height: size.height * 0.015),
            if (provider.emissionPoints.isEmpty)
              _EmptyEmissionPointsWidget(size: size, l10n: l10n)
            else
              Column(
                children: provider.emissionPoints
                    .asMap()
                    .entries
                    .map((entry) => _EmissionPointCard(
                          point: entry.value,
                          isSelected:
                              provider.selectedEmissionPointIndex == entry.key,
                          docTypes: docTypes,
                          size: size,
                          onSelect: () =>
                              provider.selectActiveEmissionPoint(entry.value),
                          onEdit: () => _openEditForm(entry.value),
                          onDelete: () =>
                              _deletePoint(context, entry.value, entry.key),
                        ))
                    .toList(),
              ),
          ],
          if (_editingPoint != null)
            _EmissionPointForm(
              key: ValueKey(_editingPoint!.id),
              initial: _editingPoint!,
              isNew: _isNewPoint,
              docTypes: docTypes,
              size: size,
              onSave: (point) => _savePoint(context, point),
              onCancel: _closeForm,
            ),
          SizedBox(height: size.height * 0.025),
          if (_editingPoint == null) _FinalSummaryWidget(size: size),
        ],
      ),
    );
  }
}

// ─── Card de un punto de emisión ─────────────────────────────────────────────

class _EmissionPointCard extends StatelessWidget {
  final CompanyEmissionPointModel point;
  final bool isSelected;
  final List<KeyValueModel> docTypes;
  final Size size;
  final VoidCallback onSelect;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _EmissionPointCard({
    required this.point,
    required this.isSelected,
    required this.docTypes,
    required this.size,
    required this.onSelect,
    required this.onEdit,
    required this.onDelete,
  });

  String _docTypeName() {
    final match =
        docTypes.where((e) => e.key == point.documentTypeId).firstOrNull;
    return match?.value?.toString() ?? point.documentTypeId ?? '—';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: EdgeInsets.only(bottom: size.height * 0.012),
      decoration: BoxDecoration(
        color: isSelected
            ? AppTheme.primaryButton.withOpacity(0.13)
            : AppTheme.cardBackground.withOpacity(0.45),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? AppTheme.primaryButton
              : AppTheme.textSecondary.withOpacity(0.25),
          width: isSelected ? 1.8 : 1,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppTheme.primaryButton.withOpacity(0.18),
                  blurRadius: 8,
                  spreadRadius: 1,
                )
              ]
            : [],
      ),
      child: InkWell(
        onTap: onSelect,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.04,
            vertical: size.height * 0.013,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: size.width * 0.055,
                height: size.width * 0.055,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      isSelected ? AppTheme.primaryButton : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryButton
                        : AppTheme.textSecondary.withOpacity(0.5),
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Icon(Icons.check_rounded,
                        color: AppTheme.white, size: size.width * 0.033)
                    : null,
              ),
              SizedBox(width: size.width * 0.03),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${point.establishmentCode ?? '???'}-${point.emissionPointCode ?? '???'}',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: size.width * 0.038,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: size.height * 0.003),
                    Text(
                      _docTypeName(),
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: size.width * 0.029,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (point.description?.isNotEmpty == true) ...[
                      SizedBox(height: size.height * 0.002),
                      Text(
                        point.description!,
                        style: TextStyle(
                          color: AppTheme.textSecondary.withOpacity(0.7),
                          fontSize: size.width * 0.027,
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: size.width * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.022,
                      vertical: size.height * 0.003,
                    ),
                    decoration: BoxDecoration(
                      color: point.isActive
                          ? AppTheme.actionSave.withOpacity(0.18)
                          : AppTheme.actionDelete.withOpacity(0.18),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      point.isActive
                          ? l10n.emissionPointActiveChip
                          : l10n.emissionPointInactiveChip,
                      style: TextStyle(
                        color: point.isActive
                            ? AppTheme.actionSave
                            : AppTheme.actionDelete,
                        fontSize: size.width * 0.025,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.006),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ActionIconBtn(
                        icon: Icons.edit_outlined,
                        color: AppTheme.primaryButton,
                        size: size.width * 0.042,
                        onPressed: onEdit,
                      ),
                      SizedBox(width: size.width * 0.015),
                      _ActionIconBtn(
                        icon: Icons.delete_outline_rounded,
                        color: AppTheme.actionDelete,
                        size: size.width * 0.042,
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Widget cuando la lista está vacía ───────────────────────────────────────

class _EmptyEmissionPointsWidget extends StatelessWidget {
  final Size size;
  final AppLocalizations l10n;
  const _EmptyEmissionPointsWidget({required this.size, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: size.height * 0.04,
        horizontal: size.width * 0.06,
      ),
      decoration: BoxDecoration(
        color: AppTheme.cardBackground.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.textSecondary.withOpacity(0.2),
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.point_of_sale_outlined,
            color: AppTheme.textSecondary.withOpacity(0.4),
            size: size.width * 0.12,
          ),
          SizedBox(height: size.height * 0.012),
          Text(
            l10n.emissionPointEmptyMsg,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.textSecondary.withOpacity(0.7),
              fontSize: size.width * 0.033,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Formulario de nuevo / editar punto ──────────────────────────────────────

class _EmissionPointForm extends StatefulWidget {
  final CompanyEmissionPointModel initial;
  final bool isNew;
  final List<KeyValueModel> docTypes;
  final Size size;
  final ValueChanged<CompanyEmissionPointModel> onSave;
  final VoidCallback onCancel;

  const _EmissionPointForm({
    super.key,
    required this.initial,
    required this.isNew,
    required this.docTypes,
    required this.size,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<_EmissionPointForm> createState() => _EmissionPointFormState();
}

class _EmissionPointFormState extends State<_EmissionPointForm> {
  final _formKey = GlobalKey<FormState>();

  late String? _documentTypeId;
  late String? _establishmentCode;
  late String? _emissionPointCode;
  late int _currentSequential;
  late String? _description;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _documentTypeId = p.documentTypeId;
    _establishmentCode = p.establishmentCode;
    _emissionPointCode = p.emissionPointCode;
    _currentSequential = p.currentSequential ?? 1;
    _description = p.description;
    _isActive = p.isActive;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSave(widget.initial.copyWith(
      documentTypeId: _documentTypeId,
      establishmentCode: _establishmentCode,
      emissionPointCode: _emissionPointCode,
      currentSequential: _currentSequential,
      description: _description,
      isActive: _isActive,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = widget.size;

    return Container(
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: AppTheme.primaryButton.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppTheme.primaryButton.withOpacity(0.35), width: 1.2),
      ),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  widget.isNew ? Icons.add_circle_outline : Icons.edit_outlined,
                  color: AppTheme.primaryButton,
                  size: size.width * 0.048,
                ),
                SizedBox(width: size.width * 0.025),
                Text(
                  widget.isNew
                      ? l10n.emissionPointFormTitle
                      : l10n.emissionPointEditFormTitle,
                  style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: size.width * 0.038,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.018),
            DropdownButtonFieldWidget(
              prefixIcon: Icons.description_outlined,
              labelText: l10n.docType,
              hintText: l10n.docTypeHint,
              items: widget.docTypes,
              filled: true,
              fillColor: AppTheme.whiteGradient,
              initialValue: _documentTypeId,
              onChanged: (v) => setState(() => _documentTypeId = v),
            ),
            SizedBox(height: size.height * 0.015),
            InputFieldWidget(
              prefixIcon: Icons.store_mall_directory_outlined,
              labelText: l10n.establishmentCode,
              hintText: l10n.establishmentCodeHint,
              initialValue: _establishmentCode,
              filled: true,
              fillColor: AppTheme.whiteGradient,
              validator: FieldValidators.compose([
                FieldValidators.required(l10n),
                FieldValidators.exactLength(l10n, 3),
              ]),
              onChanged: (v) => _establishmentCode = v,
            ),
            SizedBox(height: size.height * 0.015),
            InputFieldWidget(
              prefixIcon: Icons.receipt_long_outlined,
              labelText: l10n.emissionPointCode,
              hintText: l10n.emissionPointCodeHint,
              initialValue: _emissionPointCode,
              filled: true,
              fillColor: AppTheme.whiteGradient,
              validator: FieldValidators.compose([
                FieldValidators.required(l10n),
                FieldValidators.exactLength(l10n, 3),
              ]),
              onChanged: (v) => _emissionPointCode = v,
            ),
            SizedBox(height: size.height * 0.015),
            InputNumberFieldWidget(
              prefixIcon: Icons.format_list_numbered,
              labelText: l10n.currentSequential,
              hintText: l10n.currentSequentialHint,
              initialValue: _currentSequential.toDouble(),
              validator: FieldValidators.compose([
                FieldValidators.required(l10n),
              ]),
              onChanged: (v) =>
                  _currentSequential = int.tryParse(v) ?? _currentSequential,
            ),
            SizedBox(height: size.height * 0.015),
            InputFieldWidget(
              prefixIcon: Icons.notes_outlined,
              labelText: l10n.emissionDescription,
              hintText: l10n.emissionDescriptionHint,
              initialValue: _description,
              filled: true,
              fillColor: AppTheme.whiteGradient,
              onChanged: (v) => _description = v,
            ),
            SizedBox(height: size.height * 0.015),
            InputSwitchFieldWidget(
              label: l10n.activeEmissionPoint,
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: widget.onCancel,
                    icon: Icon(Icons.close_rounded,
                        size: size.width * 0.042,
                        color: AppTheme.textSecondary),
                    label: Text(
                      l10n.emissionPointCancelBtn,
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: size.width * 0.033,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: AppTheme.textSecondary.withOpacity(0.4)),
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.012),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.03),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: Icon(Icons.save_rounded, size: size.width * 0.042),
                    label: Text(
                      l10n.emissionPointSaveBtn,
                      style: TextStyle(
                        fontSize: size.width * 0.033,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryButton,
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.012),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Botón de acción con icono ────────────────────────────────────────────────

class _ActionIconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final VoidCallback onPressed;

  const _ActionIconBtn({
    required this.icon,
    required this.color,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Icon(icon, color: color, size: size),
      ),
    );
  }
}

// ─── Resumen final completo ───────────────────────────────────────────────────

class _FinalSummaryWidget extends StatelessWidget {
  final Size size;
  const _FinalSummaryWidget({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final provider = Provider.of<CompanyFormProvider>(context);
    final company = provider.company;

    final idx = provider.selectedEmissionPointIndex;
    final selectedPoint =
        (idx != null && idx >= 0 && idx < company.emissionPoints.length)
            ? company.emissionPoints[idx]
            : null;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: AppTheme.primaryButton.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppTheme.primaryButton.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.checklist_rtl,
                  color: AppTheme.primaryButton, size: size.width * 0.048),
              SizedBox(width: size.width * 0.02),
              Text(
                l10n.finalSummaryTitle,
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: size.width * 0.038,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(
              color: AppTheme.textSecondary.withOpacity(0.2),
              height: size.height * 0.025),
          _SummaryRow(
              label: l10n.summaryCompanyName,
              value: company.businessName,
              size: size),
          _SummaryRow(
              label: l10n.summaryIdentification,
              value: company.identification,
              size: size),
          _SummaryRow(
              label: l10n.summaryAddress, value: company.address, size: size),
          _SummaryRow(
              label: l10n.summaryEmail, value: company.email, size: size),
          if (company.website?.isNotEmpty == true)
            _SummaryRow(
                label: l10n.summaryWebsite, value: company.website, size: size),
          if (selectedPoint != null) ...[
            _SummaryRow(
                label: l10n.summaryEstablishment,
                value: selectedPoint.establishmentCode,
                size: size),
            _SummaryRow(
                label: l10n.summaryEmissionPoint,
                value: selectedPoint.emissionPointCode,
                size: size),
          ],
          _SummaryRow(
            label: l10n.summaryCertificate,
            value: company.certificatePath != null
                ? l10n.summaryCertLoaded
                : l10n.summaryCertNotLoaded,
            size: size,
            valueColor: company.certificatePath != null
                ? AppTheme.actionSave
                : AppTheme.actionDelete,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String? value;
  final Size size;
  final Color? valueColor;
  const _SummaryRow(
      {Key? key,
      required this.label,
      required this.value,
      required this.size,
      this.valueColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.007),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: size.width * 0.3,
            child: Text(
              '$label:',
              style: TextStyle(
                color: AppTheme.textSecondary.withOpacity(0.7),
                fontSize: size.width * 0.03,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value!,
              style: TextStyle(
                color: valueColor ?? AppTheme.textPrimary,
                fontSize: size.width * 0.03,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
