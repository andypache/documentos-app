import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';

/// Header del wizard con título y botón cerrar
class CustomerWizardHeader extends StatelessWidget {
  final bool isEditing;

  const CustomerWizardHeader({Key? key, required this.isEditing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: isLandscape ? 4 : 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? l10n.customerEditTitle : l10n.customerCreateTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isLandscape ? 16 : size.width * 0.052,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(
              Icons.close_rounded,
              color: Colors.white.withOpacity(0.8),
              size: isLandscape ? 22 : size.width * 0.07,
            ),
          ),
        ],
      ),
    );
  }
}
