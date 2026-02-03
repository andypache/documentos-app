import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/item_list_provider.dart';
import 'package:hdocumentos/src/screen/item/item_wizard_screen.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/item/item_card_widget.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

///Pantalla principal de gestión de productos
class ItemScreen extends StatelessWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ItemListProvider(),
      child: const _ItemScreenContent(),
    );
  }
}

///Contenido principal con Scaffold
class _ItemScreenContent extends StatelessWidget {
  const _ItemScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Stack(
        children: [
          BrackgroundWidget(),
          _ItemScreenBody(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _navigateToCreateItem(context),
        backgroundColor: AppTheme.primaryButton,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Producto'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<void> _navigateToCreateItem(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ItemWizardScreen()),
    );

    // Si se guardó un item, recargar la lista
    if (result == true && context.mounted) {
      final provider = Provider.of<ItemListProvider>(context, listen: false);
      if (provider.hasSearched) {
        provider.loadAllItems();
      }
    }
  }
}

///Cuerpo principal de la pantalla
class _ItemScreenBody extends StatelessWidget {
  const _ItemScreenBody({Key? key}) : super(key: key);

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
                child: PageTitleWidget(title: 'Productos'),
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
                _ItemListSection(),
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemListProvider>(context, listen: false);

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
                          provider.clearSearch();
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
                  provider.searchItems(value.trim());
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
                      provider.searchItems(_searchController.text.trim());
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
                  onPressed: () => provider.loadAllItems(),
                  icon: const Icon(Icons.list),
                  label: const Text('Ver Todos'),
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
        ],
      ),
    );
  }
}

///Sección de listado de items
class _ItemListSection extends StatelessWidget {
  const _ItemListSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemListProvider>(context);

    // Estado inicial
    if (!provider.hasSearched) {
      return const _EmptyStateWidget(
        icon: Icons.search,
        title: 'Buscar Productos',
        message:
            'Usa el buscador para encontrar productos\no visualiza todos los productos disponibles',
      );
    }

    // Cargando
    if (provider.isLoading) {
      return const Padding(
        padding: EdgeInsets.all(50),
        child: Center(
          child: CircularProgressIndicator(color: AppTheme.primaryButton),
        ),
      );
    }

    // Sin resultados
    if (!provider.hasResults) {
      return const _EmptyStateWidget(
        icon: Icons.inventory_2_outlined,
        title: 'Sin Resultados',
        message: 'No se encontraron productos con ese criterio de búsqueda',
      );
    }

    // Lista de items
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            '${provider.items.length} producto(s) encontrado(s)',
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
          itemCount: provider.items.length,
          itemBuilder: (context, index) {
            final item = provider.items[index];
            return ItemCardWidget(
              item: item,
              onTap: () => _showItemDetail(context, item),
              onEdit: () => _navigateToEditItem(context, item),
              onDelete: () => _confirmDelete(context, provider, item),
            );
          },
        ),
      ],
    );
  }

  void _showItemDetail(BuildContext context, ItemModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.primary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ItemDetailSheet(item: item),
    );
  }

  Future<void> _navigateToEditItem(BuildContext context, ItemModel item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemWizardScreen(itemToEdit: item),
      ),
    );

    // Si se guardó el item, recargar la lista
    if (result == true && context.mounted) {
      final provider = Provider.of<ItemListProvider>(context, listen: false);
      if (provider.hasSearched) {
        provider.loadAllItems();
      }
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, ItemListProvider provider, ItemModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Eliminación'),
        content: Text('¿Está seguro de eliminar el producto "${item.name}"?'),
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
      final success = await provider.deleteItem(item.itemId!);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Producto eliminado exitosamente'
                  : 'Error al eliminar el producto',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
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

///Bottom sheet con detalles del item
class _ItemDetailSheet extends StatelessWidget {
  final ItemModel item;

  const _ItemDetailSheet({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            item.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 15),
          _DetailRow(
            icon: Icons.label,
            label: 'Clave de búsqueda',
            value: item.searchKey ?? 'N/A',
          ),
          _DetailRow(
            icon: Icons.description,
            label: 'Descripción',
            value: item.description ?? 'Sin descripción',
          ),
          _DetailRow(
            icon: Icons.attach_money,
            label: 'Precio',
            value: '\$${item.price?.toStringAsFixed(2) ?? "0.00"}',
          ),
          _DetailRow(
            icon: Icons.money_off,
            label: 'Costo',
            value: '\$${item.cost?.toStringAsFixed(2) ?? "0.00"}',
          ),
          if (item.isService == 'N')
            _DetailRow(
              icon: Icons.inventory,
              label: 'Stock',
              value: '${item.stock ?? 0} unidades',
            ),
          if (item.barCode != null && item.barCode!.isNotEmpty)
            _DetailRow(
              icon: Icons.qr_code,
              label: 'Código de barras',
              value: item.barCode!,
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
