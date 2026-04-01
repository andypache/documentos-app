import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/common/key_value_model.dart';
import 'package:hdocumentos/src/provider/app_init_provider.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Paso 5: Punto de emisión
class CompanyWizardStep5Widget extends StatelessWidget {
  const CompanyWizardStep5Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CompanyFormProvider>(context);
    final company = provider.company;

    // Tipos de documento obtenidos del catálogo del servidor
    final catalogs = context.watch<AppInitProvider>().catalogs;
    final List<KeyValueModel> docTypes = catalogs?.documentTypes
            .map((e) => KeyValueModel(key: e.code, value: e.description))
            .toList() ??
        [];

    return Form(
      key: provider.formKeyStep5,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyWizardSectionHeader(
            icon: Icons.point_of_sale_outlined,
            title: l10n.step5Title,
            size: size,
          ),
          SizedBox(height: size.height * 0.02),
          DropdownButtonFieldWidget(
            prefixIcon: Icons.description_outlined,
            labelText: l10n.docType,
            hintText: l10n.docTypeHint,
            items: docTypes,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            initialValue: company.documentTypeId,
            onChanged: (v) {
              company.documentTypeId = v;
              company.documentTypeName =
                  docTypes.firstWhere((e) => e.key == v).value.toString();
            },
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.store_mall_directory_outlined,
            labelText: l10n.establishmentCode,
            hintText: l10n.establishmentCodeHint,
            initialValue: company.establishmentCode,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: FieldValidators.compose([
              FieldValidators.required(l10n),
              FieldValidators.exactLength(l10n, 3),
            ]),
            onChanged: (v) => company.establishmentCode = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.receipt_long_outlined,
            labelText: l10n.emissionPointCode,
            hintText: l10n.emissionPointCodeHint,
            initialValue: company.emissionPointCode,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            validator: FieldValidators.compose([
              FieldValidators.required(l10n),
              FieldValidators.exactLength(l10n, 3),
            ]),
            onChanged: (v) => company.emissionPointCode = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputNumberFieldWidget(
            prefixIcon: Icons.format_list_numbered,
            labelText: l10n.currentSequential,
            hintText: l10n.currentSequentialHint,
            initialValue: (company.currentSequential ?? 1).toDouble(),
            validator: FieldValidators.compose([
              FieldValidators.required(l10n),
            ]),
            onChanged: (v) => company.currentSequential = int.tryParse(v) ?? 1,
          ),
          SizedBox(height: size.height * 0.018),
          InputFieldWidget(
            prefixIcon: Icons.notes_outlined,
            labelText: l10n.emissionDescription,
            hintText: l10n.emissionDescriptionHint,
            initialValue: company.description,
            filled: true,
            fillColor: AppTheme.whiteGradient,
            onChanged: (v) => company.description = v,
          ),
          SizedBox(height: size.height * 0.018),
          InputSwitchFieldWidget(
            label: l10n.activeEmissionPoint,
            value: company.isActive ?? true,
            onChanged: (v) => company.isActive = v,
          ),
          SizedBox(height: size.height * 0.025),
          // Resumen final completo
          _FinalSummaryWidget(size: size),
        ],
      ),
    );
  }
}

/// Resumen final con todos los datos ingresados
class _FinalSummaryWidget extends StatelessWidget {
  final Size size;
  const _FinalSummaryWidget({Key? key, required this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final company = Provider.of<CompanyFormProvider>(context).company;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.04),
      decoration: BoxDecoration(
        color: AppTheme.primaryButton.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: AppTheme.primaryButton.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.checklist_rtl,
                  color: AppTheme.primaryButton, size: size.width * 0.048),
              SizedBox(width: size.width * 0.02),
              Text(
                l10n.finalSummaryTitle,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size.width * 0.038,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(
              color: Colors.white.withOpacity(0.2),
              height: size.height * 0.025),
          _SummaryRow(
              label: l10n.summaryCompanyName,
              value: company.businessName,
              size: size),
          _SummaryRow(
              label: l10n.summaryIdentification,
              value: company.identification,
              size: size),
          _SummaryRow(
              label: l10n.summaryAddress, value: company.address, size: size),
          _SummaryRow(
              label: l10n.summaryEmail, value: company.email, size: size),
          if (company.website?.isNotEmpty == true)
            _SummaryRow(
                label: l10n.summaryWebsite, value: company.website, size: size),
          _SummaryRow(
              label: l10n.summaryEstablishment,
              value: company.establishmentCode,
              size: size),
          _SummaryRow(
              label: l10n.summaryEmissionPoint,
              value: company.emissionPointCode,
              size: size),
          _SummaryRow(
            label: l10n.summaryCertificate,
            value: company.certificatePath != null
                ? l10n.summaryCertLoaded
                : l10n.summaryCertNotLoaded,
            size: size,
            valueColor: company.certificatePath != null
                ? Colors.greenAccent
                : Colors.redAccent,
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String? value;
  final Size size;
  final Color? valueColor;
  const _SummaryRow(
      {Key? key,
      required this.label,
      required this.value,
      required this.size,
      this.valueColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.only(bottom: size.height * 0.007),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: size.width * 0.3,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: size.width * 0.03,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value!,
              style: TextStyle(
                color: valueColor ?? Colors.white,
                fontSize: size.width * 0.03,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
