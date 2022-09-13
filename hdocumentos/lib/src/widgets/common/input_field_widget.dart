import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Create general widget for text input all application
class InputFieldWidget extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? icon;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool? filled;
  final Color? fillColor;
  final Color? textStyleColor;
  final Color? floatingLabelStyleColor;
  final Color? hintStyleColor;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  //Constructor class
  const InputFieldWidget(
      {Key? key,
      this.hintText,
      this.labelText,
      this.helperText,
      this.icon,
      this.prefixIcon,
      this.suffixIcon,
      this.keyboardType,
      this.obscureText = false,
      this.validator,
      this.onChanged,
      this.filled,
      this.fillColor,
      this.textStyleColor,
      this.floatingLabelStyleColor,
      this.hintStyleColor})
      : super(key: key);

  //Create widget
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        autofocus: false,
        initialValue: '',
        textCapitalization: TextCapitalization.words,
        keyboardType: keyboardType,
        obscureText: obscureText,
        onChanged: onChanged,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        style: TextStyle(color: textStyleColor ?? AppTheme.white),
        decoration: _inputDecoration());
  }

  //Create widget decoration
  InputDecoration _inputDecoration() {
    return InputDecoration(
        filled: filled ?? false,
        fillColor: fillColor ?? AppTheme.whiteGradient,
        floatingLabelStyle: TextStyle(
            color: floatingLabelStyleColor ?? AppTheme.white.withOpacity(0.8)),
        hintStyle:
            TextStyle(color: hintStyleColor ?? AppTheme.white.withOpacity(0.3)),
        hintText: hintText,
        labelText: labelText,
        helperText: helperText,
        prefixIcon: prefixIcon == null
            ? null
            : Icon(
                prefixIcon,
                color: AppTheme.primaryButton,
              ),
        suffixIcon: suffixIcon == null
            ? null
            : Icon(suffixIcon, color: AppTheme.primaryButton),
        icon: icon == null ? null : Icon(icon, color: AppTheme.primaryButton),
        //enabledBorder: const UnderlineInputBorder(
        //    borderSide: BorderSide(color: AppTheme.secondary)),
        //focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.secondary)),
        labelStyle: const TextStyle(color: AppTheme.grey));
  }
}
