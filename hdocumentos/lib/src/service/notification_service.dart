import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Create notification service for application
class NotificationService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  /// Obtiene [AppLocalizations] usando el context del messengerKey global.
  /// Retorna null si el messenger aún no está montado.
  static AppLocalizations? get l10n {
    final context = messengerKey.currentContext;
    if (context == null) return null;
    return AppLocalizations.of(context);
  }

  //Show dialog error notify
  static showSnackbarError(String message) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.transparent,
        elevation: 0,
        content: Container(
            padding: const EdgeInsets.all(16),
            height: 90,
            decoration: const BoxDecoration(
                color: AppTheme.red,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text(message,
                style: const TextStyle(color: AppTheme.white, fontSize: 20))));

    messengerKey.currentState!.showSnackBar(snackBar);
  }

  //Show dialog succces notify
  static showSnackbarSuccess(String message) {
    final snackBar = SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppTheme.transparent,
        elevation: 0,
        content: Container(
            padding: const EdgeInsets.all(16),
            height: 90,
            decoration: const BoxDecoration(
                color: AppTheme.primary,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Text(message,
                style: const TextStyle(color: AppTheme.white, fontSize: 20))));

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
