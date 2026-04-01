import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Paso 4: Configuración de correo electrónico
class CompanyWizardStep4Widget extends StatelessWidget {
  const CompanyWizardStep4Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CompanyFormProvider>(context);
    final company = provider.company;

    return Form(
      key: provider.formKeyStep4,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyWizardSectionHeader(
            icon: Icons.mail_outline,
            title: l10n.step4Title,
            size: size,
          ),
          SizedBox(height: size.height * 0.012),
          // Nota informativa
          Container(
            padding: EdgeInsets.all(size.width * 0.03),
            decoration: BoxDecoration(
              color: AppTheme.primaryButton.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: AppTheme.primaryButton.withOpacity(0.3), width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline,
                    color: AppTheme.primaryButton, size: size.width * 0.045),
                SizedBox(width: size.width * 0.02),
                Expanded(
                  child: Text(
                    l10n.step4InfoNote,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: size.width * 0.03,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.02),
          InputFieldWidget(
            prefixIcon: Icons.dns_outlined,
            labelText: l10n.mailServer,
            hintText: l10n.mailServerHint,
            initialValue: company.mailServer,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) => company.mailServer = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.settings_ethernet,
            labelText: l10n.mailPort,
            hintText: l10n.mailPortHint,
            initialValue: company.mailPort,
            keyboardType: TextInputType.number,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) => company.mailPort = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.alternate_email,
            labelText: l10n.mailAddress,
            hintText: l10n.mailAddressHint,
            initialValue: company.mailAddress,
            keyboardType: TextInputType.emailAddress,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) => company.mailAddress = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.person_outline,
            labelText: l10n.mailUser,
            hintText: l10n.mailUserHint,
            initialValue: company.mailUser,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) => company.mailUser = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.lock_outline,
            labelText: l10n.mailPassword,
            hintText: l10n.mailPasswordHint,
            obscureText: true,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) => company.mailPassword = v,
          ),
          SizedBox(height: size.height * 0.025),
          // Resumen
          CompanyWizardStepSummary(
            items: [
              if (company.mailServer?.isNotEmpty == true)
                CompanyWizardSummaryItem(
                    icon: Icons.dns_outlined, text: company.mailServer!),
              if (company.mailAddress?.isNotEmpty == true)
                CompanyWizardSummaryItem(
                    icon: Icons.alternate_email, text: company.mailAddress!),
              if (company.mailPort?.isNotEmpty == true)
                CompanyWizardSummaryItem(
                    icon: Icons.settings_ethernet,
                    text: l10n.mailPortSummary(company.mailPort!)),
            ],
            size: size,
          ),
        ],
      ),
    );
  }
}
