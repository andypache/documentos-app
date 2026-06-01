import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/item_list_provider.dart';
import 'package:hdocumentos/src/screen/item/item_price_screen.dart';
import 'package:hdocumentos/src/screen/item/item_stock_screen.dart';
import 'package:hdocumentos/src/screen/item/item_wizard_screen.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/widgets/item/item_card_widget.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'item_empty_state.dart';
import 'item_detail_sheet.dart';
import 'item_list_widgets.dart';

/// Sección de listado de items con paginación infinita
class ItemListSection extends StatefulWidget {
  const ItemListSection({Key? key}) : super(key: key);

  @override
  State<ItemListSection> createState() => _ItemListSectionState();
}

class _ItemListSectionState extends State<ItemListSection> {
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
        builder: (ctx) => ItemEmptyState(
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
        builder: (ctx) => ItemEmptyState(
          icon: Icons.wifi_off_rounded,
          title: 'Error al cargar',
          message: provider.errorMessage!,
        ),
      );
    }

    // Sin resultados
    if (!provider.hasResults) {
      return Builder(
        builder: (ctx) => ItemEmptyState(
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
        ItemsCountHeader(itemCount: items.length),
        SizedBox(height: AppDimens.spaceS),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
            itemCount: itemCount,
            itemBuilder: (context, index) {
              // Spinner de carga de página siguiente
              if (index == items.length) {
                return const PaginationLoadingIndicator();
              }
              final item = items[index];
              return ItemCardWidget(
                key: ValueKey('item_${item.id}'),
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
      builder: (context) => ItemDetailSheet(item: item),
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
      builder: (ctx) => DeleteItemDialog(item: item),
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
