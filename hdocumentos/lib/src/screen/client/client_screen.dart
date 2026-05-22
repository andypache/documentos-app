import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/screen/customer/customer_wizard_screen.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for render client application
class ClientScreen extends StatelessWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BrackgroundWidget(),
          Column(
            children: [
              const Expanded(child: _ClientScreenBody()),
              _BottomActionBar(
                onNewCustomer: () => _navigateToCreateCustomer(context),
                onCancel: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToCreateCustomer(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CustomerWizardScreen()),
    );

    if (result == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).customerCreatedSuccess,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppTheme.actionSave,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      );
    }
  }
}

/// Barra inferior con botón Cancelar y Nuevo Cliente
class _BottomActionBar extends StatelessWidget {
  final VoidCallback onNewCustomer;
  final VoidCallback onCancel;

  const _BottomActionBar({
    Key? key,
    required this.onNewCustomer,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final hPad = isLandscape ? 16.0 : MediaQuery.of(context).size.width * 0.05;
    final vPad = isLandscape ? 6.0 : 12.0;
    final iconSize = isLandscape ? 18.0 : 22.0;
    final fontSize = isLandscape ? 13.0 : 14.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: onCancel,
            icon: Icon(Icons.close_rounded, size: iconSize),
            label: Text(l10n.btnCancel, style: TextStyle(fontSize: fontSize)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.actionDanger,
              foregroundColor: Colors.white,
              elevation: 0,
              padding:
                  EdgeInsets.symmetric(horizontal: hPad, vertical: vPad + 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
          ElevatedButton.icon(
            onPressed: onNewCustomer,
            icon: Icon(Icons.person_add_rounded, size: iconSize),
            label: Text(l10n.customerCreateTitle,
                style: TextStyle(fontSize: fontSize)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryButton,
              foregroundColor: AppTheme.secondary,
              elevation: 0,
              padding:
                  EdgeInsets.symmetric(horizontal: hPad, vertical: vPad + 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }
}

///Body for bill into sroll view
class _ClientScreenBody extends StatefulWidget {
  const _ClientScreenBody({Key? key}) : super(key: key);

  @override
  State<_ClientScreenBody> createState() => _ClientScreenBodyState();
}

class _ClientScreenBodyState extends State<_ClientScreenBody> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allCustomers = [];
  List<Map<String, dynamic>> _displayedCustomers = [];
  bool _isLoading = false;
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _initializeMockData() {
    _allCustomers = [
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
    if (query.isEmpty) return;
    if (_allCustomers.isEmpty) _initializeMockData();

    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      final queryLower = query.toLowerCase();
      setState(() {
        _displayedCustomers = _allCustomers.where((c) {
          final name =
              '${c['firstName'] ?? ''} ${c['lastName'] ?? ''} ${c['businessName'] ?? ''}'
                  .toLowerCase();
          final id = (c['identification'] ?? '').toLowerCase();
          return name.contains(queryLower) || id.contains(queryLower);
        }).toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadAllCustomers() async {
    if (_allCustomers.isEmpty) _initializeMockData();
    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _searchController.clear();
    });

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _displayedCustomers = _allCustomers.take(20).toList();
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
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final searchWidget = _SearchSection(
      controller: _searchController,
      onSearch: _searchCustomers,
      onLoadAll: _loadAllCustomers,
      onClear: _clearSearch,
    );

    final resultWidget = _CustomerResultSection(
      isLoading: _isLoading,
      hasSearched: _hasSearched,
      customers: _displayedCustomers,
      onRefresh: _loadAllCustomers,
    );

    if (isLandscape) {
      return Row(
        children: [
          SizedBox(
            width: 300,
            child: Column(
              children: [
                const SizedBox(height: 8),
                searchWidget,
                const SizedBox(height: 8),
              ],
            ),
          ),
          const VerticalDivider(width: 1, color: Colors.white12, thickness: 1),
          Expanded(child: resultWidget),
        ],
      );
    }

    // Portrait
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        const UserSessionTitle(),
        Container(
          padding: EdgeInsets.only(
            left: size.width * 0.05,
            right: size.width * 0.05,
          ),
          child: Row(
            children: [
              Expanded(
                child: Builder(
                  builder: (ctx) => PageTitleWidget(
                      title: AppLocalizations.of(ctx).pageClientsTitle),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 16),
                searchWidget,
                const SizedBox(height: 20),
                resultWidget,
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

///Sección de búsqueda (sin estado propio — estado en _ClientScreenBodyState)
class _SearchSection extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onLoadAll;
  final VoidCallback onClear;

  const _SearchSection({
    Key? key,
    required this.controller,
    required this.onSearch,
    required this.onLoadAll,
    required this.onClear,
  }) : super(key: key);

  @override
  State<_SearchSection> createState() => _SearchSectionState();
}

class _SearchSectionState extends State<_SearchSection> {
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final size = MediaQuery.of(context).size;
    final hPad = isLandscape ? 12.0 : size.width * 0.05;
    final fontSize = isLandscape ? 13.0 : size.width * 0.035;
    final btnVPad = isLandscape ? 10.0 : 14.0;

    final searchField = Container(
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryButton, width: 1),
      ),
      child: TextField(
        controller: widget.controller,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).searchCustomersHint,
          hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5), fontSize: fontSize),
          prefixIcon:
              Icon(Icons.search, color: AppTheme.primaryButton, size: 20),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear,
                      color: AppTheme.primaryButton, size: 18),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onClear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          isDense: isLandscape,
        ),
        onChanged: (_) => setState(() {}),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) widget.onSearch();
        },
      ),
    );

    final btnSearch = ElevatedButton.icon(
      onPressed: () {
        if (widget.controller.text.trim().isNotEmpty) widget.onSearch();
      },
      icon: const Icon(Icons.search, size: 18),
      label: Text(AppLocalizations.of(context).btnSearch,
          style: TextStyle(fontSize: fontSize)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryButton,
        foregroundColor: AppTheme.secondary,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: btnVPad, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    final btnAll = ElevatedButton.icon(
      onPressed: widget.onLoadAll,
      icon: const Icon(Icons.list, size: 18),
      label: Text(AppLocalizations.of(context).btnLoadLast,
          style: TextStyle(fontSize: fontSize)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.secondaryButton,
        foregroundColor: AppTheme.secondary,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: btnVPad, horizontal: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );

    if (isLandscape) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            searchField,
            const SizedBox(height: 8),
            btnSearch,
            const SizedBox(height: 6),
            btnAll,
          ],
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        children: [
          searchField,
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: btnSearch),
              const SizedBox(width: 12),
              Expanded(child: btnAll),
            ],
          ),
        ],
      ),
    );
  }
}

