import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/screen/customer/customer_wizard_screen.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for render client application
class ClientScreen extends StatelessWidget {
  const ClientScreen({Key? key}) : super(key: key);

  //Render principal widgets load background, body and float buttom
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Stack(children: [BrackgroundWidget(), _ClientScreenBody()]),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 20,
        backgroundColor: AppTheme.primaryButton,
        icon: const Icon(Icons.person_add),
        label: const Text('Nuevo Cliente'),
        onPressed: () => _navigateToCreateCustomer(context),
      ),
    );
  }

  Future<void> _navigateToCreateCustomer(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CustomerWizardScreen()),
    );

    // Si se guardó un cliente, mostrar mensaje
    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente guardado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

///Body for bill into sroll view
class _ClientScreenBody extends StatefulWidget {
  const _ClientScreenBody({Key? key}) : super(key: key);

  @override
  State<_ClientScreenBody> createState() => _ClientScreenBodyState();
}

class _ClientScreenBodyState extends State<_ClientScreenBody> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header con título y botón de cerrar
        Container(
          padding:
              const EdgeInsets.only(top: 40, left: 20, right: 20, bottom: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: PageTitleWidget(title: 'Clientes'),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Navigator.pop(context),
                tooltip: 'Cerrar',
              ),
            ],
          ),
        ),
        // Resto del contenido
        const Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 45),
                _SearchSection(),
                SizedBox(height: 20),
                _CustomerListSection(),
                SizedBox(height: 80), // Espacio para el FAB
              ],
            ),
          ),
        ),
      ],
    );
  }
}

///Sección de búsqueda
class _SearchSection extends StatefulWidget {
  const _SearchSection({Key? key}) : super(key: key);

  @override
  State<_SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<_SearchSection> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _customers = [];
  List<Map<String, dynamic>> _displayedCustomers = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeMockData() {
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
        'sriCode': '05',
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
        'sriCode': '04',
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
        'sriCode': '05',
      },
      {
        'customerId': '4',
        'identificationTypeId': '2',
        'identification': '1791234567001',
        'firstName': null,
        'lastName': null,
        'businessName': 'Tech Solutions Cía. Ltda.',
        'email': 'info@techsolutions.com',
        'phone': '0987123456',
        'address': 'Av. Tecnológica 321',
        'type': 'RUC',
        'sriCode': '04',
      },
      {
        'customerId': '5',
        'identificationTypeId': '1',
        'identification': '1122334455',
        'firstName': 'Carlos',
        'lastName': 'Ramírez',
        'businessName': null,
        'email': 'carlos@example.com',
        'phone': '0998765432',
        'address': 'Barrio Central 555',
        'type': 'Cédula',
        'sriCode': '05',
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

    // Asegurar que hay datos inicializados
    if (_customers.isEmpty) {
      _initializeMockData();
    }

    // TODO: Implementar búsqueda en el servicio
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        // Filtrar clientes
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

  Future<void> _loadAllCustomers() async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _searchController.clear();
    });

    // Asegurar que hay datos inicializados
    if (_customers.isEmpty) {
      _initializeMockData();
    }

    // TODO: Implementar carga de todos los clientes desde el servicio
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _displayedCustomers = _customers.take(20).toList();
        _isLoading = false;
      });
    }
  }

  void _clearSearch() {
    setState(() {
      _displayedCustomers = [];
      _hasSearched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Campo de búsqueda
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: AppTheme.primaryButton, width: 1),
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, clave o código de barras',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon:
                    const Icon(Icons.search, color: AppTheme.primaryButton),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear,
                            color: AppTheme.primaryButton),
                        onPressed: () {
                          _searchController.clear();
                          _clearSearch();
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
              onChanged: (value) {
                setState(() {});
              },
              onSubmitted: (value) {
                if (value.trim().isNotEmpty) {
                  _searchCustomers();
                }
              },
            ),
          ),
          const SizedBox(height: 15),
          // Botones de acción
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_searchController.text.trim().isNotEmpty) {
                      _searchCustomers();
                    }
                  },
                  icon: const Icon(Icons.search),
                  label: const Text('Buscar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryButton,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _loadAllCustomers,
                  icon: const Icon(Icons.list),
                  label: const Text('Ver Últimos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryButton,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Pasar datos a la sección de lista
          _CustomerListContent(
            isLoading: _isLoading,
            hasSearched: _hasSearched,
            customers: _displayedCustomers,
            onRefresh: _loadAllCustomers,
          ),
        ],
      ),
    );
  }
}

///Sección de listado de clientes
class _CustomerListSection extends StatelessWidget {
  const _CustomerListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Este widget solo sirve como contenedor
    // El contenido real se maneja en _SearchSectionState
    return const SizedBox.shrink();
  }
}

///Contenido de la lista de clientes
class _CustomerListContent extends StatelessWidget {
  final bool isLoading;
  final bool hasSearched;
  final List<Map<String, dynamic>> customers;
  final VoidCallback onRefresh;

