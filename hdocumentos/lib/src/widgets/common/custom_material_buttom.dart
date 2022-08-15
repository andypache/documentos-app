import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Create general widget for button all application
class CustomMaterialButton extends StatelessWidget {
  final void Function()? onPressed;
  final String? textButton;

  //Constructor class
  const CustomMaterialButton({Key? key, this.onPressed, this.textButton})
      : super(key: key);

  //Create material button widget
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        disabledColor: AppTheme.grey,
        elevation: 0,
        color: AppTheme.primaryButton,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
          child: Text(
            textButton ?? 'Submit',
            style: const TextStyle(color: AppTheme.white),
          ),
        ),
        onPressed: onPressed);
  }
}
