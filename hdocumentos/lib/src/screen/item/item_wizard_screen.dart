import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/form/item_form_provider.dart';
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
            create: (_) {
              final provider = ItemFormProvider();
              // Si hay un item para editar, cargarlo
              if (itemToEdit != null) {
                provider.loadItem(itemToEdit!);
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
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.02),
            PageTitleWidget(
                title: isEditing
                    ? AppLocalizations.of(context).itemEditTitle
                    : AppLocalizations.of(context).itemCreateTitle),
            SizedBox(height: size.height * 0.025),
            const _ItemWizardContainer(),
          ],
        ),
      ),
    );
  }
}

///Container principal del wizard
class _ItemWizardContainer extends StatelessWidget {
  const _ItemWizardContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemForm = Provider.of<ItemFormProvider>(context);
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          _WizardStepIndicator(currentStep: itemForm.currentStep),
          SizedBox(height: size.height * 0.025),
          _WizardContent(currentStep: itemForm.currentStep),
          SizedBox(height: size.height * 0.025),
          const _WizardNavigationButtons(),
          SizedBox(height: size.height * 0.06),
        ],
      ),
    );
  }
}

///Indicador de pasos del wizard
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
        SizedBox(height: size.height * 0.005),
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
    final btnPadding = EdgeInsets.symmetric(
      horizontal: size.width * 0.05,
      vertical: size.height * 0.015,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botón Anterior / Cancelar
        if (itemForm.currentStep > 0)
          ElevatedButton.icon(
            onPressed:
                itemForm.isLoading ? null : () => itemForm.previousStep(),
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text(l10n.btnPrevious),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.grey,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: btnPadding,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          )
        else
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close_rounded),
            label: Text(l10n.btnCancel),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.actionDanger,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: btnPadding,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),

        // Botón Siguiente / Guardar
        if (itemForm.currentStep < 3)
          ElevatedButton.icon(
            onPressed: itemForm.isLoading
                ? null
                : () {
                    if (itemForm.nextStep()) {
                      // Paso validado y avanzado
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.msgRequiredFields),
                          backgroundColor: AppTheme.actionDanger,
                        ),
                      );
                    }
                  },
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(l10n.btnNext),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryButton,
              foregroundColor: AppTheme.secondary,
              elevation: 0,
              padding: btnPadding,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          )
        else
          ElevatedButton.icon(
            onPressed: itemForm.isLoading
                ? null
                : () => _onSaveItem(context, itemForm),
            icon: itemForm.isLoading
                ? const ButtonLoadingIndicator()
                : const Icon(Icons.save_rounded),
            label: Text(itemForm.isLoading ? l10n.btnSaving : l10n.btnSave),
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
    );
  }

  Future<void> _onSaveItem(
      BuildContext context, ItemFormProvider itemForm) async {
    // Validar último paso
    if (!itemForm.isValidCurrentStep()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).msgRequiredFields),
          backgroundColor: AppTheme.actionDanger,
        ),
      );
      return;
    }

    itemForm.isLoading = true;

    try {
      // Construir el modelo
      final item = itemForm.buildItemModel();

      // TODO: Aquí llamar al servicio para guardar el item
      // await ItemService.createItem(item);
      debugPrint('Item guardado: ${item.name}');

      // Simulación temporal
      await Future.delayed(const Duration(seconds: 2));

      itemForm.isLoading = false;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).itemCreatedSuccess),
            backgroundColor: AppTheme.actionSave,
          ),
        );

        // Resetear formulario y volver
        itemForm.reset();
        Navigator.pop(context, true); // Retorna true para indicar que se guardó
      }
    } catch (e) {
      itemForm.isLoading = false;
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).saveError(e.toString())),
            backgroundColor: AppTheme.actionDanger,
          ),
        );
      }
    }
  }
}
