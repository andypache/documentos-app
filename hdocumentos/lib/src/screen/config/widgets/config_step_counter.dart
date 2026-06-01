import 'package:flutter/material.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';

/// Contador de pasos actual/total del wizard
class ConfigStepCounter extends StatelessWidget {
  final CompanyFormProvider provider;
  final double counterFontSize;
  final bool isLandscape;

  const ConfigStepCounter({
    Key? key,
    required this.provider,
    required this.counterFontSize,
    required this.isLandscape,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 12.0 : size.width * 0.03,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(AppDimens.radiusS),
        border: Border.all(color: Colors.white.withOpacity(0.15), width: 1),
      ),
      child: Text(
        '${provider.currentStep + 1} / 6',
        style: TextStyle(
          color: Colors.white.withOpacity(0.85),
          fontSize: counterFontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
