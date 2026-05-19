import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/form/item_form_provider.dart';
import 'package:provider/provider.dart';

///Step 2: Precios y Stock
class ItemWizardStep2Widget extends StatefulWidget {
  const ItemWizardStep2Widget({Key? key}) : super(key: key);

  @override
  State<ItemWizardStep2Widget> createState() => _ItemWizardStep2WidgetState();
}

class _ItemWizardStep2WidgetState extends State<ItemWizardStep2Widget> {
  late TextEditingController _priceController;
  late TextEditingController _costController;
  late TextEditingController _discountController;
  late TextEditingController _stockController;

  @override
  void initState() {
    super.initState();
    final itemForm = Provider.of<ItemFormProvider>(context, listen: false);
    _priceController = TextEditingController(text: itemForm.price.toString());
    _costController = TextEditingController(text: itemForm.cost.toString());
    _discountController =
        TextEditingController(text: itemForm.discount.toString());
    _stockController = TextEditingController(text: itemForm.stock.toString());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final itemForm = Provider.of<ItemFormProvider>(context, listen: false);

    // Actualizar controladores solo si el valor ha cambiado
    if (_priceController.text != itemForm.price.toString()) {
      _priceController.text = itemForm.price.toString();
    }
    if (_costController.text != itemForm.cost.toString()) {
      _costController.text = itemForm.cost.toString();
    }
    if (_discountController.text != itemForm.discount.toString()) {
      _discountController.text = itemForm.discount.toString();
    }
    if (_stockController.text != itemForm.stock.toString()) {
      _stockController.text = itemForm.stock.toString();
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _costController.dispose();
    _discountController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemForm = Provider.of<ItemFormProvider>(context);

    return Form(
      key: itemForm.formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.stepPricesTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _priceController,
            style: const TextStyle(color: Colors.white),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.attach_money, color: Colors.blue),
              labelText: l10n.labelSalePrice,
              hintText: l10n.hintSalePrice,
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) {
              itemForm.price = double.tryParse(value) ?? 0.0;
            },
            validator: (v) => _validatorPrice(context, v),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _costController,
            style: const TextStyle(color: Colors.white),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.money_off, color: Colors.blue),
              labelText: l10n.labelCostRequired,
              hintText: l10n.hintCost,
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) {
              itemForm.cost = double.tryParse(value) ?? 0.0;
            },
            validator: (v) => _validatorCost(context, v),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _discountController,
            style: const TextStyle(color: Colors.white),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            decoration: InputDecoration(
              prefixIcon:
                  const Icon(Icons.discount_outlined, color: Colors.blue),
              labelText: l10n.labelDiscountPct,
              hintText: l10n.hintDiscountPct,
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) {
              itemForm.discount = double.tryParse(value) ?? 0;
            },
            validator: (v) => _validatorDiscount(context, v),
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 20),
          if (!itemForm.isService && !itemForm.isEditing)
            TextFormField(
              controller: _stockController,
              style: const TextStyle(color: Colors.white),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.inventory_2_outlined, color: Colors.blue),
                labelText: l10n.labelAvailableStock,
                hintText: l10n.hintAvailableStock,
                floatingLabelStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              ),
              onChanged: (value) {
                itemForm.stock = int.tryParse(value) ?? 0;
              },
              validator: (v) => _validatorStock(context, v),
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String? _validatorPrice(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n.validatorPriceRequired;
    }
    final price = double.tryParse(value);
    if (price == null || price < 0) {
      return l10n.validatorPriceInvalid;
    }
    return null;
  }

  String? _validatorCost(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n.validatorCostRequired;
    }
    final cost = double.tryParse(value);
    if (cost == null || cost < 0) {
      return l10n.validatorCostInvalid;
    }
    return null;
  }

  String? _validatorDiscount(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context);
    if (value != null && value.isNotEmpty) {
      final discount = double.tryParse(value);
      if (discount == null || discount < 0 || discount > 100) {
        return l10n.validatorDiscountRange;
      }
    }
    return null;
  }

  String? _validatorStock(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context);
    if (value == null || value.isEmpty) {
      return l10n.validatorStockRequired;
    }
    final stock = int.tryParse(value);
    if (stock == null || stock < 0) {
      return l10n.validatorStockInvalid;
    }
    return null;
  }
}
