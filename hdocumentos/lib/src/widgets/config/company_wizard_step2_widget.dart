import 'package:flutter/material.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/config/company_wizard_shared.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Paso 2: Logo, sitio web y configuración adicional
class CompanyWizardStep2Widget extends StatelessWidget {
  const CompanyWizardStep2Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CompanyFormProvider>(context);
    final company = provider.company;

    return Form(
      key: provider.formKeyStep2,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyWizardSectionHeader(
            icon: Icons.image_outlined,
            title: 'Logo y Configuración Web',
            size: size,
          ),
          SizedBox(height: size.height * 0.02),
          // Logo de la empresa
          ImagePickerFieldWidget(
            label: 'Logo de la empresa',
            currentImage: provider.logoBytes,
            imageName: provider.company.logoPath,
            onImagePicked: (bytes, path) => provider.updateLogo(bytes, path),
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.language_outlined,
            labelText: 'Sitio web',
            hintText: 'https://www.empresa.com (opcional)',
            initialValue: company.website,
            keyboardType: TextInputType.url,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) => company.website = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputNumberFieldWidget(
            prefixIcon: Icons.discount_outlined,
            labelText: 'Descuento máximo (%)',
            hintText: 'Ej: 10.00 (opcional)',
            initialValue: company.maxDiscount,
            allowDecimals: true,
            onChanged: (v) => company.maxDiscount = double.tryParse(v),
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.pin_drop_outlined,
            labelText: 'Dirección de artículos',
            hintText: 'Dirección alternativa (opcional)',
            initialValue: company.itemAddress,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) => company.itemAddress = v,
          ),
          SizedBox(height: size.height * 0.025),
          // Resumen
          CompanyWizardStepSummary(
            items: [
              if (provider.logoBytes != null)
                const CompanyWizardSummaryItem(
                    icon: Icons.check_circle_outline, text: 'Logo cargado'),
              if (company.website?.isNotEmpty == true)
                CompanyWizardSummaryItem(
                    icon: Icons.language_outlined, text: company.website!),
              if (company.maxDiscount != null)
                CompanyWizardSummaryItem(
                    icon: Icons.discount_outlined,
                    text: 'Descuento máx: ${company.maxDiscount}%'),
            ],
            size: size,
          ),
        ],
      ),
    );
  }
}
