import 'package:flutter/material.dart';
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
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 45),
          PageTitleWidget(
              title: isEditing ? 'Editar Producto' : 'Crear Producto'),
          const SizedBox(height: 55),
          const _ItemWizardContainer(),
        ],
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

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _WizardStepIndicator(currentStep: itemForm.currentStep),
          const SizedBox(height: 30),
          _WizardContent(currentStep: itemForm.currentStep),
          const SizedBox(height: 30),
          const _WizardNavigationButtons(),
          const SizedBox(height: 50),
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
          label: 'Básica',
        ),
        _StepConnector(isActive: currentStep > 0),
        _StepCircle(
          stepNumber: 2,
          isActive: currentStep >= 1,
          isCompleted: currentStep > 1,
          label: 'Precios',
        ),
        _StepConnector(isActive: currentStep > 1),
        _StepCircle(
          stepNumber: 3,
          isActive: currentStep >= 2,
          isCompleted: currentStep > 2,
          label: 'Códigos',
        ),
        _StepConnector(isActive: currentStep > 2),
        _StepCircle(
          stepNumber: 4,
          isActive: currentStep >= 3,
          isCompleted: currentStep > 3,
          label: 'Impuestos',
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
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
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
                ? const Icon(Icons.check, color: Colors.white, size: 20)
                : Text(
                    '$stepNumber',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.white54,
            fontSize: 10,
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
    return Container(
      width: 30,
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

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botón Anterior
        if (itemForm.currentStep > 0)
          ElevatedButton.icon(
            onPressed:
                itemForm.isLoading ? null : () => itemForm.previousStep(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Anterior'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.grey,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          )
        else
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
            label: const Text('Cancelar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          ),

        // Botón Siguiente/Guardar
        if (itemForm.currentStep < 3)
          ElevatedButton.icon(
            onPressed: itemForm.isLoading
                ? null
                : () {
                    if (itemForm.nextStep()) {
                      // Paso validado y avanzado
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content:
                              Text('Por favor complete los campos requeridos'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Siguiente'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryButton,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            ),
          )
        else
          ElevatedButton.icon(
            onPressed: itemForm.isLoading
                ? null
                : () => _onSaveItem(context, itemForm),
            icon: itemForm.isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.save),
            label: Text(itemForm.isLoading ? 'Guardando...' : 'Guardar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
        const SnackBar(
          content: Text('Por favor complete los campos requeridos'),
          backgroundColor: Colors.red,
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
          const SnackBar(
            content: Text('Producto guardado exitosamente'),
            backgroundColor: Colors.green,
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
            content: Text('Error al guardar: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
