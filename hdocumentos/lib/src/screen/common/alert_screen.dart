import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

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
                const SizedBox(height: 10),
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
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppTheme.dialogBorder, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryButton.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.info_outline_rounded,
                      color: AppTheme.primaryButton, size: 32),
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.alertDemoTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.alertDemoContent,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13.5,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                const FlutterLogo(size: 80),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppTheme.textSecondary,
                          side: const BorderSide(color: AppTheme.dialogBorder),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
                        ),
                        child: Text(AppLocalizations.of(ctx).btnCancel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryButton,
                          foregroundColor: AppTheme.secondary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 13),
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
                      borderRadius: BorderRadius.circular(10)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                ),
                child: Text(l10n.alertDemoButton,
                    style: const TextStyle(fontSize: 16)),
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
