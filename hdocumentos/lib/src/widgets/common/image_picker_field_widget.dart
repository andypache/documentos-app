import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:image_picker/image_picker.dart';

///Widget para seleccionar imagen
class ImagePickerFieldWidget extends StatelessWidget {
  final Uint8List? currentImage;
  final String? imageName;
  final void Function(Uint8List?, String?) onImagePicked;
  final String label;

  const ImagePickerFieldWidget({
    Key? key,
    required this.currentImage,
    required this.imageName,
    required this.onImagePicked,
    this.label = 'Imagen del producto',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          if (currentImage != null)
            Stack(
              children: [
                Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppTheme.primaryButton, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      currentImage!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onImagePicked(null, null),
                  ),
                ),
              ],
            )
          else
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppTheme.primaryButton, width: 2),
              ),
              child: const Center(
                child: Icon(
                  Icons.image_outlined,
                  size: 60,
                  color: AppTheme.primaryButton,
                ),
              ),
            ),
          const SizedBox(height: 10),
          if (imageName != null)
            Text(
              imageName!,
              style: TextStyle(
                color: AppTheme.white.withOpacity(0.7),
                fontSize: 12,
              ),
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Cámara'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryButton,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Galería'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryButton,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        final Uint8List imageData = await image.readAsBytes();
        onImagePicked(imageData, image.name);
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }
}
