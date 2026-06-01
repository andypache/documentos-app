import 'package:flutter/material.dart';
import 'package:hdocumentos/src/provider/form/customer_form_provider.dart';
import 'package:hdocumentos/src/screen/customer/widgets/customer_stepper_indicator.dart';
import 'package:hdocumentos/src/screen/customer/widgets/customer_wizard_content.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:provider/provider.dart';

/// Container principal del wizard con stepper y contenido
class CustomerWizardContainer extends StatelessWidget {
  const CustomerWizardContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerForm = Provider.of<CustomerFormProvider>(context);
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
      child: Column(
        children: [
          CustomerStepperIndicator(currentStep: customerForm.currentStep),
          SizedBox(height: AppDimens.spaceL),
          CustomerWizardContent(currentStep: customerForm.currentStep),
          SizedBox(height: AppDimens.spaceL),
        ],
      ),
    );
  }
}
