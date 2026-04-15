import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/config/company_model.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

/// Paso 3: Certificado electrónico
class CompanyWizardStep3Widget extends StatefulWidget {
  const CompanyWizardStep3Widget({Key? key}) : super(key: key);

  @override
  State<CompanyWizardStep3Widget> createState() =>
      _CompanyWizardStep3WidgetState();
}

class _CompanyWizardStep3WidgetState extends State<CompanyWizardStep3Widget> {
  /// En modo edición con contraseña existente, el campo se oculta por defecto.
  /// El usuario activa este flag para ingresar una nueva contraseña.
  bool _changePassword = false;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CompanyFormProvider>(context, listen: false);
    // En edición con certificado ya configurado, ocultar el campo de contraseña
    // por defecto. El backend no devuelve la contraseña por seguridad.
    final hasExistingCert =
        provider.isEditing && provider.company.hasCertificate;
    _changePassword = !hasExistingCert;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CompanyFormProvider>(context);
    final company = provider.company;
    final submitted = provider.step3Submitted;

    /// En edición con contraseña guardada y sin cambio activo, la contraseña
    /// ya está en el modelo: se considera válida sin requerir el campo.
    final bool passwordFieldRequired = _changePassword;

    final certMissing =
        submitted && company.certificateData?.certificatePath == null;
    final dateMissing =
        submitted && company.certificateData?.certificateExpirationDate == null;

    return Form(
      key: provider.formKeyStep3,
      autovalidateMode: submitted
          ? AutovalidateMode.always
          : AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyWizardSectionHeader(
            icon: Icons.security_outlined,
            title: l10n.step3Title,
            size: size,
          ),
          SizedBox(height: size.height * 0.02),

          // ── Certificado ──────────────────────────────────────────────────
          MaterialButtonWidget(
            type: AppTheme.secondaryButton,
            icon: Icons.upload_file,
            textButton: company.certificateData?.certificatePath != null
                ? l10n.step3CertLoaded
                : l10n.step3CertButton,
            minWidth: double.infinity,
            onPressed: () async {
              final result = await FilePicker.platform.pickFiles(
                type: FileType.custom,
                allowedExtensions: ['cert', 'p12'],
              );
              if (result == null) return;
              if (!mounted) return;
              await provider.updateCertificate(result.files.single.path!);
            },
          ),
          if (certMissing)
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.006, left: size.width * 0.03),
              child: Text(
                l10n.step3CertRequired,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: size.width * 0.03,
                ),
              ),
            ),
          SizedBox(height: size.height * 0.018),

          // ── Usuario ──────────────────────────────────────────────────────
          InputFieldWidget(
            prefixIcon: Icons.person_outline,
            labelText: l10n.certificateUser,
            hintText: l10n.certificateUserHint,
            initialValue: company.certificateData?.certificateUser,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: FieldValidators.compose([
              FieldValidators.required(l10n),
            ]),
            onChanged: (v) {
              company.certificateData ??= CompanyCertificateModel();
              company.certificateData!.certificateUser = v;
            },
          ),
          SizedBox(height: size.height * 0.018),

          // ── Contraseña ───────────────────────────────────────────────────
          // En edición con certificado existente se muestra un toggle.
          // El campo de texto solo aparece cuando el usuario quiere cambiar la contraseña.
          // Nota: el backend nunca devuelve la contraseña por seguridad.
          if (provider.isEditing && company.hasCertificate)
            SwitchListTile(
              value: _changePassword,
              contentPadding: EdgeInsets.zero,
              activeColor: AppTheme.primaryButton,
              title: Text(
                l10n.certChangePassword,
                style: const TextStyle(color: AppTheme.white, fontSize: 14),
              ),
              onChanged: (v) {
                setState(() => _changePassword = v);
                provider.requireCertPassword = v;
              },
            ),
          if (passwordFieldRequired)
            InputFieldWidget(
              prefixIcon: Icons.lock_outline,
              labelText: l10n.certificatePassword,
              hintText: l10n.certificatePasswordHint,
              initialValue: null,
              obscureText: true,
              filled: true,
              fillColor: AppTheme.whiteGradient,
              validator: FieldValidators.compose([
                FieldValidators.required(l10n),
              ]),
              onChanged: (v) {
                company.certificateData ??= CompanyCertificateModel();
                company.certificateData!.certificatePassword = v;
              },
            ),
          SizedBox(height: size.height * 0.018),

          // ── Fecha de expiración ──────────────────────────────────────────
          InputDateFieldWidget(
            labelText: l10n.certificateExpiration,
            hintText: l10n.certificateExpirationHint,
            initialDate: company.certificateData?.certificateExpirationDate,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: FieldValidators.compose([
              FieldValidators.required(l10n),
            ]),
            onChanged: (v) {
              company.certificateData ??= CompanyCertificateModel();
              try {
                company.certificateData!.certificateExpirationDate =
                    DateFormat('dd/MM/yyyy').parse(v);
              } catch (_) {
                company.certificateData!.certificateExpirationDate = null;
              }
            },
          ),
          if (dateMissing)
            Padding(
              padding: EdgeInsets.only(
                  top: size.height * 0.006, left: size.width * 0.03),
              child: Text(
                l10n.validatorRequired,
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: size.width * 0.03,
                ),
              ),
            ),
          SizedBox(height: size.height * 0.025),

          // ── Resumen ──────────────────────────────────────────────────────
          CompanyWizardStepSummary(
            items: [
              if (company.certificateData?.certificatePath != null)
                CompanyWizardSummaryItem(
                    icon: Icons.check_circle_outline,
                    text: l10n.step3CertSummary),
              if (company.certificateData?.certificateUser?.isNotEmpty == true)
                CompanyWizardSummaryItem(
                    icon: Icons.person_outline,
                    text: company.certificateData!.certificateUser!),
              if (company.certificateData?.certificateExpirationDate != null)
                CompanyWizardSummaryItem(
                    icon: Icons.calendar_today_outlined,
                    text: l10n.certificateExpiresSummary(
                      '${company.certificateData!.certificateExpirationDate!.day}/${company.certificateData!.certificateExpirationDate!.month}/${company.certificateData!.certificateExpirationDate!.year}',
                    )),
            ],
            size: size,
          ),
        ],
      ),
    );
  }
}