///Contenido de la lista de clientes
class _CustomerResultSection extends StatelessWidget {
  final bool isLoading;
  final bool hasSearched;
  final List<Map<String, dynamic>> customers;
  final VoidCallback onRefresh;

  const _CustomerResultSection({
    Key? key,
    required this.isLoading,
    required this.hasSearched,
    required this.customers,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Estado inicial
    if (!hasSearched) {
      return Builder(
        builder: (ctx) => _EmptyStateWidget(
          icon: Icons.search_rounded,
          title: AppLocalizations.of(ctx).searchCustomersTitle,
          message: AppLocalizations.of(ctx).searchCustomersMsg,
        ),
      );
    }

    // Cargando
    if (isLoading) {
      return const ContentLoadingWidget();
    }

    // Sin resultados
    if (customers.isEmpty) {
      return Builder(
        builder: (ctx) => _EmptyStateWidget(
          icon: Icons.people_outline_rounded,
          title: AppLocalizations.of(ctx).noCustomersFound,
          message: AppLocalizations.of(ctx).noCustomersFoundMsg,
        ),
      );
    }

    // Lista de clientes
    final hPad = isLandscape ? 16.0 : size.width * 0.05;
    final listView = ListView.builder(
      shrinkWrap: !isLandscape,
      physics: isLandscape
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: hPad),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return _CustomerCard(
          customer: customer,
          onTap: () => _showCustomerDetail(context, customer),
          onEdit: () => _navigateToEditCustomer(context, customer, onRefresh),
          onDelete: () => _confirmDeleteCustomer(context, customer, onRefresh),
        );
      },
    );

