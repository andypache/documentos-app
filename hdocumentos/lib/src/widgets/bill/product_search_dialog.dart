import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Diálogo para buscar y seleccionar productos
class ProductSearchDialog extends StatefulWidget {
  const ProductSearchDialog({Key? key}) : super(key: key);

  @override
  State<ProductSearchDialog> createState() => _ProductSearchDialogState();
}

class _ProductSearchDialogState extends State<ProductSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  List<ItemModel> _items = [];
  List<ItemModel> _displayedItems = [];
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
    // Datos de ejemplo con impuestos
    _items = [
      ItemModel(
        itemId: '1',
        name: 'Laptop Dell Inspiron 15',
        description: 'Laptop con procesador Intel i5, 8GB RAM',
        searchKey: 'LAPTOP',
        barCode: '7891234567890',
        price: 850.00,
        cost: 650.00,
        discount: 0,
        stock: 10,
        isService: 'N',
        state: 'A',
        itemTaxList: [
          ItemTaxModel(
            iteTaxId: '1',
            companySystemParameter: CompanySystemParameterModel(
              companySystemParameterId: '1',
              numberParameter: 12.0,
              isTaxSale: 'Y',
              systemParameter: SystemParameterModel(
                systemParameterId: '1',
                name: 'IVA',
              ),
            ),
          ),
        ],
      ),
      ItemModel(
        itemId: '2',
        name: 'Mouse Logitech MX Master 3',
        description: 'Mouse inalámbrico ergonómico',
        searchKey: 'MOUSE',
        barCode: '7891234567891',
        price: 95.00,
        cost: 70.00,
        discount: 0,
        stock: 25,
        isService: 'N',
        state: 'A',
        itemTaxList: [
          ItemTaxModel(
            iteTaxId: '1',
            companySystemParameter: CompanySystemParameterModel(
              companySystemParameterId: '1',
              numberParameter: 12.0,
              isTaxSale: 'Y',
              systemParameter: SystemParameterModel(
                systemParameterId: '1',
                name: 'IVA',
              ),
            ),
          ),
        ],
      ),
      ItemModel(
        itemId: '3',
        name: 'Servicio de Consultoría IT',
        description: 'Asesoría técnica y consultoría',
        searchKey: 'CONSULTORIA',
        price: 150.00,
        cost: 0.0,
        discount: 0,
        stock: 0,
        isService: 'Y',
        state: 'A',
        itemTaxList: [
          ItemTaxModel(
            iteTaxId: '1',
            companySystemParameter: CompanySystemParameterModel(
              companySystemParameterId: '1',
              numberParameter: 12.0,
              isTaxSale: 'Y',
              systemParameter: SystemParameterModel(
                systemParameterId: '1',
                name: 'IVA',
              ),
            ),
          ),
        ],
      ),
      ItemModel(
        itemId: '4',
        name: 'Teclado Mecánico Keychron K2',
        description: 'Teclado mecánico inalámbrico RGB',
        searchKey: 'TECLADO',
        barCode: '7891234567892',
        price: 120.00,
        cost: 85.00,
        discount: 0,
        stock: 15,
        isService: 'N',
        state: 'A',
        itemTaxList: [
          ItemTaxModel(
            iteTaxId: '1',
            companySystemParameter: CompanySystemParameterModel(
              companySystemParameterId: '1',
              numberParameter: 12.0,
              isTaxSale: 'Y',
              systemParameter: SystemParameterModel(
                systemParameterId: '1',
                name: 'IVA',
              ),
            ),
          ),
        ],
      ),
      ItemModel(
        itemId: '5',
        name: 'Monitor LG UltraWide 29"',
        description: 'Monitor IPS 2560x1080',
        searchKey: 'MONITOR',
        barCode: '7891234567893',
        price: 350.00,
        cost: 280.00,
        discount: 0,
        stock: 8,
        isService: 'N',
        state: 'A',
        itemTaxList: [
          ItemTaxModel(
            iteTaxId: '1',
            companySystemParameter: CompanySystemParameterModel(
              companySystemParameterId: '1',
              numberParameter: 12.0,
              isTaxSale: 'Y',
              systemParameter: SystemParameterModel(
                systemParameterId: '1',
                name: 'IVA',
              ),
            ),
          ),
        ],
      ),
    ];
  }

  Future<void> _searchItems() async {
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
        _displayedItems = _items.where((item) {
          final nameLower = item.name.toLowerCase();
          final searchKeyLower = (item.searchKey ?? '').toLowerCase();
          final barCode = item.barCode ?? '';
          return nameLower.contains(queryLower) ||
              searchKeyLower.contains(queryLower) ||
              barCode.contains(queryLower);
        }).toList();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadAllItems() async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    // TODO: Implementar carga de todos los items
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      setState(() {
        _displayedItems = _items.take(20).toList();
        _isLoading = false;
      });
    }
  }

  void _selectItem(ItemModel item) {
    Navigator.pop(context, item);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppTheme.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 650, maxWidth: 500),
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
                  const Icon(Icons.search, color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Buscar Producto',
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
                          hintText: 'Nombre, código o barras',
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
                                      _displayedItems = [];
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
                            _searchItems();
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
                          ? _searchItems
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
                      onPressed: _loadAllItems,
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
            Icon(Icons.inventory_2_outlined,
                size: 64, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'Busca productos por nombre,\ncódigo o código de barras',
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

    if (_displayedItems.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory,
                size: 64, color: Colors.white.withOpacity(0.3)),
            const SizedBox(height: 16),
            Text(
              'No se encontraron productos',
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
      itemCount: _displayedItems.length,
      itemBuilder: (context, index) {
        final item = _displayedItems[index];
        return _buildItemCard(item);
      },
    );
  }

  Widget _buildItemCard(ItemModel item) {
    final hasTaxes = item.itemTaxList != null && item.itemTaxList!.isNotEmpty;
    final isService = item.isService == 'Y';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: AppTheme.secondary.withOpacity(0.5),
      child: InkWell(
        onTap: () => _selectItem(item),
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryButton.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  isService ? Icons.design_services : Icons.inventory_2,
                  color: AppTheme.primaryButton,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${item.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isService) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Stock: ${item.stock ?? 0}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                    if (hasTaxes) ...[
                      const SizedBox(height: 4),
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: item.itemTaxList!.map((tax) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.blue, width: 1),
                            ),
                            child: Text(
                              '${tax.name} ${tax.percentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: Colors.lightBlueAccent,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(
                Icons.add_circle,
                color: AppTheme.primaryButton,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
