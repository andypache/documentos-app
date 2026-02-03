import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/item/company_system_parameter_model.dart';
import 'package:hdocumentos/src/model/item/item_tax_model.dart';
import 'package:hdocumentos/src/provider/form/item_form_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/item/tax_selection_dialog_widget.dart';
import 'package:provider/provider.dart';

///Step 4: Impuestos
class ItemWizardStep4Widget extends StatelessWidget {
  const ItemWizardStep4Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final itemForm = Provider.of<ItemFormProvider>(context);

    return Form(
      key: itemForm.formKeyStep4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Impuestos',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          if (itemForm.itemTaxList.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'No hay impuestos agregados',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemForm.itemTaxList.length,
              itemBuilder: (context, index) {
                final tax = itemForm.itemTaxList[index];
                final numberParam = tax.companySystemParameter?.systemParameter
                        ?.numberParameter ??
                    0;
                final percentage = numberParam % 1 == 0
                    ? numberParam.toStringAsFixed(0)
                    : numberParam.toStringAsFixed(2);

                return Card(
                  color: AppTheme.white.withOpacity(0.1),
                  child: ListTile(
                    leading: const Icon(
                      Icons.percent,
                      color: AppTheme.primaryButton,
                    ),
                    title: Text(
                      tax.companySystemParameter?.systemParameter?.name ??
                          'Impuesto ${index + 1}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      '$percentage%',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => itemForm.removeTax(index),
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _showAddTaxDialog(context, itemForm),
              icon: const Icon(Icons.add),
              label: const Text('Agregar Impuesto'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryButton,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppTheme.primaryButton.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.primaryButton, width: 1),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: AppTheme.primaryButton),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Los impuestos son opcionales. Puede agregarlos ahora o más tarde.',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTaxDialog(BuildContext context, ItemFormProvider itemForm) {
    showDialog(
      context: context,
      builder: (context) => TaxSelectionDialogWidget(
        currentTaxes: itemForm.itemTaxList,
        onTaxSelected: (selectedTax) {
          // Crear CompanySystemParameterModel con el SystemParameterModel seleccionado
          final companySystemParam = CompanySystemParameterModel(
            companySystemParameterId: selectedTax.companySystemParameter,
            systemParameterId: selectedTax.systemParameterId,
            systemParameter: selectedTax,
            numberParameter: selectedTax.numberParameter,
            isTaxSale: selectedTax.isTaxSale,
            taxCode: selectedTax.taxCode,
            percentageCode: selectedTax.percentageCode,
          );

          // Crear ItemTaxModel
          final itemTax = ItemTaxModel(
            idCompanySystemParameter: selectedTax.companySystemParameter,
            companySystemParameter: companySystemParam,
          );

          // Agregar al provider
          itemForm.addTax(itemTax);
        },
      ),
    );
  }
}
