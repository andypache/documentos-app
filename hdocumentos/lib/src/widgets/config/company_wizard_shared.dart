import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Header de sección usado en cada paso del wizard
class CompanyWizardSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Size size;
  const CompanyWizardSectionHeader(
      {Key? key, required this.icon, required this.title, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(size.width * 0.022),
          decoration: BoxDecoration(
            color: AppTheme.primaryButton.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon,
              color: AppTheme.primaryButton, size: size.width * 0.052),
        ),
        SizedBox(width: size.width * 0.03),
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: size.width * 0.044,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }
}

/// Caja de resumen parcial en cada paso
class CompanyWizardStepSummary extends StatelessWidget {
  final List<CompanyWizardSummaryItem> items;
  final Size size;
  const CompanyWizardStepSummary(
      {Key? key, required this.items, required this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (items.isEmpty) return const SizedBox.shrink();
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.035),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.enteredSoFar,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: size.width * 0.028,
              fontStyle: FontStyle.italic,
            ),
          ),
          SizedBox(height: size.height * 0.008),
          ...items,
        ],
      ),
    );
  }
}

/// Item de resumen con icono y texto
class CompanyWizardSummaryItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const CompanyWizardSummaryItem(
      {Key? key, required this.icon, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.006),
      child: Row(
        children: [
          Icon(icon,
              size: size.width * 0.038,
              color: AppTheme.primaryButton.withOpacity(0.8)),
          SizedBox(width: size.width * 0.02),
          Flexible(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white.withOpacity(0.85),
                fontSize: size.width * 0.032,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
