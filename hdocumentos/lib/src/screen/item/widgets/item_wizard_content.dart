import 'package:flutter/material.dart';
import 'package:hdocumentos/src/widgets/item/item_wizard_step1_widget.dart';
import 'package:hdocumentos/src/widgets/item/item_wizard_step2_widget.dart';
import 'package:hdocumentos/src/widgets/item/item_wizard_step3_widget.dart';
import 'package:hdocumentos/src/widgets/item/item_wizard_step4_widget.dart';

/// Contenido del paso actual del wizard de item
class ItemWizardContent extends StatelessWidget {
  final int currentStep;

  const ItemWizardContent({
    Key? key,
    required this.currentStep,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (currentStep) {
      case 0:
        return const ItemWizardStep1Widget();
      case 1:
        return const ItemWizardStep2Widget();
      case 2:
        return const ItemWizardStep3Widget();
      case 3:
        return const ItemWizardStep4Widget();
      default:
        return const ItemWizardStep1Widget();
    }
  }
}
