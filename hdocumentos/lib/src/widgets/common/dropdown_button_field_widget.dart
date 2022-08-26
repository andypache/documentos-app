import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Create general widget for dropdown button all application
class DropdownButtonFieldWidget extends StatelessWidget {
  final List<KeyValueModel> items;
  final void Function(dynamic)? onChanged;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? icon;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool? filled;
  final Color? fillColor;

  //Constructor class
  const DropdownButtonFieldWidget(
      {Key? key,
      required this.items,
      this.onChanged,
      this.hintText,
      this.labelText,
      this.helperText,
      this.icon,
      this.prefixIcon,
      this.suffixIcon,
      this.filled,
      this.fillColor})
      : super(key: key);

  //Build
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<dynamic>(
        value: null,
        items: items
            .map((item) => DropdownMenuItem<dynamic>(
                value: item.key, child: Text(item.value)))
            .toList(),
        onChanged: onChanged,
        decoration: _inputDecoration());
  }

  //Create widget decoration for dropdown
  InputDecoration _inputDecoration() {
    return InputDecoration(
        filled: filled ?? false,
        fillColor: fillColor ?? AppTheme.whiteGradient,
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
