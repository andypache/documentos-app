import 'package:flutter/material.dart';
import 'package:hdocumentos/src/widgets/customer/customer_wizard_step1_widget.dart';
import 'package:hdocumentos/src/widgets/customer/customer_wizard_step3_widget.dart';
import 'package:hdocumentos/src/widgets/customer/customer_wizard_discount_widget.dart';

/// Contenido dinámico del wizard según el paso actual
class CustomerWizardContent extends StatelessWidget {
  final int currentStep;

  const CustomerWizardContent({Key? key, required this.currentStep})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 0:
        return const CustomerWizardStep1Widget();
      case 1:
        return const CustomerWizardStep3Widget();
      case 2:
        return const CustomerWizardDiscountWidget();
      default:
        return const CustomerWizardStep1Widget();
    }
  }
}
