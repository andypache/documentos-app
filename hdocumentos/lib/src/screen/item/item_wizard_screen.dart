import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/form/item_form_provider.dart';
import 'package:hdocumentos/src/screen/item/widgets/widgets.dart';
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
    final itemForm = Provider.of<ItemFormProvider>(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Column(
          children: [
            if (!isLandscape) const UserSessionTitle(),
            ItemWizardHeader(
              isEditing: isEditing,
              onClose: () => Navigator.pop(context),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    ItemStepperIndicator(
                      currentStep: itemForm.currentStep,
                      isEditing: itemForm.isEditing,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: size.width * 0.05,
                        vertical: isLandscape ? 8 : 12,
                      ),
                      child:
                          ItemWizardContent(currentStep: itemForm.currentStep),
                    ),
                  ],
                ),
              ),
            ),
            const ItemWizardNavigation(),
          ],
        ),
      ),
    );
  }
}

///Indicador de pasos estilo íconos (igual al de compañía)
