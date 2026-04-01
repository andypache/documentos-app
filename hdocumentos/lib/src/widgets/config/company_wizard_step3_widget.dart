import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Paso 3: Certificado electrónico
class CompanyWizardStep3Widget extends StatelessWidget {
  const CompanyWizardStep3Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CompanyFormProvider>(context);
    final company = provider.company;

    return Form(
      key: provider.formKeyStep3,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyWizardSectionHeader(
            icon: Icons.security_outlined,
            title: l10n.step3Title,
            size: size,
          ),
          SizedBox(height: size.height * 0.02),
          // Botón cargar certificado
          MaterialButtonWidget(
            type: AppTheme.secondaryButton,
            icon: Icons.upload_file,
            textButton: company.certificatePath != null
                ? l10n.step3CertLoaded
                : l10n.step3CertButton,
            minWidth: double.infinity,
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['cert', 'p12'],
              );
              if (result == null) return;
              provider.updateCertificate(result.files.single.path!);
            },
          ),
          if (company.certificatePath == null)
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.008),
              child: Text(
                l10n.step3CertRequired,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: size.width * 0.03,
                ),
              ),
            ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.person_outline,
            labelText: l10n.certificateUser,
            hintText: l10n.certificateUserHint,
            initialValue: company.certificateUser,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: FieldValidators.compose([
              FieldValidators.required(l10n),
            ]),
            onChanged: (v) => company.certificateUser = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.lock_outline,
            labelText: l10n.certificatePassword,
            hintText: l10n.certificatePasswordHint,
            obscureText: true,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: FieldValidators.compose([
              FieldValidators.required(l10n),
            ]),
            onChanged: (v) => company.certificatePassword = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputDateFieldWidget(
            labelText: l10n.certificateExpiration,
            hintText: l10n.certificateExpirationHint,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) =>
                company.certificateExpirationDate = v as DateTime?,
          ),
          SizedBox(height: size.height * 0.025),
          // Resumen
          CompanyWizardStepSummary(
            items: [
              if (company.certificatePath != null)
                CompanyWizardSummaryItem(
                    icon: Icons.check_circle_outline,
                    text: l10n.step3CertSummary),
              if (company.certificateUser?.isNotEmpty == true)
                CompanyWizardSummaryItem(
                    icon: Icons.person_outline, text: company.certificateUser!),
              if (company.certificateExpirationDate != null)
                CompanyWizardSummaryItem(
                    icon: Icons.calendar_today_outlined,
                    text: l10n.certificateExpiresSummary(
                      '${company.certificateExpirationDate!.day}/${company.certificateExpirationDate!.month}/${company.certificateExpirationDate!.year}',
                    )),
            ],
            size: size,
          ),
        ],
      ),
    );
  }
}
