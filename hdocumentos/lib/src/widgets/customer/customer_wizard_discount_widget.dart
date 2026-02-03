import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../provider/form/customer_form_provider.dart';

///Widget for customer wizard step 3 - Descuento del Cliente
class CustomerWizardDiscountWidget extends StatefulWidget {
  const CustomerWizardDiscountWidget({super.key});

  @override
  State<CustomerWizardDiscountWidget> createState() =>
      _CustomerWizardDiscountWidgetState();
}

class _CustomerWizardDiscountWidgetState
    extends State<CustomerWizardDiscountWidget> {
  final TextEditingController _discountValueController =
      TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() {
    super.initState();
    // Sincronizar con el provider al inicializar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _syncWithProvider();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncWithProvider();
  }

  void _syncWithProvider() {
    final customerForm =
        Provider.of<CustomerFormProvider>(context, listen: false);

    if (_discountValueController.text !=
        customerForm.discountValue.toString()) {
      _discountValueController.text = customerForm.discountValue > 0
          ? customerForm.discountValue.toString()
          : '';
    }

    if (customerForm.startDate != null) {
      final formattedDate = _dateFormat.format(customerForm.startDate!);
      if (_startDateController.text != formattedDate) {
        _startDateController.text = formattedDate;
      }
    } else {
      _startDateController.clear();
    }

    if (customerForm.endDate != null) {
      final formattedDate = _dateFormat.format(customerForm.endDate!);
      if (_endDateController.text != formattedDate) {
        _endDateController.text = formattedDate;
      }
    } else {
      _endDateController.clear();
    }
  }

  @override
  void dispose() {
    _discountValueController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final customerForm =
        Provider.of<CustomerFormProvider>(context, listen: false);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate
          ? (customerForm.startDate ?? DateTime.now())
          : (customerForm.endDate ?? DateTime.now()),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          customerForm.startDate = picked;
          _startDateController.text = _dateFormat.format(picked);
        } else {
          customerForm.endDate = picked;
          _endDateController.text = _dateFormat.format(picked);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CustomerFormProvider>(
      builder: (context, customerForm, child) {
        return Form(
          key: customerForm.formKeyStep3,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Título
                Text(
                  'Descuento del Cliente',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Configura el descuento aplicable al cliente (opcional)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 24),

                // Tipo de descuento
                SwitchListTile(
                  title: const Text('¿Descuento variable?'),
                  subtitle: Text(
                    customerForm.isVariable
                        ? 'El descuento puede cambiar según las condiciones'
                        : 'El descuento es fijo',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  value: customerForm.isVariable,
                  onChanged: (value) {
                    setState(() {
                      customerForm.isVariable = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                  activeColor: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 16),

                // Valor del descuento
                TextFormField(
                  controller: _discountValueController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.percent),
                    labelText: 'Valor del descuento (%)',
                    hintText: 'Ej: 10',
                    border: OutlineInputBorder(),
                    helperText: 'Porcentaje de descuento (0-100)',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return null; // Opcional
                    }
                    final intValue = int.tryParse(value);
                    if (intValue == null) {
                      return 'Debe ser un número entero';
                    }
                    if (intValue < 0 || intValue > 100) {
                      return 'El descuento debe estar entre 0 y 100';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    customerForm.discountValue = int.tryParse(value) ?? 0;
                  },
                ),
                const SizedBox(height: 16),

                // Divider
                const Divider(height: 32),
                Text(
                  'Periodo de Vigencia',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),

                // Fecha de inicio
                TextFormField(
                  controller: _startDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.calendar_today),
                    labelText: 'Fecha de inicio',
                    hintText: 'Selecciona una fecha',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          customerForm.startDate = null;
                          _startDateController.clear();
                        });
                      },
                    ),
                  ),
                  onTap: () => _selectDate(context, true),
                  validator: (value) {
                    // Validar que si hay fecha de fin, también haya fecha de inicio
                    if (customerForm.endDate != null &&
                        customerForm.startDate == null) {
                      return 'Debe especificar la fecha de inicio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Fecha de fin
                TextFormField(
                  controller: _endDateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.event),
                    labelText: 'Fecha de fin',
                    hintText: 'Selecciona una fecha',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          customerForm.endDate = null;
                          _endDateController.clear();
                        });
                      },
                    ),
                  ),
                  onTap: () => _selectDate(context, false),
                  validator: (value) {
                    // Validar que la fecha de fin sea posterior a la de inicio
                    if (customerForm.startDate != null &&
                        customerForm.endDate != null) {
                      if (customerForm.endDate!
                          .isBefore(customerForm.startDate!)) {
                        return 'La fecha de fin debe ser posterior a la de inicio';
                      }
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Mensaje informativo
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700]),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Si no especificas fechas, el descuento estará activo permanentemente',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue[900],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
