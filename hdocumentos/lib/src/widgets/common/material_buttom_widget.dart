import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Create general widget for button all application
class MaterialButtonWidget extends StatelessWidget {
  final void Function()? onPressed;
  final String? textButton;
  final double? minWidth;
  final IconData? icon;
  final Color? type;

  //Constructor class
  const MaterialButtonWidget(
      {Key? key,
      this.onPressed,
      this.textButton,
      this.minWidth,
      this.icon,
      this.type})
      : super(key: key);

  //Create material button widget
  @override
  Widget build(BuildContext context) {
    Row _rowIcon;
    if (icon != null) {
      _rowIcon = Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 24.0, color: AppTheme.white),
        const SizedBox(width: 10),
        Text(textButton ?? 'Submit',
            style: const TextStyle(color: AppTheme.white))
      ]);
    } else {
      _rowIcon = Row(mainAxisSize: MainAxisSize.min, children: [
        Text(textButton ?? 'Submit',
            style: const TextStyle(color: AppTheme.white))
      ]);
    }

    return MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        minWidth: minWidth ?? 80,
        disabledColor: AppTheme.grey,
        elevation: 0,
        color: type ?? AppTheme.primaryButton,
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            child: _rowIcon),
        onPressed: onPressed);
  }
}
