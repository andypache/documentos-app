import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Diálogo de confirmación para recargar catálogos y datos de la empresa.
///
/// Retorna `true` si el usuario confirma, `false`/`null` si cancela.
///
/// Uso:
/// ```dart
/// final confirmed = await showReloadConfirmDialog(context);
/// if (confirmed == true) { ... }
/// ```
Future<bool?> showReloadConfirmDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (_) => const _ReloadConfirmDialog(),
  );
}

class _ReloadConfirmDialog extends StatelessWidget {
  const _ReloadConfirmDialog();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: AppTheme.dialogBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppTheme.dialogBorder, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ─── Icono ────────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppTheme.primaryButton.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.sync_rounded,
                color: AppTheme.primaryButton,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),

            // ─── Título ───────────────────────────────────────────────────────
            Text(
              l10n.reloadDialogTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 12),

            // ─── Cuerpo ───────────────────────────────────────────────────────
            Text(
              l10n.reloadDialogBody,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 13.5,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            // ─── Botones ──────────────────────────────────────────────────────
            Row(
              children: [
                // Cancelar
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.textSecondary,
                      side: const BorderSide(color: AppTheme.dialogBorder),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                    ),
                    child: Text(
                      l10n.reloadDialogCancel,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Confirmar
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(true),
                    icon: const Icon(Icons.sync_rounded, size: 18),
                    label: Text(
                      l10n.reloadDialogConfirm,
                      style: const TextStyle(fontSize: 14),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryButton,
                      foregroundColor: AppTheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
