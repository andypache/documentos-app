import 'package:flutter/material.dart';
import 'package:hdocumentos/src/provider/form/item_form_provider.dart';
import 'package:hdocumentos/src/widgets/common/image_picker_field_widget.dart';
import 'package:provider/provider.dart';

///Step 3: Códigos e Imagen
class ItemWizardStep3Widget extends StatefulWidget {
  const ItemWizardStep3Widget({Key? key}) : super(key: key);

  @override
  State<ItemWizardStep3Widget> createState() => _ItemWizardStep3WidgetState();
}

class _ItemWizardStep3WidgetState extends State<ItemWizardStep3Widget> {
  late TextEditingController _barCodeController;
  late TextEditingController _qrCodeController;

  @override
  void initState() {
    super.initState();
    final itemForm = Provider.of<ItemFormProvider>(context, listen: false);
    _barCodeController = TextEditingController(text: itemForm.barCode);
    _qrCodeController = TextEditingController(text: itemForm.qrCode);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final itemForm = Provider.of<ItemFormProvider>(context, listen: false);

    // Actualizar controladores solo si el texto ha cambiado
    if (_barCodeController.text != itemForm.barCode) {
      _barCodeController.text = itemForm.barCode;
    }
    if (_qrCodeController.text != itemForm.qrCode) {
      _qrCodeController.text = itemForm.qrCode;
    }
  }

  @override
  void dispose() {
    _barCodeController.dispose();
    _qrCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemForm = Provider.of<ItemFormProvider>(context);

    return Form(
      key: itemForm.formKeyStep3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Códigos e Imagen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _barCodeController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.qr_code, color: Colors.blue),
              labelText: 'Código de barras',
              hintText: 'Ingrese código de barras (opcional)',
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) => itemForm.barCode = value,
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: _qrCodeController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.qr_code_2, color: Colors.blue),
              labelText: 'Código QR',
              hintText: 'Ingrese código QR (opcional)',
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) => itemForm.qrCode = value,
          ),
          const SizedBox(height: 20),
          ImagePickerFieldWidget(
            currentImage: itemForm.image,
            imageName: itemForm.imageName,
            onImagePicked: (imageData, fileName) {
              itemForm.updateImage(imageData, fileName);
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
