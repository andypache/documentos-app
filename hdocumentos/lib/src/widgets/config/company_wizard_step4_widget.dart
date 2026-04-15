import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/config/company_model.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Paso 4: Configuración de correo electrónico
class CompanyWizardStep4Widget extends StatefulWidget {
  const CompanyWizardStep4Widget({Key? key}) : super(key: key);

  @override
  State<CompanyWizardStep4Widget> createState() =>
      _CompanyWizardStep4WidgetState();
}

class _CompanyWizardStep4WidgetState extends State<CompanyWizardStep4Widget> {
  /// En modo edición con correo ya configurado, el campo de contraseña
  /// se oculta por defecto. El backend no devuelve la contraseña SMTP.
  bool _changePassword = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CompanyFormProvider>(context, listen: false);
    // En edición con configuración de correo existente, ocultar contraseña
    final hasExistingMail =
        provider.isEditing && provider.company.emailConfiguration != null;
    _changePassword = !hasExistingMail;
  }

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
            initialValue: company.emailConfiguration?.mailServer,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) {
              company.emailConfiguration ??= CompanyEmailConfigurationModel();
              company.emailConfiguration!.mailServer = v;
            },
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.settings_ethernet,
            labelText: l10n.mailPort,
            hintText: l10n.mailPortHint,
            initialValue: company.emailConfiguration?.mailPort,
            keyboardType: TextInputType.number,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) {
              company.emailConfiguration ??= CompanyEmailConfigurationModel();
              company.emailConfiguration!.mailPort = v;
            },
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.alternate_email,
            labelText: l10n.mailAddress,
            hintText: l10n.mailAddressHint,
            initialValue: company.emailConfiguration?.mailAddress,
            keyboardType: TextInputType.emailAddress,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) {
              company.emailConfiguration ??= CompanyEmailConfigurationModel();
              company.emailConfiguration!.mailAddress = v;
            },
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.person_outline,
            labelText: l10n.mailUser,
            hintText: l10n.mailUserHint,
            initialValue: company.emailConfiguration?.mailUser,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) {
              company.emailConfiguration ??= CompanyEmailConfigurationModel();
              company.emailConfiguration!.mailUser = v;
            },
          ),
          SizedBox(height: size.height * 0.018),

          // ── Contraseña SMTP ──────────────────────────────────────────────
          // En edición con correo ya configurado se muestra un toggle.
          // El backend nunca devuelve la contraseña SMTP por seguridad.
          if (provider.isEditing && company.emailConfiguration != null)
            SwitchListTile(
              value: _changePassword,
              contentPadding: EdgeInsets.zero,
              activeColor: AppTheme.primaryButton,
              title: Text(
                l10n.mailChangePassword,
                style: const TextStyle(color: AppTheme.white, fontSize: 14),
              ),
              onChanged: (v) {
                setState(() => _changePassword = v);
                provider.requireMailPassword = v;
              },
            ),
          if (_changePassword)
            InputFieldWidget(
              prefixIcon: Icons.lock_outline,
              labelText: l10n.mailPassword,
              hintText: l10n.mailPasswordHint,
              initialValue: null,
              obscureText: true,
              filled: true,
              fillColor: AppTheme.whiteGradient,
              onChanged: (v) {
                company.emailConfiguration ??= CompanyEmailConfigurationModel();
                company.emailConfiguration!.mailPassword = v;
              },
            ),
          SizedBox(height: size.height * 0.025),
          // Resumen
          CompanyWizardStepSummary(
            items: [
              if (company.emailConfiguration?.mailServer?.isNotEmpty == true)
                CompanyWizardSummaryItem(
                    icon: Icons.dns_outlined,
                    text: company.emailConfiguration!.mailServer!),
              if (company.emailConfiguration?.mailAddress?.isNotEmpty == true)
                CompanyWizardSummaryItem(
                    icon: Icons.alternate_email,
                    text: company.emailConfiguration!.mailAddress!),
              if (company.emailConfiguration?.mailPort?.isNotEmpty == true)
                CompanyWizardSummaryItem(
                    icon: Icons.settings_ethernet,
                    text: l10n.mailPortSummary(
                        company.emailConfiguration!.mailPort!)),
            ],
            size: size,
          ),
        ],
      ),
    );
  }
}
