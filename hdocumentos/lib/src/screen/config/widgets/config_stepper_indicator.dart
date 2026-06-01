import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Indicador de pasos del wizard con íconos y barra de progreso
class ConfigStepperIndicator extends StatelessWidget {
  final int currentStep;

  const ConfigStepperIndicator({
    Key? key,
    required this.currentStep,
  }) : super(key: key);

  static const List<IconData> _stepIcons = [
    Icons.business,
    Icons.image_outlined,
    Icons.security_outlined,
    Icons.mail_outline,
    Icons.point_of_sale_outlined,
    Icons.receipt_long_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);
    final stepLabels = [
      l10n.stepCompany,
      l10n.stepLogo,
      l10n.stepCert,
      l10n.stepMail,
      l10n.stepEmission,
      l10n.stepTaxes,
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 8),
      child: Row(
        children: List.generate(_stepIcons.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                margin: const EdgeInsets.only(bottom: 24),
                decoration: BoxDecoration(
                  color: stepIndex < currentStep
                      ? AppTheme.primaryButton
                      : Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppDimens.borderThin),
                ),
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final isActive = stepIndex == currentStep;
          final isCompleted = stepIndex < currentStep;

          return Expanded(
            child: Column(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: size.width * 0.065,
                  height: size.width * 0.065,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive || isCompleted
                        ? AppTheme.primaryButton
                        : Colors.white.withOpacity(0.12),
                    border: Border.all(
                      color: isActive || isCompleted
                          ? AppTheme.primaryButton
                          : Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: AppTheme.primaryButton.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 1,
                            )
                          ]
                        : [],
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(Icons.check_rounded,
                            color: Colors.white, size: size.width * 0.04)
                        : Icon(_stepIcons[stepIndex],
                            color: isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                            size: size.width * 0.04),
                  ),
                ),
                SizedBox(height: AppDimens.spaceXS),
                Text(
                  stepLabels[stepIndex],
                  style: TextStyle(
                    color: isActive || isCompleted
                        ? Colors.white
                        : Colors.white.withOpacity(0.4),
                    fontSize: size.width * 0.021,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
