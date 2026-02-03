import 'package:flutter/material.dart';
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
    final itemForm = Provider.of<ItemFormProvider>(context);

    return Form(
      key: itemForm.formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Precios y Stock',
            style: TextStyle(
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
              labelText: 'Precio de venta *',
              hintText: 'Ingrese el precio',
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) {
              itemForm.price = double.tryParse(value) ?? 0.0;
            },
            validator: _validatorPrice,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _costController,
            style: const TextStyle(color: Colors.white),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.money_off, color: Colors.blue),
              labelText: 'Costo *',
              hintText: 'Ingrese el costo',
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) {
              itemForm.cost = double.tryParse(value) ?? 0.0;
            },
            validator: _validatorCost,
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
              labelText: 'Descuento (%)',
              hintText: 'Descuento opcional (0-100)',
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) {
              itemForm.discount = int.tryParse(value) ?? 0;
            },
            validator: _validatorDiscount,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 20),
          if (!itemForm.isService)
            TextFormField(
              controller: _stockController,
              style: const TextStyle(color: Colors.white),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.inventory_2_outlined, color: Colors.blue),
                labelText: 'Stock disponible *',
                hintText: 'Cantidad en inventario',
                floatingLabelStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              ),
              onChanged: (value) {
                itemForm.stock = int.tryParse(value) ?? 0;
              },
              validator: _validatorStock,
              autovalidateMode: AutovalidateMode.onUserInteraction,
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String? _validatorPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'El precio es requerido';
    }
    final price = double.tryParse(value);
    if (price == null || price < 0) {
      return 'Ingrese un precio válido';
    }
    return null;
  }

  String? _validatorCost(String? value) {
    if (value == null || value.isEmpty) {
      return 'El costo es requerido';
    }
    final cost = double.tryParse(value);
    if (cost == null || cost < 0) {
      return 'Ingrese un costo válido';
    }
    return null;
  }

  String? _validatorDiscount(String? value) {
    if (value != null && value.isNotEmpty) {
      final discount = int.tryParse(value);
      if (discount == null || discount < 0 || discount > 100) {
        return 'El descuento debe estar entre 0 y 100';
      }
    }
    return null;
  }

  String? _validatorStock(String? value) {
    if (value == null || value.isEmpty) {
      return 'El stock es requerido';
    }
    final stock = int.tryParse(value);
    if (stock == null || stock < 0) {
      return 'Ingrese un stock válido';
    }
    return null;
  }
}
