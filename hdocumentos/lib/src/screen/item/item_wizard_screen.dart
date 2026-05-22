import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/form/item_form_provider.dart';
import 'package:hdocumentos/src/service/item_service.dart';
import 'package:hdocumentos/src/service/notification_service.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/item/item_wizard_step1_widget.dart';
import 'package:hdocumentos/src/widgets/item/item_wizard_step2_widget.dart';
import 'package:hdocumentos/src/widgets/item/item_wizard_step3_widget.dart';
import 'package:hdocumentos/src/widgets/item/item_wizard_step4_widget.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

///Pantalla del wizard para crear/editar item
class ItemWizardScreen extends StatelessWidget {
  final ItemModel? itemToEdit;

  const ItemWizardScreen({Key? key, this.itemToEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BrackgroundWidget(),
          ChangeNotifierProvider(
            create: (ctx) {
              final provider = ItemFormProvider();
              // Si hay un item para editar, cargarlo con enriquecimiento de taxes
              if (itemToEdit != null) {
                provider.loadItem(itemToEdit!, ctx);
              }
              return provider;
            },
            child: _ItemWizardBody(isEditing: itemToEdit != null),
          ),
        ],
      ),
    );
  }
}

///Body del wizard
class _ItemWizardBody extends StatelessWidget {
  final bool isEditing;

  const _ItemWizardBody({Key? key, required this.isEditing}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            if (!isLandscape) const UserSessionTitle(),
            // ── Encabezado: título + subtítulo + botón cerrar ─────────
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: isLandscape ? 4 : 8,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isEditing ? l10n.itemEditTitle : l10n.itemCreateTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isLandscape ? 16 : size.width * 0.052,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        Text(
                          isEditing
                              ? l10n.itemEditSubtitle
                              : l10n.itemCreateSubtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: isLandscape ? 11 : size.width * 0.032,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.white.withOpacity(0.8),
                      size: isLandscape ? 22 : size.width * 0.07,
                    ),
                  ),
                ],
              ),
            ),
            // ── Contenido scrollable (stepper + formulario) ───────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const _ItemStepperIndicator(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                        vertical: isLandscape ? 8 : 12,
                      ),
                      child: const _ItemWizardContainer(),
                    ),
                  ],
                ),
              ),
            ),
            // ── Botones de navegación ─────────────────────────────────
            const _WizardNavigationButtons(),
          ],
        ),
      ),
    );
  }
}

///Indicador de pasos estilo íconos (igual al de compañía)
class _ItemStepperIndicator extends StatelessWidget {
  const _ItemStepperIndicator({Key? key}) : super(key: key);

  static const List<IconData> _stepIcons = [
    Icons.info_outline_rounded,
    Icons.attach_money_rounded,
    Icons.qr_code_rounded,
    Icons.receipt_long_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final itemForm = Provider.of<ItemFormProvider>(context);
    final current = itemForm.currentStep;
    final l10n = AppLocalizations.of(context);
    final stepLabels = [
      l10n.stepBasic,
      itemForm.isEditing ? l10n.labelDiscount : l10n.stepPrices,
      l10n.stepCodes,
      l10n.stepTaxes,
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: 6,
      ),
      child: Row(
        children: List.generate(_stepIcons.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: stepIndex < current
                      ? AppTheme.primaryButton
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final isActive = stepIndex == current;
          final isCompleted = stepIndex < current;

          return Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: (size.width * 0.065).clamp(24.0, 44.0),
                  height: (size.width * 0.065).clamp(24.0, 44.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive || isCompleted
                        ? AppTheme.primaryButton
                        : Colors.white.withOpacity(0.12),
                    border: Border.all(
                      color: isActive || isCompleted
                          ? AppTheme.primaryButton
                          : Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(Icons.check_rounded,
                            color: Colors.white,
                            size: (size.width * 0.038).clamp(12.0, 22.0))
                        : Icon(
                            _stepIcons[stepIndex],
                            color: isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                            size: (size.width * 0.038).clamp(12.0, 22.0),
                          ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  stepLabels[stepIndex],
                  style: TextStyle(
                    color:
                        isActive || isCompleted ? Colors.white : Colors.white54,
                    fontSize: (size.shortestSide * 0.026).clamp(10.0, 13.0),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

///Container principal del wizard (solo contenido del paso actual)
class _ItemWizardContainer extends StatelessWidget {
  const _ItemWizardContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemForm = Provider.of<ItemFormProvider>(context);
    return _WizardContent(currentStep: itemForm.currentStep);
  }
}

///Indicador de pasos del wizard (legacy — ya no se usa)
class _WizardStepIndicator extends StatelessWidget {
  final int currentStep;
  const _WizardStepIndicator({Key? key, required this.currentStep})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StepCircle(
          stepNumber: 1,
          isActive: currentStep >= 0,
          isCompleted: currentStep > 0,
          label: AppLocalizations.of(context).stepBasic,
        ),
        _StepConnector(isActive: currentStep > 0),
        _StepCircle(
          stepNumber: 2,
          isActive: currentStep >= 1,
          isCompleted: currentStep > 1,
          label: AppLocalizations.of(context).stepPrices,
        ),
        _StepConnector(isActive: currentStep > 1),
        _StepCircle(
          stepNumber: 3,
          isActive: currentStep >= 2,
          isCompleted: currentStep > 2,
          label: AppLocalizations.of(context).stepCodes,
        ),
        _StepConnector(isActive: currentStep > 2),
        _StepCircle(
          stepNumber: 4,
          isActive: currentStep >= 3,
          isCompleted: currentStep > 3,
          label: AppLocalizations.of(context).stepTaxes,
        ),
      ],
    );
  }
}

///Círculo indicador de paso
class _StepCircle extends StatelessWidget {
  final int stepNumber;
  final bool isActive;
  final bool isCompleted;
  final String label;

  const _StepCircle({
    Key? key,
    required this.stepNumber,
    required this.isActive,
    required this.isCompleted,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleSize = size.shortestSide * 0.1;
    final iconSize = size.shortestSide * 0.055;
    final labelFontSize = size.shortestSide * 0.028;

    return Column(
      children: [
        Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? AppTheme.primaryButton : AppTheme.grey,
            border: Border.all(
              color: isActive ? AppTheme.primaryButton : AppTheme.grey,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? Icon(Icons.check, color: Colors.white, size: iconSize)
                : Text(
                    '$stepNumber',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: iconSize * 0.8,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white54,
            fontSize: labelFontSize,
          ),
        ),
      ],
    );
  }
}

///Conector entre pasos
class _StepConnector extends StatelessWidget {
  final bool isActive;

  const _StepConnector({Key? key, required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.06,
      height: 2,
      color: isActive ? AppTheme.primaryButton : AppTheme.grey,
    );
  }
}

///Contenido del paso actual
class _WizardContent extends StatelessWidget {
  final int currentStep;

  const _WizardContent({Key? key, required this.currentStep}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 0:
        return const ItemWizardStep1Widget();
      case 1:
        return const ItemWizardStep2Widget();
      case 2:
        return const ItemWizardStep3Widget();
      case 3:
        return const ItemWizardStep4Widget();
      default:
        return const ItemWizardStep1Widget();
    }
  }
}

///Botones de navegación del wizard
class _WizardNavigationButtons extends StatelessWidget {
  const _WizardNavigationButtons({Key? key}) : super(key: key);

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
                  borderRadius: BorderRadius.circular(10)),
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
                        borderRadius: BorderRadius.circular(10)),
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
                        borderRadius: BorderRadius.circular(10)),
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
