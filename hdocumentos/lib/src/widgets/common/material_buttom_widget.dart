import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
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
    final String buttonText =
        textButton ?? AppLocalizations.of(context).btnSubmit;

    final Widget label = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24.0, color: AppTheme.white),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  buttonText,
                  style: const TextStyle(color: AppTheme.white),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        : Text(buttonText,
            style: const TextStyle(color: AppTheme.white),
            overflow: TextOverflow.ellipsis);

    return MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM)),
        minWidth: minWidth ?? 80,
        disabledColor: AppTheme.grey,
        elevation: 0,
        color: type ?? AppTheme.primaryButton,
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: label,
        ));
  }
}
