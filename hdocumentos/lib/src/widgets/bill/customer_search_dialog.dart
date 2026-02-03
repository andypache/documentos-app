import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Diálogo para buscar y seleccionar un cliente
class CustomerSearchDialog extends StatefulWidget {
  const CustomerSearchDialog({Key? key}) : super(key: key);

  @override
  State<CustomerSearchDialog> createState() => _CustomerSearchDialogState();
}

class _CustomerSearchDialogState extends State<CustomerSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _displayedCustomers = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void initState() {
    super.initState();
    _initializeMockData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeMockData() {
    // Datos de ejemplo (igual que en client_screen)
    _customers = [
      {
        'customerId': '1',
        'identificationTypeId': '1',
        'identification': '1234567890',
        'firstName': 'Juan',
        'lastName': 'Pérez',
        'businessName': null,
        'email': 'juan@example.com',
        'phone': '0987654321',
        'address': 'Av. Principal 123',
        'type': 'Cédula',
        'discountValue': 10, // Ejemplo de descuento
      },
      {
        'customerId': '2',
        'identificationTypeId': '2',
        'identification': '1790123456001',
        'firstName': null,
        'lastName': null,
        'businessName': 'Empresa ABC S.A.',
        'email': 'contacto@abc.com',
        'phone': '0987654322',
        'address': 'Calle Secundaria 456',
        'type': 'RUC',
        'discountValue': 15,
      },
      {
        'customerId': '3',
        'identificationTypeId': '1',
        'identification': '0987654321',
        'firstName': 'María',
        'lastName': 'González',
        'businessName': null,
        'email': 'maria@example.com',
        'phone': '0991234567',
        'address': 'Calle Las Flores 789',
        'type': 'Cédula',
        'discountValue': 0,
      },
    ];
  }

  Future<void> _searchCustomers() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    // TODO: Implementar búsqueda en el servicio
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        final queryLower = query.toLowerCase();
        _displayedCustomers = _customers.where((customer) {
          final firstName = (customer['firstName'] ?? '').toLowerCase();
          final lastName = (customer['lastName'] ?? '').toLowerCase();
          final businessName = (customer['businessName'] ?? '').toLowerCase();
          final name = '$firstName $lastName $businessName'.trim();
          final identification =
              (customer['identification'] ?? '').toLowerCase();
          return name.contains(queryLower) ||
              identification.contains(queryLower);
        }).toList();
        _isLoading = false;
      });
    }
  }

  void _selectCustomer(Map<String, dynamic> customerData) {
    // Convertir a CustomerModel
    final customer = CustomerModel(
      customerId: customerData['customerId'],
      identificationTypeId: customerData['identificationTypeId'],
      identification: customerData['identification'],
      firstName: customerData['firstName'],
      lastName: customerData['lastName'],
      businessName: customerData['businessName'],
      email: customerData['email'],
      phoneNumber: customerData['phone'],
      address: customerData['address'],
      status: 'A',
    );

    // Agregar información del tipo de identificación
    customer.identificationType = IdentificationTypeModel(
      identificationTypeId: customerData['identificationTypeId'],
      name: customerData['type'],
      description: customerData['type'],
      inicials: customerData['type'] == 'RUC' ? 'RUC' : 'CED',
      sriCode: '05',
      length: customerData['identification'].length,
      status: 'A',
    );

    // Agregar descuento si existe
    if (customerData['discountValue'] != null &&
        customerData['discountValue'] > 0) {
      customer.customerDiscount = CustomerDiscountModel(
        customerDiscountId: '1',
        discountValue: customerData['discountValue'],
        isVariable: 'N',
        status: 'A',
      );
    }

    Navigator.pop(context, customer);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.secondary.withOpacity(0.3),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person_search,
                      color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Buscar Cliente',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // Search field con botón Ver Todos integrado
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border:
                            Border.all(color: AppTheme.primaryButton, width: 1),
                      ),
                      child: TextField(
                        controller: _searchController,
                        autofocus: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Nombre o identificación',
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          prefixIcon: const Icon(Icons.search,
                              color: AppTheme.primaryButton),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: AppTheme.primaryButton),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _displayedCustomers = [];
                                      _hasSearched = false;
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        onChanged: (value) => setState(() {}),
                        onSubmitted: (value) {
                          if (value.trim().isNotEmpty) {
                            _searchCustomers();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryButton,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: _searchController.text.trim().isNotEmpty
                          ? _searchCustomers
                          : null,
                      tooltip: 'Buscar',
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryButton,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.list, color: Colors.white),
                      onPressed: () {
                        // TODO: Implementar ver todos los clientes
                        setState(() {
                          _hasSearched = true;
                          _displayedCustomers = _customers;
                        });
                      },
                      tooltip: 'Ver Todos',
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),

            // Results
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _buildResults(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    if (!_hasSearched) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search, size: 64, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'Ingresa el nombre o identificación\npara buscar un cliente',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppTheme.primaryButton),
      );
    }

    if (_displayedCustomers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off,
                size: 64, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'No se encontraron clientes',
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _displayedCustomers.length,
      itemBuilder: (context, index) {
        final customer = _displayedCustomers[index];
        return _buildCustomerCard(customer);
      },
    );
  }

  Widget _buildCustomerCard(Map<String, dynamic> customer) {
    final String displayName = customer['businessName'] ??
        '${customer['firstName'] ?? ''} ${customer['lastName'] ?? ''}'.trim();
    final hasDiscount =
        customer['discountValue'] != null && customer['discountValue'] > 0;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppTheme.secondary.withOpacity(0.5),
      child: InkWell(
        onTap: () => _selectCustomer(customer),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: AppTheme.primaryButton.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  customer['businessName'] != null
                      ? Icons.business
                      : Icons.person,
                  color: AppTheme.primaryButton,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${customer['type']} - ${customer['identification']}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 12,
                      ),
                    ),
                    if (hasDiscount) ...[
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.green, width: 1),
                        ),
                        child: Text(
                          'Descuento ${customer['discountValue']}%',
                          style: const TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white30,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
