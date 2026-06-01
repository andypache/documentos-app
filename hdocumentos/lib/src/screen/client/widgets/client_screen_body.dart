import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/screen/client/widgets/widgets.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

/// Body principal del screen de clientes con búsqueda y resultados
class ClientScreenBody extends StatefulWidget {
  const ClientScreenBody({Key? key}) : super(key: key);

  @override
  State<ClientScreenBody> createState() => _ClientScreenBodyState();
}

class _ClientScreenBodyState extends State<ClientScreenBody> {
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

    final searchWidget = CustomerSearchSection(
      controller: _searchController,
      onSearch: _searchCustomers,
      onLoadAll: _loadAllCustomers,
      onClear: _clearSearch,
    );

    final resultWidget = CustomerResultSection(
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
                SizedBox(height: AppDimens.spaceS),
                searchWidget,
                SizedBox(height: AppDimens.spaceS),
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
                    title: AppLocalizations.of(ctx).pageClientsTitle,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: AppDimens.paddingM),
                searchWidget,
                SizedBox(height: AppDimens.spaceL),
                resultWidget,
                SizedBox(height: AppDimens.spaceL),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
