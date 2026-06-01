import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';

/// Formulario para actualizar stock y ubicación
class StockForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController stockController;
  final TextEditingController locationController;

  const StockForm({
    Key? key,
    required this.formKey,
    required this.stockController,
    required this.locationController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.labelNewStock,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: AppDimens.spaceS),
          TextFormField(
            controller: stockController,
            style: const TextStyle(color: Colors.white),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            decoration: InputDecoration(
              prefixIcon:
                  const Icon(Icons.inventory_2_outlined, color: Colors.orange),
              labelText: l10n.labelStockField,
              hintText: l10n.hintStockNew,
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.validatorStockRequired;
              }
              final n = int.tryParse(value.trim());
              if (n == null || n < 0) return l10n.validatorValueInvalid;
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          SizedBox(height: AppDimens.paddingM),
          TextFormField(
            controller: locationController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon:
                  const Icon(Icons.location_on_outlined, color: Colors.orange),
              labelText: l10n.labelStockLocation,
              hintText: l10n.hintStockLocation,
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            validator: (value) {
              if (value != null &&
                  value.trim().isNotEmpty &&
                  value.trim().length < 3) {
                return l10n.validatorMinLength(3);
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ],
      ),
    );
  }
}