  const _CustomerListContent({
    Key? key,
    required this.isLoading,
    required this.hasSearched,
    required this.customers,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Estado inicial
    if (!hasSearched) {
      return const _EmptyStateWidget(
        icon: Icons.search,
        title: 'Buscar Clientes',
        message:
            'Usa el buscador para encontrar clientes\no visualiza los últimos clientes registrados',
      );
    }

    // Cargando
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(50),
        child: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryButton),
        ),
      );
    }

    // Sin resultados
    if (customers.isEmpty) {
      return const _EmptyStateWidget(
        icon: Icons.people_outline,
        title: 'Sin Resultados',
        message: 'No se encontraron clientes con ese criterio de búsqueda',
      );
    }

    // Lista de clientes
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Text(
            '${customers.length} cliente(s) encontrado(s)',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final customer = customers[index];
            return _CustomerCard(
              customer: customer,
              onTap: () => _showCustomerDetail(context, customer),
              onEdit: () =>
                  _navigateToEditCustomer(context, customer, onRefresh),
              onDelete: () =>
                  _confirmDeleteCustomer(context, customer, onRefresh),
            );
          },
        ),
      ],
    );
  }

  void _showCustomerDetail(
      BuildContext context, Map<String, dynamic> customer) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CustomerDetailSheet(customer: customer),
    );
  }

  Future<void> _navigateToEditCustomer(BuildContext context,
      Map<String, dynamic> customer, VoidCallback onRefresh) async {
    // Crear modelo temporal del cliente
    final customerModel = CustomerModel(
      customerId: customer['customerId'],
      identificationTypeId: customer['identificationTypeId'],
      identificationType: IdentificationTypeModel(
        identificationTypeId: customer['identificationTypeId'],
        name: customer['type'],
        description: customer['type'],
        inicials: customer['type'] == 'RUC'
            ? 'RUC'
            : customer['type'] == 'Cédula'
                ? 'CED'
                : 'PAS',
        sriCode: customer['sriCode'],
        length: customer['identification'].length,
        status: 'A',
      ),
      identification: customer['identification'],
      firstName: customer['firstName'],
      lastName: customer['lastName'],
      businessName: customer['businessName'],
      email: customer['email'],
      phoneNumber: customer['phone'],
      address: customer['address'],
      status: 'A',
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CustomerWizardScreen(customerToEdit: customerModel),
      ),
    );

    if (result == true && context.mounted) {
      onRefresh(); // Recargar la lista
    }
  }

  Future<void> _confirmDeleteCustomer(BuildContext context,
      Map<String, dynamic> customer, VoidCallback onRefresh) async {
    final displayName = customer['businessName'] ??
        '${customer['firstName'] ?? ''} ${customer['lastName'] ?? ''}'.trim();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar Cliente'),
        content: Text('¿Está seguro que desea eliminar a $displayName?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      // TODO: Implementar eliminación en el servicio
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cliente eliminado exitosamente'),
          backgroundColor: Colors.green,
        ),
      );
      onRefresh();
    }
  }
}

///Widget para estado vacío
class _EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const _EmptyStateWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(icon, size: 80, color: AppTheme.primaryButton.withOpacity(0.5)),
          const SizedBox(height: 20),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            message,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

///Bottom sheet con detalles del cliente
class _CustomerDetailSheet extends StatelessWidget {
  final Map<String, dynamic> customer;

  const _CustomerDetailSheet({Key? key, required this.customer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String displayName = customer['businessName'] ??
        '${customer['firstName'] ?? ''} ${customer['lastName'] ?? ''}'.trim();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _DetailRow(
            icon: Icons.badge,
            label: 'Tipo de identificación',
            value: customer['type'] ?? 'N/A',
          ),
          _DetailRow(
            icon: Icons.credit_card,
            label: 'Clave de búsqueda',
            value: customer['identification'] ?? 'N/A',
          ),
          if (customer['email'] != null &&
              customer['email'].toString().isNotEmpty)
            _DetailRow(
              icon: Icons.email,
              label: 'Correo electrónico',
              value: customer['email'],
            ),
          if (customer['phone'] != null &&
              customer['phone'].toString().isNotEmpty)
            _DetailRow(
              icon: Icons.phone,
              label: 'Teléfono',
              value: customer['phone'],
            ),
          if (customer['address'] != null &&
              customer['address'].toString().isNotEmpty)
            _DetailRow(
              icon: Icons.location_on,
              label: 'Dirección',
              value: customer['address'],
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

///Fila de detalle
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    Key? key,
    required this.icon,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryButton, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
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

///Widget para mostrar cada cliente en una tarjeta
class _CustomerCard extends StatelessWidget {
  final Map<String, dynamic> customer;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CustomerCard({
    Key? key,
    required this.customer,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determinar el nombre a mostrar
    final String displayName = customer['businessName'] ??
        '${customer['firstName'] ?? ''} ${customer['lastName'] ?? ''}'.trim();

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppTheme.secondary.withOpacity(0.8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Ícono del cliente
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryButton.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppTheme.primaryButton,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),

              // Información del cliente
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Clave: ${customer['identification']}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                    if (customer['email'] != null &&
                        customer['email'].toString().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.email_outlined,
                            size: 12,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              customer['email'],
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (customer['phone'] != null &&
                        customer['phone'].toString().isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.phone_outlined,
                            size: 12,
                            color: Colors.white.withOpacity(0.5),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            customer['phone'],
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Botones de acción
              Column(
                children: [
                  IconButton(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Editar',
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete, color: Colors.red, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Eliminar',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
