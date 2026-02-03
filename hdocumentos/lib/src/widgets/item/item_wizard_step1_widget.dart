import 'package:flutter/material.dart';
import 'package:hdocumentos/src/provider/form/item_form_provider.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

///Step 1: Información Básica del Producto
class ItemWizardStep1Widget extends StatefulWidget {
  const ItemWizardStep1Widget({Key? key}) : super(key: key);

  @override
  State<ItemWizardStep1Widget> createState() => _ItemWizardStep1WidgetState();
}

class _ItemWizardStep1WidgetState extends State<ItemWizardStep1Widget> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _searchKeyController;

  @override
  void initState() {
    super.initState();
    final itemForm = Provider.of<ItemFormProvider>(context, listen: false);
    _nameController = TextEditingController(text: itemForm.name);
    _descriptionController = TextEditingController(text: itemForm.description);
    _searchKeyController = TextEditingController(text: itemForm.searchKey);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final itemForm = Provider.of<ItemFormProvider>(context, listen: false);

    // Actualizar controladores solo si el texto ha cambiado
    if (_nameController.text != itemForm.name) {
      _nameController.text = itemForm.name;
    }
    if (_descriptionController.text != itemForm.description) {
      _descriptionController.text = itemForm.description;
    }
    if (_searchKeyController.text != itemForm.searchKey) {
      _searchKeyController.text = itemForm.searchKey;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _searchKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemForm = Provider.of<ItemFormProvider>(context);

    return Form(
      key: itemForm.formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información Básica',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.label_outline, color: Colors.blue),
              labelText: 'Nombre del producto *',
              hintText: 'Ingrese el nombre',
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) => itemForm.name = value,
            validator: _validatorRequired,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _descriptionController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            decoration: InputDecoration(
              prefixIcon:
                  const Icon(Icons.description_outlined, color: Colors.blue),
              labelText: 'Descripción',
              hintText: 'Descripción detallada (opcional)',
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) => itemForm.description = value,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _searchKeyController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.blue),
              labelText: 'Clave de búsqueda',
              hintText: 'Clave única para buscar (opcional)',
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) => itemForm.searchKey = value,
          ),
          const SizedBox(height: 20),
          InputSwitchFieldWidget(
            label: '¿Es un servicio?',
            helperText: 'Marque si es un servicio en lugar de un producto',
            value: itemForm.isService,
            onChanged: (value) {
              itemForm.isService = value;
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String? _validatorRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es requerido';
    }
    if (value.length < 3) {
      return 'Mínimo 3 caracteres';
    }
    return null;
  }
}
