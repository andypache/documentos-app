import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Barra inferior con botones Cancelar y Nuevo Cliente
class ClientBottomActionBar extends StatelessWidget {
  final VoidCallback onNewCustomer;
  final VoidCallback onCancel;

  const ClientBottomActionBar({
    Key? key,
    required this.onNewCustomer,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final hPad = isLandscape ? 16.0 : MediaQuery.of(context).size.width * 0.05;
    final vPad = isLandscape ? 6.0 : 12.0;
    final iconSize = isLandscape ? 18.0 : 22.0;
    final fontSize = isLandscape ? 13.0 : 14.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: onCancel,
            icon: Icon(Icons.close_rounded, size: iconSize),
            label: Text(l10n.btnCancel, style: TextStyle(fontSize: fontSize)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.actionDanger,
              foregroundColor: Colors.white,
              elevation: 0,
              padding:
                  EdgeInsets.symmetric(horizontal: hPad, vertical: vPad + 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: onNewCustomer,
            icon: Icon(Icons.person_add_rounded, size: iconSize),
            label: Text(
              l10n.customerCreateTitle,
              style: TextStyle(fontSize: fontSize),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryButton,
              foregroundColor: AppTheme.secondary,
              elevation: 0,
              padding:
                  EdgeInsets.symmetric(horizontal: hPad, vertical: vPad + 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimens.radiusM),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
