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

  /// Índice en la lista del punto que se está editando (-1 si es nuevo)
  int _editingIndex = -1;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanyFormProvider>().initEmissionPointSelection();
    });
  }

  void _openNewForm() {
    final provider = context.read<CompanyFormProvider>();
    final alreadyHasActive = provider.emissionPoints.any((p) => p.isActive);
    setState(() {
      _isNewPoint = true;
      _editingIndex = -1;
      _editingPoint = CompanyEmissionPointModel(
        state: alreadyHasActive ? 'INACTIVE' : 'ACTIVE',
      );
    });
  }

  void _openEditForm(CompanyEmissionPointModel point, int index) {
    setState(() {
      _isNewPoint = false;
      _editingIndex = index;
      _editingPoint = point;
    });
  }

  void _closeForm() {
    setState(() {
      _editingPoint = null;
      _isNewPoint = false;
      _editingIndex = -1;
    });
  }

  void _savePoint(BuildContext context, CompanyEmissionPointModel point) {
    final provider = context.read<CompanyFormProvider>();
    provider.upsertEmissionPoint(point, editingIndex: _editingIndex);
    if (provider.emissionPoints.length == 1 ||
        provider.selectedEmissionPointIndex == null) {
      provider.selectActiveEmissionPoint(point);
    }
    _closeForm();
  }

  void _deletePoint(
      BuildContext context, CompanyEmissionPointModel point, int index) {
    showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppTheme.dialogBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.dialogBorder, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.actionDelete.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppTheme.actionDelete,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(ctx).emissionPointDeleteConfirm,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textSecondary,
                        side: const BorderSide(color: AppTheme.dialogBorder),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child:
                          Text(AppLocalizations.of(ctx).emissionPointCancelBtn),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(ctx, true),
                      icon: const Icon(Icons.delete_rounded, size: 18),
                      label:
                          Text(AppLocalizations.of(ctx).emissionPointDeleteBtn),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.actionDelete,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
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

    final submitted = provider.step5Submitted;
    final hasPoints = provider.emissionPoints.isNotEmpty;
    final hasActivePoint = provider.emissionPoints.any((p) => p.isActive);
    final showError = submitted && (!hasPoints || !hasActivePoint);

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
          // Error: sin puntos de emisión o sin selección activa
          if (showError && _editingPoint == null)
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.008, left: size.width * 0.02),
              child: Row(
                children: [
                  const Icon(Icons.error_outline,
                      color: Colors.redAccent, size: 14),
                  SizedBox(width: size.width * 0.015),
                  Text(
                    !hasPoints
                        ? l10n.emissionPointRequired
                        : l10n.emissionPointSelectRequired,
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: size.width * 0.03,
                    ),
                  ),
                ],
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
                          onEdit: () => _openEditForm(entry.value, entry.key),
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
              existingPoints: provider.emissionPoints,
              editingIndex: _editingIndex,
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

  /// Lista actual de puntos (para validar duplicados y punto activo único)
  final List<CompanyEmissionPointModel> existingPoints;

  /// Índice que se está editando (-1 si es nuevo)
  final int editingIndex;

  const _EmissionPointForm({
    super.key,
    required this.initial,
    required this.isNew,
    required this.docTypes,
    required this.size,
    required this.onSave,
    required this.onCancel,
    required this.existingPoints,
    required this.editingIndex,
  });

  @override
  State<_EmissionPointForm> createState() => _EmissionPointFormState();
}

class _EmissionPointFormState extends State<_EmissionPointForm> {
  final _formKey = GlobalKey<FormState>();

  late String? _documentTypeId;
  late String? _establishmentCode;
  late String? _emissionPointCode;
  late String? _description;
  late String _state;

  @override
  void initState() {
    super.initState();
    final p = widget.initial;
    _documentTypeId = p.documentTypeId;
    _establishmentCode = p.establishmentCode;
    _emissionPointCode = p.emissionPointCode;
    _description = p.description;
    _state = p.state ?? 'ACTIVE';
  }

