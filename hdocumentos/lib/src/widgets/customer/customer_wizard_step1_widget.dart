import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/form/customer_form_provider.dart';
import 'package:provider/provider.dart';

///Step 1: Identificación y Datos Personales/Empresa
class CustomerWizardStep1Widget extends StatefulWidget {
  const CustomerWizardStep1Widget({Key? key}) : super(key: key);

  @override
  State<CustomerWizardStep1Widget> createState() =>
      _CustomerWizardStep1WidgetState();
}

class _CustomerWizardStep1WidgetState extends State<CustomerWizardStep1Widget> {
  late TextEditingController _identificationController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _businessNameController;

  // Tipos de identificación comunes en Ecuador
  final List<IdentificationTypeModel> _identificationTypes = [
    IdentificationTypeModel(
      identificationTypeId: "1",
      name: "Cédula",
      description: "Cédula de Ciudadanía",
      inicials: "CED",
      sriCode: "05",
      length: 10,
      status: "A",
    ),
    IdentificationTypeModel(
      identificationTypeId: "2",
      name: "RUC",
      description: "Registro Único de Contribuyentes",
      inicials: "RUC",
      sriCode: "04",
      length: 13,
      status: "A",
    ),
    IdentificationTypeModel(
      identificationTypeId: "3",
      name: "Pasaporte",
      description: "Pasaporte",
      inicials: "PAS",
      sriCode: "06",
      length: 20,
      status: "A",
    ),
  ];

  @override
  void initState() {
    super.initState();
    final customerForm =
        Provider.of<CustomerFormProvider>(context, listen: false);
    _identificationController =
        TextEditingController(text: customerForm.identification);
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

    // Sincronizar solo si el valor cambió desde fuera
    if (_identificationController.text != customerForm.identification) {
      final selection = _identificationController.selection;
      _identificationController.text = customerForm.identification;
      _identificationController.selection = selection;
    }
    if (_firstNameController.text != customerForm.firstName) {
      final selection = _firstNameController.selection;
      _firstNameController.text = customerForm.firstName;
      _firstNameController.selection = selection;
    }
    if (_lastNameController.text != customerForm.lastName) {
      final selection = _lastNameController.selection;
      _lastNameController.text = customerForm.lastName;
      _lastNameController.selection = selection;
    }
    if (_businessNameController.text != customerForm.businessName) {
      final selection = _businessNameController.selection;
      _businessNameController.text = customerForm.businessName;
      _businessNameController.selection = selection;
    }
  }

  @override
  void dispose() {
    _identificationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerFormProvider>(
      builder: (context, customerForm, child) {
        return Form(
          key: customerForm.formKeyStep1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Identificación y Datos',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Tipo de Identificación
              DropdownButtonFormField<IdentificationTypeModel>(
                value: customerForm.identificationType != null
                    ? _identificationTypes.firstWhere(
                        (type) =>
                            type.identificationTypeId ==
                            customerForm
                                .identificationType?.identificationTypeId,
                        orElse: () => _identificationTypes.first,
                      )
                    : null,
                dropdownColor: const Color(0xff2a2d3e),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.credit_card, color: Colors.blue),
                  labelText: 'Tipo de Identificación *',
                  hintText: 'Seleccione el tipo',
                  floatingLabelStyle:
                      TextStyle(color: Colors.white.withOpacity(0.8)),
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                ),
                items: _identificationTypes.map((type) {
                  return DropdownMenuItem<IdentificationTypeModel>(
                    value: type,
                    child: Text('${type.name} (${type.inicials})'),
                  );
                }).toList(),
                onChanged: (value) {
                  customerForm.updateIdentificationType(value);
                },
                validator: (value) {
                  if (value == null) {
                    return 'Seleccione un tipo de identificación';
                  }
                  return null;
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              const SizedBox(height: 20),

              // Número de Identificación
              if (customerForm.identificationType != null)
                TextFormField(
                  controller: _identificationController,
                  style: const TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9A-Za-z]')),
                    LengthLimitingTextInputFormatter(
                        customerForm.identificationType?.length ?? 20),
                  ],
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.badge, color: Colors.blue),
                    labelText:
                        'Número de ${customerForm.identificationType?.name} *',
                    hintText:
                        'Ingrese el número (${customerForm.identificationType?.length} dígitos)',
                    floatingLabelStyle:
                        TextStyle(color: Colors.white.withOpacity(0.8)),
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
                  ),
                  onChanged: (value) => customerForm.identification = value,
                  validator: (value) => _validateIdentification(
                      value, customerForm.identificationType),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),

              const SizedBox(height: 30),

              // Divider
              if (customerForm.identificationType != null)
                const Divider(color: Colors.white24, thickness: 1),

              if (customerForm.identificationType != null)
                const SizedBox(height: 20),

              // Sección de datos personales o razón social
              if (customerForm.identificationType != null)
                if (customerForm.isCompany())
                  _buildBusinessNameField(customerForm)
                else
                  Column(
                    children: [
                      _buildFirstNameField(customerForm),
                      const SizedBox(height: 20),
                      _buildLastNameField(customerForm),
                    ],
                  ),
            ],
          ),
        );
      },
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

  String? _validateIdentification(
      String? value, IdentificationTypeModel? type) {
    if (value == null || value.isEmpty) {
      return 'El número de identificación es requerido';
    }

    if (type == null) {
      return 'Seleccione primero el tipo de identificación';
    }

    // Validar longitud
    if (type.length != null && value.length != type.length) {
      return 'Debe tener exactamente ${type.length} caracteres';
    }

    // Validación específica para cédula ecuatoriana
    if (type.sriCode == '05' && value.length == 10) {
      if (!_validateEcuadorianCedula(value)) {
        return 'Número de cédula inválido';
      }
    }

    // Validación específica para RUC ecuatoriano
    if (type.sriCode == '04' && value.length == 13) {
      if (!_validateEcuadorianRuc(value)) {
        return 'Número de RUC inválido';
      }
    }

    return null;
  }

  bool _validateEcuadorianCedula(String cedula) {
    if (cedula.length != 10) return false;

    try {
      final digits = cedula.split('').map((e) => int.parse(e)).toList();
      final provincia = int.parse(cedula.substring(0, 2));

      if (provincia < 1 || provincia > 24) return false;

      final coeficientes = [2, 1, 2, 1, 2, 1, 2, 1, 2];
      int suma = 0;

      for (int i = 0; i < 9; i++) {
        int valor = digits[i] * coeficientes[i];
        if (valor >= 10) valor -= 9;
        suma += valor;
      }

      final digitoVerificador = suma % 10 == 0 ? 0 : 10 - (suma % 10);
      return digitoVerificador == digits[9];
    } catch (e) {
      return false;
    }
  }

  bool _validateEcuadorianRuc(String ruc) {
    if (ruc.length != 13) return false;

    // El RUC debe terminar en 001
    if (!ruc.endsWith('001')) return false;

    // Los primeros 10 dígitos deben ser una cédula válida
    final cedula = ruc.substring(0, 10);
    return _validateEcuadorianCedula(cedula);
  }
}
