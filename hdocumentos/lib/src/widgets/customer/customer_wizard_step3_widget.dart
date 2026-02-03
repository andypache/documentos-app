import 'package:flutter/material.dart';
import 'package:hdocumentos/src/provider/form/customer_form_provider.dart';
import 'package:provider/provider.dart';

///Step 2: Información de Contacto y Dirección
class CustomerWizardStep2Widget extends StatefulWidget {
  const CustomerWizardStep2Widget({Key? key}) : super(key: key);

  @override
  State<CustomerWizardStep2Widget> createState() =>
      _CustomerWizardStep2WidgetState();
}

class _CustomerWizardStep2WidgetState extends State<CustomerWizardStep2Widget> {
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    final customerForm =
        Provider.of<CustomerFormProvider>(context, listen: false);
    _emailController = TextEditingController(text: customerForm.email);
    _phoneController = TextEditingController(text: customerForm.phoneNumber);
    _addressController = TextEditingController(text: customerForm.address);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final customerForm =
        Provider.of<CustomerFormProvider>(context, listen: false);

    // Sincronizar solo si el valor cambió desde fuera
    if (_emailController.text != customerForm.email) {
      final selection = _emailController.selection;
      _emailController.text = customerForm.email;
      _emailController.selection = selection;
    }
    if (_phoneController.text != customerForm.phoneNumber) {
      final selection = _phoneController.selection;
      _phoneController.text = customerForm.phoneNumber;
      _phoneController.selection = selection;
    }
    if (_addressController.text != customerForm.address) {
      final selection = _addressController.selection;
      _addressController.text = customerForm.address;
      _addressController.selection = selection;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customerForm = Provider.of<CustomerFormProvider>(context);

    return Form(
      key: customerForm.formKeyStep2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información de Contacto',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Email
          TextFormField(
            controller: _emailController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.email_outlined, color: Colors.blue),
              labelText: 'Correo Electrónico',
              hintText: 'ejemplo@correo.com (opcional)',
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) => customerForm.email = value,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                final emailRegex =
                    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Ingrese un correo válido';
                }
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 20),

          // Teléfono
          TextFormField(
            controller: _phoneController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.phone_outlined, color: Colors.blue),
              labelText: 'Teléfono',
              hintText: '0999999999 (opcional)',
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            onChanged: (value) => customerForm.phoneNumber = value,
            validator: (value) {
              if (value != null && value.isNotEmpty) {
                // Validación básica para números de Ecuador
                if (value.length < 9 || value.length > 10) {
                  return 'Ingrese un número válido (9-10 dígitos)';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'Solo se permiten números';
                }
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 20),

          // Dirección
          TextFormField(
            controller: _addressController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.streetAddress,
            maxLines: 3,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              prefixIcon:
                  const Icon(Icons.location_on_outlined, color: Colors.blue),
              labelText: 'Dirección',
              hintText: 'Ingrese la dirección completa (opcional)',
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
              alignLabelWithHint: true,
            ),
            onChanged: (value) => customerForm.address = value,
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 20),

          // Información adicional
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.blue, width: 1),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Los datos de contacto son opcionales pero recomendados para mantener comunicación con el cliente.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
