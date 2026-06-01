import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';

///Widgets for generate system alert
class AlertScreen extends StatelessWidget {
  const AlertScreen({Key? key}) : super(key: key);

  ///Functions for create ios alert
  void displayDialogIOS(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showCupertinoDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
              title: Text(l10n.alertDemoTitle),
              content: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(l10n.alertDemoContent),
                const SizedBox(height: AppDimens.spaceS),
                const FlutterLogo(size: 100)
              ]),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(AppLocalizations.of(ctx).btnCancel,
                        style:
                            const TextStyle(color: CupertinoColors.systemRed))),
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(AppLocalizations.of(ctx).btnAccept))
              ]);
        });
  }

  ///Functions for create android alert
  void displayDialogAndroid(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return Dialog(
            backgroundColor: AppTheme.dialogBackground,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusL),
              side: const BorderSide(color: AppTheme.dialogBorder, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(AppDimens.paddingL,
                  AppDimens.paddingXL, AppDimens.paddingL, AppDimens.paddingL),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: const EdgeInsets.all(AppDimens.paddingM),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryButton.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.info_outline_rounded,
                      color: AppTheme.primaryButton, size: AppDimens.iconL),
                ),
                const SizedBox(height: AppDimens.spaceL),
                Text(
                  l10n.alertDemoTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: AppDimens.fontBodyLarge,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceM),
                Text(
                  l10n.alertDemoContent,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: AppDimens.fontSmall,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AppDimens.spaceM),
                const FlutterLogo(size: 80),
                const SizedBox(height: AppDimens.spaceXL),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textSecondary,
                          side: const BorderSide(color: AppTheme.dialogBorder),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimens.radiusM)),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppDimens.spaceM),
                        ),
                        child: Text(AppLocalizations.of(ctx).btnCancel),
                      ),
                    ),
                    const SizedBox(width: AppDimens.spaceM),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryButton,
                          foregroundColor: AppTheme.secondary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(AppDimens.radiusM)),
                          padding: const EdgeInsets.symmetric(
                              vertical: AppDimens.spaceM),
                        ),
                        child: Text(AppLocalizations.of(ctx).btnAccept),
                      ),
                    ),
                  ],
                ),
              ]),
            ),
          );
        });
  }

  ///Build alert
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
        body: Center(
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryButton,
                  foregroundColor: AppTheme.secondary,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusM)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: AppDimens.paddingL,
                      vertical: AppDimens.paddingM),
                ),
                child: Text(l10n.alertDemoButton,
                    style: const TextStyle(fontSize: AppDimens.fontBodyLarge)),
                onPressed: () => Platform.isAndroid
                    ? displayDialogAndroid(context)
                    : displayDialogIOS(context))),
        floatingActionButton: FloatingActionButton(
            backgroundColor: AppTheme.primaryButton,
            foregroundColor: AppTheme.secondary,
            child: const Icon(Icons.close_rounded),
            onPressed: () => Navigator.pop(context)));
  }
}
