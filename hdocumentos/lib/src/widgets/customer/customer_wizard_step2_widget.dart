import 'package:flutter/material.dart';
import 'package:hdocumentos/src/provider/form/customer_form_provider.dart';
import 'package:provider/provider.dart';

///Step 2: Datos Personales o Razón Social (dinámico)
class CustomerWizardStep2Widget extends StatefulWidget {
  const CustomerWizardStep2Widget({Key? key}) : super(key: key);

  @override
  State<CustomerWizardStep2Widget> createState() =>
      _CustomerWizardStep2WidgetState();
}

class _CustomerWizardStep2WidgetState extends State<CustomerWizardStep2Widget> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _businessNameController;

  @override
  void initState() {
    super.initState();
    final customerForm =
        Provider.of<CustomerFormProvider>(context, listen: false);
    _firstNameController = TextEditingController(text: customerForm.firstName);
    _lastNameController = TextEditingController(text: customerForm.lastName);
    _businessNameController =
        TextEditingController(text: customerForm.businessName);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final customerForm =
        Provider.of<CustomerFormProvider>(context, listen: false);

    if (_firstNameController.text != customerForm.firstName) {
      _firstNameController.text = customerForm.firstName;
    }
    if (_lastNameController.text != customerForm.lastName) {
      _lastNameController.text = customerForm.lastName;
    }
    if (_businessNameController.text != customerForm.businessName) {
      _businessNameController.text = customerForm.businessName;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerForm = Provider.of<CustomerFormProvider>(context);
    final isCompany = customerForm.isCompany();

    return Form(
      key: customerForm.formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isCompany ? 'Datos de la Empresa' : 'Datos Personales',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          if (isCompany)
            // Razón Social para empresas
            _buildBusinessNameField(customerForm)
          else
            // Nombres y Apellidos para personas naturales
            Column(
              children: [
                _buildFirstNameField(customerForm),
                const SizedBox(height: 20),
                _buildLastNameField(customerForm),
              ],
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBusinessNameField(CustomerFormProvider customerForm) {
    return TextFormField(
      controller: _businessNameController,
      style: const TextStyle(color: Colors.white),
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.business, color: Colors.blue),
        labelText: 'Razón Social *',
        hintText: 'Ingrese la razón social de la empresa',
        floatingLabelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
      ),
      onChanged: (value) => customerForm.businessName = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'La razón social es requerida';
        }
        if (value.length < 3) {
          return 'Mínimo 3 caracteres';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildFirstNameField(CustomerFormProvider customerForm) {
    return TextFormField(
      controller: _firstNameController,
      style: const TextStyle(color: Colors.white),
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_outline, color: Colors.blue),
        labelText: 'Nombres *',
        hintText: 'Ingrese los nombres',
        floatingLabelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
      ),
      onChanged: (value) => customerForm.firstName = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Los nombres son requeridos';
        }
        if (value.length < 2) {
          return 'Mínimo 2 caracteres';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }

  Widget _buildLastNameField(CustomerFormProvider customerForm) {
    return TextFormField(
      controller: _lastNameController,
      style: const TextStyle(color: Colors.white),
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person, color: Colors.blue),
        labelText: 'Apellidos *',
        hintText: 'Ingrese los apellidos',
        floatingLabelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
      ),
      onChanged: (value) => customerForm.lastName = value,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Los apellidos son requeridos';
        }
        if (value.length < 2) {
          return 'Mínimo 2 caracteres';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
