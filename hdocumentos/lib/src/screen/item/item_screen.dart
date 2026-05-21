import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/item_list_provider.dart';
import 'package:hdocumentos/src/screen/item/item_price_screen.dart';
import 'package:hdocumentos/src/screen/item/item_stock_screen.dart';
import 'package:hdocumentos/src/screen/item/item_wizard_screen.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/item/item_card_widget.dart';
import 'package:hdocumentos/src/service/service.dart';
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
      body: Stack(
        children: [
          const BrackgroundWidget(),
          Column(
            children: [
              const Expanded(child: _ItemScreenBody()),
              _BottomActionBar(
                onNewProduct: () => _navigateToCreateItem(context),
                onCancel: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
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
      if (provider.hasStarted) {
        provider.startLoadAll(context);
      }
    }
  }
}

///Barra inferior con botón Cancelar y Nuevo Producto
class _BottomActionBar extends StatelessWidget {
  final VoidCallback onNewProduct;
  final VoidCallback onCancel;

  const _BottomActionBar({
    Key? key,
    required this.onNewProduct,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: size.width * 0.05,
        vertical: size.height * 0.015,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cancelar
          ElevatedButton.icon(
            onPressed: onCancel,
            icon: Icon(Icons.close_rounded, size: size.width * 0.045),
            label: Text(
              l10n.btnCancel,
              style: TextStyle(fontSize: size.width * 0.034),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.actionDanger,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.012,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          // Nuevo Producto
          ElevatedButton.icon(
            onPressed: onNewProduct,
            icon: Icon(Icons.add_rounded, size: size.width * 0.045),
            label: Text(
              l10n.btnNewProduct,
              style: TextStyle(fontSize: size.width * 0.034),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryButton,
              foregroundColor: AppTheme.secondary,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.05,
                vertical: size.height * 0.012,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
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
        // Header con título
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: const PageTitleWidget(title: ''),
        ),
        SizedBox(height: size.height * 0.02),
        // Sección de búsqueda (fija arriba)
        const _SearchSection(),
        SizedBox(height: size.height * 0.025),
        // Lista con scroll infinito (ocupa el espacio restante)
        const Expanded(child: _ItemListSection()),
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
                hintText: AppLocalizations.of(context).searchItemsHint,
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
                  provider.startLoadFilter(context, value.trim());
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
                      provider.startLoadFilter(
                          context, _searchController.text.trim());
                    }
                  },
                  icon: Icon(Icons.search, size: size.width * 0.045),
                  label: Text(AppLocalizations.of(context).btnSearch,
                      style: TextStyle(fontSize: fontSize)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryButton,
                    foregroundColor: AppTheme.secondary,
                    elevation: 0,
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
                  onPressed: () => provider.startLoadAll(context),
                  icon: Icon(Icons.list, size: size.width * 0.045),
                  label: Text(AppLocalizations.of(context).btnLoadAll,
                      style: TextStyle(fontSize: fontSize)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.secondaryButton,
                    foregroundColor: AppTheme.secondary,
                    elevation: 0,
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

///Sección de listado de items con paginación infinita
class _ItemListSection extends StatefulWidget {
  const _ItemListSection({Key? key}) : super(key: key);

  @override
  State<_ItemListSection> createState() => _ItemListSectionState();
}

class _ItemListSectionState extends State<_ItemListSection> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 100) {
      final provider = Provider.of<ItemListProvider>(context, listen: false);
      provider.loadNextPage(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemListProvider>(context);
    final size = MediaQuery.of(context).size;

    // Estado inicial (nada cargado aún)
    if (!provider.hasStarted) {
      return Builder(
        builder: (ctx) => _EmptyStateWidget(
          icon: Icons.search_rounded,
          title: AppLocalizations.of(ctx).searchItemsTitle,
          message: AppLocalizations.of(ctx).searchItemsMsg,
        ),
      );
    }

    // Cargando primera página
    if (provider.isLoading) {
      return const ContentLoadingWidget();
    }

    // Error de carga
    if (provider.errorMessage != null && !provider.hasResults) {
      return Builder(
        builder: (ctx) => _EmptyStateWidget(
          icon: Icons.wifi_off_rounded,
          title: 'Error al cargar',
          message: provider.errorMessage!,
        ),
      );
    }

    // Sin resultados
    if (!provider.hasResults) {
      return Builder(
        builder: (ctx) => _EmptyStateWidget(
          icon: Icons.inventory_2_outlined,
          title: AppLocalizations.of(ctx).noItemsFound,
          message: AppLocalizations.of(ctx).noItemsFoundMsg,
        ),
      );
    }

    // Lista con paginación infinita
    final items = provider.items;
    final itemCount = items.length +
        (provider.hasReachedEnd ? 0 : (provider.isLoadingMore ? 1 : 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: Text(
            AppLocalizations.of(context).itemsFound(items.length),
            style: TextStyle(
              color: Colors.white70,
              fontSize: size.width * 0.032,
            ),
          ),
        ),
        SizedBox(height: size.height * 0.012),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              // Spinner de carga de página siguiente
              if (index == items.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primaryButton,
                      ),
                    ),
                  ),
                );
              }
              final item = items[index];
              return ItemCardWidget(
                item: item,
                onTap: () => _showItemDetail(context, item),
                onEdit: () => _navigateToEditItem(context, item),
                onPriceChange: () => _navigateToPriceChange(context, item),
                onDelete: () => _confirmDelete(context, provider, item),
                onStockChange: item.isService == 'N'
                    ? () => _navigateToStockChange(context, item)
                    : null,
              );
            },
          ),
        ),
      ],
    );
  }

  void _showItemDetail(BuildContext context, ItemModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.dialogBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppTheme.dialogBorder, width: 1),
      ),
      builder: (context) => _ItemDetailSheet(item: item),
    );
  }

  Future<void> _navigateToPriceChange(
      BuildContext context, ItemModel item) async {
    final provider = Provider.of<ItemListProvider>(context, listen: false);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: provider,
          child: ItemPriceScreen(item: item),
        ),
      ),
    );

    if (result == true && context.mounted) {
      if (provider.hasStarted) {
        provider.startLoadAll(context);
      }
    }
  }

  Future<void> _navigateToStockChange(
      BuildContext context, ItemModel item) async {
    final provider = Provider.of<ItemListProvider>(context, listen: false);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: provider,
          child: ItemStockScreen(item: item),
        ),
      ),
    );

    // Si se guardó el stock, recargar la lista
    if (result == true && context.mounted) {
      if (provider.hasStarted) {
        provider.startLoadAll(context);
      }
    }
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
      if (provider.hasStarted) {
        provider.startLoadAll(context);
      }
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, ItemListProvider provider, ItemModel item) async {
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
                  Icons.delete_outline_rounded,
                  color: AppTheme.actionDelete,
                  size: 32,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                AppLocalizations.of(ctx).deleteItemTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppLocalizations.of(ctx).deleteItemConfirm(item.name),
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
                      icon: const Icon(Icons.delete_rounded, size: 18),
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
      final l10n = AppLocalizations.of(context);
      final success = await provider.deleteItem(item.id!, context);
      if (success) {
        NotificationService.showSuccess(l10n.itemDeletedSuccess);
      } else {
        NotificationService.showError(l10n.itemDeletedError);
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
            icon: Icons.label_rounded,
            label: AppLocalizations.of(context).labelSearchKey,
            value: item.searchKey ?? 'N/A',
          ),
          _DetailRow(
            icon: Icons.description_rounded,
            label: AppLocalizations.of(context).labelDescription,
            value:
                item.description ?? AppLocalizations.of(context).noDescription,
          ),
          _DetailRow(
            icon: Icons.attach_money_rounded,
            label: AppLocalizations.of(context).labelPrice,
            value: '\$${item.pricing?.price?.toStringAsFixed(2) ?? "0.00"}',
          ),
          _DetailRow(
            icon: Icons.money_off_rounded,
            label: AppLocalizations.of(context).labelCost,
            value: '\$${item.pricing?.cost?.toStringAsFixed(2) ?? "0.00"}',
          ),
          if (item.isService == 'N')
            _DetailRow(
              icon: Icons.inventory_rounded,
              label: AppLocalizations.of(context).labelStock,
              value: AppLocalizations.of(context)
                  .labelStockUnits(item.stock?.stock ?? 0),
            ),
          if (item.barCode != null && item.barCode!.isNotEmpty)
            _DetailRow(
              icon: Icons.qr_code_rounded,
              label: AppLocalizations.of(context).labelBarCode,
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
