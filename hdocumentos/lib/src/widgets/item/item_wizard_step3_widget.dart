import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/form/item_form_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/common/image_picker_field_widget.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

///Step 3: Códigos e Imagen
class ItemWizardStep3Widget extends StatefulWidget {
  const ItemWizardStep3Widget({Key? key}) : super(key: key);

  @override
  State<ItemWizardStep3Widget> createState() => _ItemWizardStep3WidgetState();
}

class _ItemWizardStep3WidgetState extends State<ItemWizardStep3Widget> {
  late TextEditingController _barCodeController;

  @override
  void initState() {
    super.initState();
    final itemForm = Provider.of<ItemFormProvider>(context, listen: false);
    _barCodeController = TextEditingController(text: itemForm.barCode);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final itemForm = Provider.of<ItemFormProvider>(context, listen: false);

    if (_barCodeController.text != itemForm.barCode) {
      _barCodeController.text = itemForm.barCode;
    }
  }

  @override
  void dispose() {
    _barCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final itemForm = Provider.of<ItemFormProvider>(context);

    return Form(
      key: itemForm.formKeyStep3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.stepCodesTitle,
            style: const TextStyle(
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
              labelText: l10n.labelBarCode,
              hintText: l10n.hintBarCode,
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) => itemForm.barCode = value,
          ),
          const SizedBox(height: 20),

          // En edición: mostrar QR generado desde el dato del backend
          if (itemForm.isEditing && itemForm.qrCode.isNotEmpty) ...[
            _QrDisplayWidget(data: itemForm.qrCode),
            const SizedBox(height: 20),
          ],

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

/// Widget que muestra el QR generado a partir del dato enviado por el backend.
class _QrDisplayWidget extends StatelessWidget {
  final String data;

  const _QrDisplayWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryButton.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.qr_code_2,
                  color: AppTheme.primaryButton, size: 18),
              const SizedBox(width: 8),
              Text(
                l10n.labelQrCode,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(8),
              child: QrImageView(
                data: data,
                version: QrVersions.auto,
                size: 160,
                backgroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              data,
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
