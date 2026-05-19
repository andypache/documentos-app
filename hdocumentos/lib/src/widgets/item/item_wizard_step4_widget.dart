import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/config/company_sale_parameter_model.dart';
import 'package:hdocumentos/src/model/common/sale_parameter_model.dart';
import 'package:hdocumentos/src/model/item/item_model.dart';
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
    final l10n = AppLocalizations.of(context);

    return Form(
      key: itemForm.formKeyStep4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.labelTaxes,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // ── Panel de información (primero) ────────────────────────
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: AppTheme.primaryButton.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.primaryButton, width: 1),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppTheme.primaryButton),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.taxInfoNote,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
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
              child: Center(
                child: Text(
                  l10n.noTaxesAdded,
                  style: const TextStyle(
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
                final saleParam = tax.companySaleParameter?.saleParameter;
                final pct = double.tryParse(saleParam?.percentageCode ?? '');
                final percentage = pct != null
                    ? '${pct.toStringAsFixed(pct % 1 == 0 ? 0 : 2)}%'
                    : (saleParam?.percentageCode ?? '');
                final taxName = saleParam?.name ?? 'Impuesto ${index + 1}';
                final taxDescription = saleParam?.description;

                return Card(
                  color: AppTheme.white.withOpacity(0.1),
                  child: ListTile(
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryButton.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          percentage,
                          style: const TextStyle(
                            color: AppTheme.primaryButton,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      taxName,
                      style: const TextStyle(color: Colors.white),
                    ),
                    subtitle: taxDescription != null
                        ? Text(
                            taxDescription,
                            style: const TextStyle(
                                color: Colors.white54, fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        : null,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_rounded,
                          color: AppTheme.actionDelete),
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
              icon: const Icon(Icons.add_rounded),
              label: Text(l10n.btnAddTax),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryButton,
                foregroundColor: AppTheme.secondary,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
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
          // Construir SaleParameterModel con los datos del impuesto seleccionado
          final saleParam = SaleParameterModel(
            id: selectedTax.companySaleParameterId,
            systemParameterId: selectedTax.systemParameterId,
            name: selectedTax.name,
            description: selectedTax.description,
            numberParameter: selectedTax.numberParameter,
            taxCode: selectedTax.taxCode,
            percentageCode: selectedTax.percentageCode,
            systemParameter: selectedTax,
          );

          // Crear CompanySaleParameterModel completo
          final companySaleParam = CompanySaleParameterModel(
            id: selectedTax.companySaleParameterId,
            saleParameterId: selectedTax.systemParameterId,
            saleParameter: saleParam,
          );

          // Crear ItemTaxModel
          final itemTax = ItemTaxModel(
            idCompanySaleParameter: selectedTax.companySaleParameterId,
            companySaleParameter: companySaleParam,
          );

          itemForm.addTax(itemTax);
        },
      ),
    );
  }
}
