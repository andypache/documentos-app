import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/common/key_value_model.dart';
import 'package:hdocumentos/src/model/config/company_model.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/config/company_wizard_shared.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Paso 1: Datos principales de la empresa
class CompanyWizardStep1Widget extends StatelessWidget {
  const CompanyWizardStep1Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CompanyFormProvider>(context);
    final company = provider.company;

    // Tipos de identificación de ejemplo (en producción vendría del backend)
    final List<KeyValueModel> idTypes = [
      KeyValueModel(key: '1', value: 'RUC'),
      KeyValueModel(key: '2', value: 'Cédula'),
      KeyValueModel(key: '3', value: 'Pasaporte'),
    ];

    return Form(
      key: provider.formKeyStep1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyWizardSectionHeader(
            icon: Icons.business,
            title: 'Datos de la Empresa',
            size: size,
          ),
          SizedBox(height: size.height * 0.02),
          DropdownButtonFieldWidget(
            prefixIcon: Icons.badge_outlined,
            labelText: 'Tipo de identificación',
            hintText: 'Seleccione el tipo (requerido)',
            items: idTypes,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            initialValue: company.identificationTypeId,
            onChanged: (value) {
              company.identificationTypeId = value;
              company.identificationTypeName =
                  idTypes.firstWhere((e) => e.key == value).value.toString();
            },
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.numbers,
            labelText: 'Número de identificación',
            hintText: 'RUC / Cédula (requerido)',
            initialValue: company.identification,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Campo requerido' : null,
            onChanged: (v) => company.identification = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.store_outlined,
            labelText: 'Razón social',
            hintText: 'Nombre de la empresa (requerido)',
            initialValue: company.businessName,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Campo requerido' : null,
            onChanged: (v) => company.businessName = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.location_on_outlined,
            labelText: 'Dirección',
            hintText: 'Dirección de la empresa (requerido)',
            initialValue: company.address,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Campo requerido' : null,
            onChanged: (v) => company.address = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.phone_outlined,
            labelText: 'Teléfono',
            hintText: 'Teléfono (opcional)',
            initialValue: company.phone,
            keyboardType: TextInputType.phone,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) => company.phone = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.email_outlined,
            labelText: 'Correo electrónico',
            hintText: 'Email corporativo (requerido)',
            initialValue: company.email,
            keyboardType: TextInputType.emailAddress,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: (v) =>
                (v == null || v.isEmpty) ? 'Campo requerido' : null,
            onChanged: (v) => company.email = v,
          ),
          SizedBox(height: size.height * 0.008),
          InputSwitchFieldWidget(
            label: 'Empresa activa',
            value: company.state == null || company.state == CompanyState.A,
            onChanged: (v) =>
                company.state = v ? CompanyState.A : CompanyState.I,
          ),
          SizedBox(height: size.height * 0.025),
          // Resumen del paso
          CompanyWizardStepSummary(
            items: [
              if (company.businessName?.isNotEmpty == true)
                CompanyWizardSummaryItem(
                    icon: Icons.store_outlined, text: company.businessName!),
              if (company.identification?.isNotEmpty == true)
                CompanyWizardSummaryItem(
                    icon: Icons.numbers, text: company.identification!),
              if (company.email?.isNotEmpty == true)
                CompanyWizardSummaryItem(
                    icon: Icons.email_outlined, text: company.email!),
            ],
            size: size,
          ),
        ],
      ),
    );
  }
}
