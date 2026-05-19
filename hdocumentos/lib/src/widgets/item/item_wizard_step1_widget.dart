import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context);
    final itemForm = Provider.of<ItemFormProvider>(context);

    return Form(
      key: itemForm.formKeyStep1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.stepBasicTitle,
            style: const TextStyle(
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
              labelText: l10n.labelProductName,
              hintText: l10n.hintProductName,
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) => itemForm.name = value,
            validator: FieldValidators.compose([
              FieldValidators.minLength(l10n, 3),
              FieldValidators.maxLength(l10n, 200),
              FieldValidators.alphanumericBasic(l10n),
              FieldValidators.required(l10n)
            ]),
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
              labelText: l10n.labelDescription,
              hintText: l10n.hintDescriptionOptional,
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            validator: FieldValidators.compose([
              FieldValidators.minLength(l10n, 3),
              FieldValidators.maxLength(l10n, 500),
              FieldValidators.alphanumericBasic(l10n),
              FieldValidators.required(l10n)
            ]),
            onChanged: (value) => itemForm.description = value,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _searchKeyController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, color: Colors.blue),
              labelText: l10n.labelSearchKey,
              hintText: l10n.hintSearchKeyOptional,
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            validator: FieldValidators.compose([
              FieldValidators.minLength(l10n, 2),
              FieldValidators.maxLength(l10n, 100),
              FieldValidators.alphanumericBasic(l10n),
              FieldValidators.required(l10n)
            ]),
            onChanged: (value) => itemForm.searchKey = value,
          ),
          const SizedBox(height: 20),
          InputSwitchFieldWidget(
            label: l10n.labelIsService,
            helperText: l10n.hintIsService,
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
}
