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
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        // Widget de información del usuario
        const UserSessionTitle(),
        // Header con título y botón de cerrar
        Container(
          padding: EdgeInsets.only(
            top: 0,
            left: size.width * 0.05,
            right: size.width * 0.05,
            bottom: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: PageTitleWidget(title: 'Productos'),
              ),
              IconButton(
                icon: Icon(Icons.close,
                    color: Colors.white, size: size.width * 0.07),
                onPressed: () => Navigator.pop(context),
                tooltip: 'Cerrar',
              ),
            ],
          ),
        ),
        // Resto del contenido
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.02),
                const _SearchSection(),
                SizedBox(height: size.height * 0.025),
                const _ItemListSection(),
                SizedBox(height: size.height * 0.1), // Espacio para el FAB
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
    final size = MediaQuery.of(context).size;
    final horizontalPadding = size.width * 0.05;
    final fontSize = size.width * 0.035;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
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
              style: TextStyle(color: Colors.white, fontSize: fontSize),
              decoration: InputDecoration(
                hintText: 'Buscar por nombre, clave o código de barras',
                hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.5), fontSize: fontSize),
                prefixIcon: Icon(Icons.search,
                    color: AppTheme.primaryButton, size: size.width * 0.06),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear,
                            color: AppTheme.primaryButton,
                            size: size.width * 0.06),
                        onPressed: () {
                          _searchController.clear();
                          provider.clearSearch();
                          setState(() {});
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.05,
                  vertical: size.height * 0.018,
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
          SizedBox(height: size.height * 0.018),
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
                  icon: Icon(Icons.search, size: size.width * 0.045),
                  label: Text('Buscar', style: TextStyle(fontSize: fontSize)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryButton,
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.018),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.025),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => provider.loadAllItems(),
                  icon: Icon(Icons.list, size: size.width * 0.045),
                  label:
                      Text('Ver Todos', style: TextStyle(fontSize: fontSize)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryButton,
                    padding:
                        EdgeInsets.symmetric(vertical: size.height * 0.018),
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

    final size = MediaQuery.of(context).size;

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
      return const ContentLoadingWidget();
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
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Text(
            '${provider.items.length} producto(s) encontrado(s)',
            style: TextStyle(
              color: Colors.white70,
              fontSize: size.width * 0.032,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.012),
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
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.all(size.height * 0.05),
      child: Column(
        children: [
          Icon(icon,
              size: size.width * 0.18,
              color: AppTheme.primaryButton.withOpacity(0.5)),
          SizedBox(height: size.height * 0.025),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.048,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: size.height * 0.012),
          Text(
            message,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: size.width * 0.035,
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
    final size = MediaQuery.of(context).size;

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
          SizedBox(height: size.height * 0.025),
          Text(
            item.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: size.width * 0.052,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: size.height * 0.018),
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
          SizedBox(height: size.height * 0.025),
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
      padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
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
