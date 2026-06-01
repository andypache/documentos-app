import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Indicador de pasos estilo íconos para wizard de item (4 pasos)
class ItemStepperIndicator extends StatelessWidget {
  final int currentStep;
  final bool isEditing;

  const ItemStepperIndicator({
    Key? key,
    required this.currentStep,
    required this.isEditing,
  }) : super(key: key);

  static const List<IconData> _stepIcons = [
    Icons.info_outline_rounded,
    Icons.attach_money_rounded,
    Icons.qr_code_rounded,
    Icons.receipt_long_outlined,
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);
    final stepLabels = [
      l10n.stepBasic,
      isEditing ? l10n.labelDiscount : l10n.stepPrices,
      l10n.stepCodes,
      l10n.stepTaxes,
    ];

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.04,
        vertical: 6,
      ),
      child: Row(
        children: List.generate(_stepIcons.length * 2 - 1, (i) {
          if (i.isOdd) {
            final stepIndex = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                margin: EdgeInsets.only(bottom: AppDimens.paddingL),
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
                  width: (size.width * 0.065).clamp(24.0, 44.0),
                  height: (size.width * 0.065).clamp(24.0, 44.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive || isCompleted
                        ? AppTheme.primaryButton
                        : Colors.white.withOpacity(0.12),
                    border: Border.all(
                      color: isActive || isCompleted
                          ? AppTheme.primaryButton
                          : Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? Icon(Icons.check_rounded,
                            color: Colors.white,
                            size: (size.width * 0.038).clamp(12.0, 22.0))
                        : Icon(
                            _stepIcons[stepIndex],
                            color: isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.4),
                            size: (size.width * 0.038).clamp(12.0, 22.0),
                          ),
                  ),
                ),
                SizedBox(height: AppDimens.spaceXS),
                Text(
                  stepLabels[stepIndex],
                  style: TextStyle(
                    color:
                        isActive || isCompleted ? Colors.white : Colors.white54,
                    fontSize: (size.shortestSide * 0.026).clamp(10.0, 13.0),
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