    if (isLandscape) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(hPad, 10, hPad, 6),
            child: Text(
              AppLocalizations.of(context).customersFound(customers.length),
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
          Expanded(child: listView),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: hPad),
          child: Text(
            AppLocalizations.of(context).customersFound(customers.length),
            style:
                TextStyle(color: Colors.white70, fontSize: size.width * 0.032),
          ),
        ),
        const SizedBox(height: 10),
        listView,
      ],
    );
  }

  void _showCustomerDetail(
      BuildContext context, Map<String, dynamic> customer) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.dialogBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppTheme.dialogBorder, width: 1),
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
      builder: (ctx) => Dialog(
        backgroundColor: AppTheme.dialogBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.dialogBorder, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.actionDelete.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_remove_rounded,
                  color: AppTheme.actionDelete,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(ctx).deleteCustomerTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(ctx).deleteCustomerConfirm(displayName),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 13.5,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.textSecondary,
                        side: const BorderSide(color: AppTheme.dialogBorder),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                      child: Text(AppLocalizations.of(ctx).btnCancel),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Navigator.pop(ctx, true),
                      icon: const Icon(Icons.person_remove_rounded, size: 18),
                      label: Text(AppLocalizations.of(ctx).btnDelete),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.actionDelete,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(vertical: 13),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    if (confirmed == true && context.mounted) {
      // TODO: Implementar eliminación en el servicio
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).customerDeletedSuccess,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppTheme.actionSave,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Padding(
      padding: EdgeInsets.all(isLandscape ? 16 : 32),
      child: Column(
        children: [
          Icon(icon,
              size: isLandscape ? 40.0 : size.width * 0.18,
              color: AppTheme.primaryButton.withOpacity(0.5)),
          SizedBox(height: isLandscape ? 8 : 20),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isLandscape ? 14.0 : size.width * 0.048,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isLandscape ? 4 : 10),
          Text(
            message,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: isLandscape ? 11.0 : size.width * 0.035,
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
    final size = MediaQuery.of(context).size;
    final String displayName = customer['businessName'] ??
        '${customer['firstName'] ?? ''} ${customer['lastName'] ?? ''}'.trim();

    return Padding(
      padding: EdgeInsets.all(size.width * 0.05),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: size.width * 0.1,
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
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.052,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 14),
          _DetailRow(
            icon: Icons.badge_rounded,
            label: AppLocalizations.of(context).labelIdentificationType,
            value: customer['type'] ?? 'N/A',
          ),
          _DetailRow(
            icon: Icons.credit_card_rounded,
            label: AppLocalizations.of(context).labelIdentification,
            value: customer['identification'] ?? 'N/A',
          ),
          if (customer['email'] != null &&
              customer['email'].toString().isNotEmpty)
            _DetailRow(
              icon: Icons.email_rounded,
              label: AppLocalizations.of(context).labelEmailAddress,
              value: customer['email'],
            ),
          if (customer['phone'] != null &&
              customer['phone'].toString().isNotEmpty)
            _DetailRow(
              icon: Icons.phone_rounded,
              label: AppLocalizations.of(context).labelPhoneNumber,
              value: customer['phone'],
            ),
          if (customer['address'] != null &&
              customer['address'].toString().isNotEmpty)
            _DetailRow(
              icon: Icons.location_on_rounded,
              label: AppLocalizations.of(context).labelAddress,
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
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryButton, size: size.width * 0.048),
          SizedBox(width: size.width * 0.025),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: size.width * 0.03,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size.width * 0.038,
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
                    icon: const Icon(Icons.edit_rounded,
                        color: AppTheme.primaryButton, size: 20),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Editar',
                  ),
                  const SizedBox(height: 8),
                  IconButton(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_rounded,
                        color: AppTheme.actionDelete, size: 20),
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
