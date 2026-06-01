import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';

/// Formulario para actualizar precio y costo
class PriceForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController priceController;
  final TextEditingController costController;

  const PriceForm({
    Key? key,
    required this.formKey,
    required this.priceController,
    required this.costController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.labelNewSalePrice,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: AppDimens.spaceS),
          TextFormField(
            controller: priceController,
            style: const TextStyle(color: Colors.white),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixIcon:
                  const Icon(Icons.attach_money_rounded, color: Colors.green),
              labelText: l10n.labelSalePrice,
              hintText: l10n.hintPriceExample,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.validatorPriceRequired;
              }
              final n = double.tryParse(value.trim());
              if (n == null || n < 0) return l10n.validatorValueInvalid;
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          SizedBox(height: AppDimens.paddingM),
          Text(l10n.labelNewCost,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: AppDimens.spaceS),
          TextFormField(
            controller: costController,
            style: const TextStyle(color: Colors.white),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              prefixIcon:
                  const Icon(Icons.money_off_rounded, color: Colors.amber),
              labelText: l10n.labelCost,
              hintText: l10n.hintCostExample,
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return null;
              final n = double.tryParse(value.trim());
              if (n == null || n < 0) return l10n.validatorValueInvalid;
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ],
      ),
    );
  }
}
