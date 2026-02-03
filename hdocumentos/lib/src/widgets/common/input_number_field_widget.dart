import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Widget para campos numéricos con formato
class InputNumberFieldWidget extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? prefixIcon;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool allowDecimals;
  final double? initialValue;

  const InputNumberFieldWidget({
    Key? key,
    this.hintText,
    this.labelText,
    this.helperText,
    this.prefixIcon,
    this.validator,
    this.onChanged,
    this.allowDecimals = false,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      initialValue: initialValue?.toString() ?? '',
      keyboardType: TextInputType.numberWithOptions(decimal: allowDecimals),
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: AppTheme.white),
      decoration: InputDecoration(
        filled: false,
        fillColor: AppTheme.whiteGradient,
        floatingLabelStyle: TextStyle(color: AppTheme.white.withOpacity(0.8)),
        hintStyle: TextStyle(color: AppTheme.white.withOpacity(0.3)),
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        prefixIcon: prefixIcon == null
            ? null
            : Icon(prefixIcon, color: AppTheme.primaryButton),
      ),
    );
  }
}
