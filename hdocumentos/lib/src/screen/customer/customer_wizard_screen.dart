import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/form/customer_form_provider.dart';
import 'package:hdocumentos/src/screen/customer/widgets/widgets.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

///Pantalla de wizard para crear/editar clientes
class CustomerWizardScreen extends StatelessWidget {
  final CustomerModel? customerToEdit;

  const CustomerWizardScreen({Key? key, this.customerToEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final provider = CustomerFormProvider();
        if (customerToEdit != null) {
          provider.loadCustomer(customerToEdit!);
        }
        return provider;
      },
      child: _CustomerWizardBody(isEditing: customerToEdit != null),
    );
  }
}

///Cuerpo del wizard
class _CustomerWizardBody extends StatelessWidget {
  final bool isEditing;

  const _CustomerWizardBody({Key? key, required this.isEditing})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BrackgroundWidget(),
          SafeArea(
            child: Column(
              children: [
                CustomerWizardHeader(isEditing: isEditing),
                Expanded(
                  child: SingleChildScrollView(
                    child: const CustomerWizardContainer(),
                  ),
                ),
                const CustomerNavigationButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