  /// Devuelve true si ya existe otro punto (distinto al que se edita)
  /// con la misma combinación tipo de documento + establecimiento + punto de emisión.
  /// Ejemplo: factura-001-001 y factura-001-002 → permitido (distinto código)
  ///          factura-001-001 y factura-001-001 → NO permitido (combinación idéntica)
  ///          factura-001-001 y nota_credito-001-001 → permitido (distinto tipo)
  bool _isDuplicateCode(String? docTypeId, String? estCode, String? epCode) {
    if (docTypeId == null || estCode == null || epCode == null) return false;
    for (var i = 0; i < widget.existingPoints.length; i++) {
      if (i == widget.editingIndex) continue; // saltar el que se edita
      final p = widget.existingPoints[i];
      if (p.documentTypeId == docTypeId &&
          p.establishmentCode == estCode &&
          p.emissionPointCode == epCode) {
        return true;
      }
    }
    return false;
  }

  /// Devuelve true si hay otro punto activo (distinto al que se edita).
  bool _otherPointIsActive() {
    for (var i = 0; i < widget.existingPoints.length; i++) {
      if (i == widget.editingIndex) continue;
      if (widget.existingPoints[i].isActive) return true;
    }
    return false;
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    widget.onSave(widget.initial.copyWith(
      documentTypeId: _documentTypeId,
      establishmentCode: _establishmentCode,
      emissionPointCode: _emissionPointCode,
      description: _description,
      state: _state,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = widget.size;

    // Pre-calcular si hay otro punto activo (para deshabilitar el switch)
    final otherActive = _otherPointIsActive();

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
              // Re-validar al cambiar el tipo para reflejar cambios en duplicados
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
                (v) {
                  if (_isDuplicateCode(
                      _documentTypeId, v, _emissionPointCode)) {
                    return l10n.emissionPointDuplicateCode;
                  }
                  return null;
                },
              ]),
              onChanged: (v) => setState(() => _establishmentCode = v),
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
                (v) {
                  if (_isDuplicateCode(
                      _documentTypeId, _establishmentCode, v)) {
                    return l10n.emissionPointDuplicateCode;
                  }
                  return null;
                },
              ]),
              onChanged: (v) => setState(() => _emissionPointCode = v),
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
            // Dropdown deshabilitado (opaco) si ya hay otro punto activo y
            // este punto no es el activo (evita tener dos activos a la vez)
            Opacity(
              opacity: (otherActive && _state == 'INACTIVE') ? 0.45 : 1.0,
              child: IgnorePointer(
                ignoring: otherActive && _state == 'INACTIVE',
                child: DropdownButtonFieldWidget(
                  prefixIcon: Icons.toggle_on_outlined,
                  labelText: l10n.activeEmissionPoint,
                  items: [
                    KeyValueModel(
                        key: 'ACTIVE', value: l10n.emissionPointActiveChip),
                    KeyValueModel(
                        key: 'INACTIVE', value: l10n.emissionPointInactiveChip),
                  ],
                  initialValue: _state,
                  onChanged: (v) => setState(() => _state = v ?? 'ACTIVE'),
                ),
              ),
            ),
            // Aviso cuando el dropdown está deshabilitado por otro punto activo
            if (otherActive && _state == 'INACTIVE')
              Padding(
                padding: EdgeInsets.only(
                    top: size.height * 0.005, left: size.width * 0.02),
                child: Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.orangeAccent, size: size.width * 0.035),
                    SizedBox(width: size.width * 0.015),
                    Expanded(
                      child: Text(
                        l10n.emissionPointOnlyOneActive,
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: size.width * 0.028,
                        ),
                      ),
                    ),
                  ],
                ),
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
          if (company.additionalInformation?.website?.isNotEmpty == true)
            _SummaryRow(
                label: l10n.summaryWebsite,
                value: company.additionalInformation!.website,
                size: size),
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
            value: company.certificateData?.certificatePath != null
                ? l10n.summaryCertLoaded
                : l10n.summaryCertNotLoaded,
            size: size,
            valueColor: company.certificateData?.certificatePath != null
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
