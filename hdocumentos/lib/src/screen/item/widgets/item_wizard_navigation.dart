import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/form/item_form_provider.dart';
import 'package:hdocumentos/src/service/item_service.dart';
import 'package:hdocumentos/src/service/notification_service.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Botones de navegación del wizard de item con lógica de guardado
class ItemWizardNavigation extends StatelessWidget {
  const ItemWizardNavigation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemForm = Provider.of<ItemFormProvider>(context);
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);
    final bool busy = itemForm.isLoading;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final double iconSize = isLandscape ? 18.0 : size.width * 0.045;
    final double fontSize = isLandscape ? 13.0 : size.width * 0.034;
    final EdgeInsets btnPadding = EdgeInsets.symmetric(
      horizontal: isLandscape ? 16.0 : size.width * 0.05,
      vertical: 10,
    );

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 16.0 : size.width * 0.05,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // ── Anterior / Cancelar ───────────────────────────────────
          ElevatedButton.icon(
            onPressed: busy
                ? null
                : () {
                    if (itemForm.currentStep > 0) {
                      itemForm.previousStep();
                    } else {
                      Navigator.pop(context);
                    }
                  },
            icon: Icon(
              itemForm.currentStep > 0
                  ? Icons.arrow_back_rounded
                  : Icons.close_rounded,
              size: iconSize,
            ),
            label: Text(
              itemForm.currentStep > 0 ? l10n.btnPrevious : l10n.btnCancel,
              style: TextStyle(fontSize: fontSize),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: itemForm.currentStep > 0
                  ? AppTheme.grey
                  : AppTheme.actionDanger,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: btnPadding,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusM)),
            ),
          ),

          // ── Indicador de paso ─────────────────────────────────────
          Text(
            l10n.stepCounter(itemForm.currentStep + 1, 4),
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: isLandscape ? 12.0 : size.width * 0.032,
            ),
          ),

          // ── Siguiente / Guardar ───────────────────────────────────
          itemForm.currentStep < 3
              ? ElevatedButton.icon(
                  onPressed: busy
                      ? null
                      : () {
                          if (!itemForm.nextStep()) {
                            NotificationService.showError(
                                l10n.msgRequiredFields);
                          }
                        },
                  icon: Icon(Icons.arrow_forward_rounded, size: iconSize),
                  label: Text(l10n.btnNext,
                      style: TextStyle(
                          fontSize: fontSize, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryButton,
                    foregroundColor: AppTheme.secondary,
                    elevation: 0,
                    padding: btnPadding,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusM)),
                  ),
                )
              : ElevatedButton.icon(
                  onPressed: busy ? null : () => _onSaveItem(context, itemForm),
                  icon: busy
                      ? ButtonLoadingIndicator(size: iconSize)
                      : Icon(Icons.save_rounded, size: iconSize),
                  label: Text(
                    busy ? l10n.btnSaving : l10n.btnSave,
                    style: TextStyle(
                        fontSize: fontSize, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.actionSave,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: btnPadding,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusM)),
                  ),
                ),
        ],
      ),
    );
  }

  Future<void> _onSaveItem(
      BuildContext context, ItemFormProvider itemForm) async {
    // Validar último paso
    if (!itemForm.isValidCurrentStep()) {
      NotificationService.showError(
          AppLocalizations.of(context).msgRequiredFields);
      return;
    }

    itemForm.isLoading = true;

    try {
      // Llamar al servicio según modo crear o editar
      if (itemForm.isEditing) {
        await ItemService.updateItem(context, itemForm);
      } else {
        await ItemService.createItem(context, itemForm);
      }

      itemForm.isLoading = false;

      if (context.mounted) {
        itemForm.reset();
        Navigator.pop(context, true);

        NotificationService.showSuccess(
            AppLocalizations.of(context).itemCreatedSuccess);
      }
    } catch (e) {
      itemForm.isLoading = false;
      if (context.mounted) {
        NotificationService.showError(
            AppLocalizations.of(context).saveError(e.toString()));
      }
    }
  }
}
