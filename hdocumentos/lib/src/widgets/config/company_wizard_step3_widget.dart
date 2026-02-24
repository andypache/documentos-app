import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/config/company_wizard_shared.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Paso 3: Certificado electrónico
class CompanyWizardStep3Widget extends StatelessWidget {
  const CompanyWizardStep3Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            title: 'Certificado Electrónico',
            size: size,
          ),
          SizedBox(height: size.height * 0.02),
          // Botón cargar certificado
          MaterialButtonWidget(
            type: AppTheme.secondaryButton,
            icon: Icons.upload_file,
            textButton: company.certificatePath != null
                ? 'Certificado cargado ✓'
                : 'Cargar firma electrónica (.p12 / .cert)',
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
                'El certificado es requerido',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: size.width * 0.03,
                ),
              ),
            ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.person_outline,
            labelText: 'Usuario del certificado',
            hintText: 'Nombre del titular (requerido)',
            initialValue: company.certificateUser,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Campo requerido' : null,
            onChanged: (v) => company.certificateUser = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.lock_outline,
            labelText: 'Contraseña del certificado',
            hintText: 'Contraseña (requerido)',
            obscureText: true,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Campo requerido' : null,
            onChanged: (v) => company.certificatePassword = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputDateFieldWidget(
            labelText: 'Fecha de expiración',
            hintText: 'Fecha de caducidad (requerido)',
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
                const CompanyWizardSummaryItem(
                    icon: Icons.check_circle_outline,
                    text: 'Certificado cargado'),
              if (company.certificateUser?.isNotEmpty == true)
                CompanyWizardSummaryItem(
                    icon: Icons.person_outline, text: company.certificateUser!),
              if (company.certificateExpirationDate != null)
                CompanyWizardSummaryItem(
                    icon: Icons.calendar_today_outlined,
                    text:
                        'Expira: ${company.certificateExpirationDate!.day}/${company.certificateExpirationDate!.month}/${company.certificateExpirationDate!.year}'),
            ],
            size: size,
          ),
        ],
      ),
    );
  }
}
