import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Indicador de pasos del wizard de clientes
class CustomerStepperIndicator extends StatelessWidget {
  final int currentStep;

  const CustomerStepperIndicator({Key? key, required this.currentStep})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: size.width * 0.04, vertical: 10),
      child: Row(
        children: [
          _buildStep(context, 0, l10n.stepCustomerData, currentStep),
          _buildConnector(0, currentStep),
          _buildStep(context, 1, l10n.stepCustomerContact, currentStep),
          _buildConnector(1, currentStep),
          _buildStep(context, 2, l10n.labelDiscount, currentStep),
        ],
      ),
    );
  }

  Widget _buildStep(
      BuildContext context, int stepNumber, String label, int currentStep) {
    final isActive = stepNumber == currentStep;
    final isCompleted = stepNumber < currentStep;
    final size = MediaQuery.of(context).size;
    final circleSize = (size.shortestSide * 0.1).clamp(32.0, 48.0);
    final iconSize = (size.shortestSide * 0.05).clamp(16.0, 24.0);
    final labelFontSize = (size.shortestSide * 0.028).clamp(10.0, 13.0);

    return Expanded(
      child: Column(
        children: [
          Container(
            width: circleSize,
            height: circleSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive || isCompleted
                  ? AppTheme.primaryButton
                  : Colors.white.withOpacity(0.2),
              border: Border.all(
                color: isActive || isCompleted
                    ? AppTheme.primaryButton
                    : Colors.white.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: isCompleted
                  ? Icon(Icons.check, color: Colors.white, size: iconSize)
                  : Text(
                      '${stepNumber + 1}',
                      style: TextStyle(
                        color: isActive || isCompleted
                            ? Colors.white
                            : Colors.white.withOpacity(0.5),
                        fontWeight: FontWeight.bold,
                        fontSize: iconSize * 0.8,
                      ),
                    ),
            ),
          ),
          SizedBox(height: AppDimens.spaceXS),
          Text(
            label,
            style: TextStyle(
              color: isActive || isCompleted
                  ? Colors.white
                  : Colors.white.withOpacity(0.5),
              fontSize: labelFontSize,
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConnector(int stepNumber, int currentStep) {
    final isCompleted = stepNumber < currentStep;
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: AppDimens.paddingL),
        color: isCompleted
            ? AppTheme.primaryButton
            : Colors.white.withOpacity(0.2),
      ),
    );
  }
}
