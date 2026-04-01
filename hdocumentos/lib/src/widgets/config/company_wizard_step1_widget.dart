import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/common/key_value_model.dart';
import 'package:hdocumentos/src/model/config/company_model.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/provider/provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Paso 1: Datos principales de la empresa
class CompanyWizardStep1Widget extends StatelessWidget {
  const CompanyWizardStep1Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CompanyFormProvider>(context);
    final catalogs = context.watch<AppInitProvider>().catalogs;
    final l10n = AppLocalizations.of(context);

    final company = provider.company;

    final List<KeyValueModel> idTypes =
        (catalogs?.identificationTypes.isNotEmpty ?? false)
            ? catalogs!.identificationTypes
                .map((e) => KeyValueModel(key: e.code, value: e.description))
                .toList()
            : [];

    return Form(
      key: provider.formKeyStep1,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyWizardSectionHeader(
            icon: Icons.business,
            title: l10n.companyInformation,
            size: size,
          ),
          SizedBox(height: size.height * 0.02),
          DropdownButtonFieldWidget(
            prefixIcon: Icons.badge_outlined,
            labelText: l10n.identificationType,
            hintText: l10n.requiredSelect,
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
            labelText: l10n.identificationNumber,
            hintText: l10n.identificationNumberHint,
            initialValue: company.identification,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: FieldValidators.compose([
              FieldValidators.required(l10n),
            ]),
            onChanged: (v) => company.identification = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.store_outlined,
            labelText: l10n.companyName,
            hintText: l10n.companyNameHint,
            initialValue: company.businessName,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: FieldValidators.compose([
              FieldValidators.required(l10n),
            ]),
            onChanged: (v) => company.businessName = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.location_on_outlined,
            labelText: l10n.address,
            hintText: l10n.addressHint,
            initialValue: company.address,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: FieldValidators.compose([
              FieldValidators.required(l10n),
              FieldValidators.maxLength(l10n, 200),
              FieldValidators.alphanumeric(l10n),
            ]),
            onChanged: (v) => company.address = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.phone_outlined,
            labelText: l10n.telephone,
            hintText: l10n.telephoneHint,
            initialValue: company.phone,
            keyboardType: TextInputType.phone,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) => company.phone = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.email_outlined,
            labelText: l10n.email,
            hintText: l10n.emailHint,
            initialValue: company.email,
            keyboardType: TextInputType.emailAddress,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: FieldValidators.compose([
              FieldValidators.required(l10n),
              FieldValidators.email(l10n),
            ]),
            onChanged: (v) => company.email = v,
          ),
          SizedBox(height: size.height * 0.008),
          InputSwitchFieldWidget(
            label: l10n.activeCompany,
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
