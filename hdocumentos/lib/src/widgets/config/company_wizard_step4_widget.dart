import 'package:flutter/material.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/config/company_wizard_shared.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Paso 4: Configuración de correo electrónico
class CompanyWizardStep4Widget extends StatelessWidget {
  const CompanyWizardStep4Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            title: 'Configuración de Correo',
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
                    'Campos opcionales. Se usan para el envío de facturas por correo.',
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
            labelText: 'Servidor de correo',
            hintText: 'smtp.gmail.com (opcional)',
            initialValue: company.mailServer,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) => company.mailServer = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.settings_ethernet,
            labelText: 'Puerto',
            hintText: '587 / 465 (opcional)',
            initialValue: company.mailPort,
            keyboardType: TextInputType.number,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) => company.mailPort = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.alternate_email,
            labelText: 'Dirección de correo remitente',
            hintText: 'correo@empresa.com (opcional)',
            initialValue: company.mailAddress,
            keyboardType: TextInputType.emailAddress,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) => company.mailAddress = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.person_outline,
            labelText: 'Usuario de correo',
            hintText: 'Usuario SMTP (opcional)',
            initialValue: company.mailUser,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) => company.mailUser = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.lock_outline,
            labelText: 'Contraseña de correo',
            hintText: 'Contraseña SMTP (opcional)',
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
                    text: 'Puerto: ${company.mailPort}'),
            ],
            size: size,
          ),
        ],
      ),
    );
  }
}
