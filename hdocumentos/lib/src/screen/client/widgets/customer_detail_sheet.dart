import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Bottom sheet con detalles completos del cliente
class CustomerDetailSheet extends StatelessWidget {
  final Map<String, dynamic> customer;

  const CustomerDetailSheet({Key? key, required this.customer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String displayName = customer['businessName'] ??
        '${customer['firstName'] ?? ''} ${customer['lastName'] ?? ''}'.trim();

    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 48,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(AppDimens.borderThin),
              ),
            ),
          ),
          SizedBox(height: AppDimens.spaceL),
          Text(
            displayName,
            style: TextStyle(
              color: Colors.white,
              fontSize: (size.width * 0.052).clamp(16.0, 22.0),
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppDimens.paddingS),
          _DetailRow(
            icon: Icons.badge_rounded,
            label: AppLocalizations.of(context).labelIdentificationType,
            value: customer['type'] ?? 'N/A',
          ),
          _DetailRow(
            icon: Icons.credit_card_rounded,
            label: AppLocalizations.of(context).labelIdentification,
            value: customer['identification'] ?? 'N/A',
          ),
          if (customer['email'] != null &&
              customer['email'].toString().isNotEmpty)
            _DetailRow(
              icon: Icons.email_rounded,
              label: AppLocalizations.of(context).labelEmailAddress,
              value: customer['email'],
            ),
          if (customer['phone'] != null &&
              customer['phone'].toString().isNotEmpty)
            _DetailRow(
              icon: Icons.phone_rounded,
              label: AppLocalizations.of(context).labelPhoneNumber,
              value: customer['phone'],
            ),
          if (customer['address'] != null &&
              customer['address'].toString().isNotEmpty)
            _DetailRow(
              icon: Icons.location_on_rounded,
              label: AppLocalizations.of(context).labelAddress,
              value: customer['address'],
            ),
          SizedBox(height: AppDimens.spaceL),
        ],
      ),
    );
  }
}

/// Fila de detalle con icono, label y valor
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon,
              color: AppTheme.primaryButton,
              size: (size.width * 0.048).clamp(18.0, 24.0)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: (size.width * 0.03).clamp(11.0, 14.0),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: (size.width * 0.038).clamp(13.0, 17.0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
