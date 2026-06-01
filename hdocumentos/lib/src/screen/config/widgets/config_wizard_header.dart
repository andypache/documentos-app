import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';

/// Header del wizard de configuración con título dinámico
class ConfigWizardHeader extends StatelessWidget {
  final bool isEditing;
  final VoidCallback onClose;

  const ConfigWizardHeader({
    Key? key,
    required this.isEditing,
    required this.onClose,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: 8,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isEditing ? l10n.configEditTitle : l10n.configNewTitle,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.052,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  isEditing ? l10n.configEditSubtitle : l10n.configNewSubtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: size.width * 0.032,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(
              Icons.close_rounded,
              color: Colors.white.withOpacity(0.8),
              size: size.width * 0.07,
            ),
          ),
        ],
      ),
    );
  }
}
