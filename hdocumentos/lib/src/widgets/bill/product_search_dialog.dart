import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/service/item_service.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/common/loading_widget.dart';

/// Modo de consulta del diálogo.
enum _SearchMode { all, filter }

/// Diálogo para buscar y seleccionar productos con paginación infinita.
///
/// - Botón "Ver Todos" → GET /items/pagination/all   (sin filtro)
/// - Botón "Buscar"    → GET /items/pagination/filter (con search)
///
/// La paginación se detiene cuando el servidor retorna 400.
class ProductSearchDialog extends StatefulWidget {
  const ProductSearchDialog({Key? key}) : super(key: key);

  @override
  State<ProductSearchDialog> createState() => _ProductSearchDialogState();
}

class _ProductSearchDialogState extends State<ProductSearchDialog> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<ItemModel> _items = [];
  bool _isLoading = false; // Spinner de carga completa (primera página)
  bool _isLoadingMore = false; // Spinner pequeño al fondo (páginas siguientes)
  bool _hasReachedEnd = false;
  int _currentPage = 1;
  _SearchMode _mode = _SearchMode.all;

  // ── Ciclo de vida ──────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // ── Scroll infinito ────────────────────────────────────────────────────────

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 100 &&
        !_isLoadingMore &&
        !_hasReachedEnd) {
      _loadNextPage();
    }
  }

  // ── Lógica de carga ────────────────────────────────────────────────────────

  /// Reinicia el estado y arranca la primera página con el modo indicado.
  Future<void> _startLoad(_SearchMode mode) async {
    if (!mounted) return;
    _items.clear();
    _currentPage = 1;
    _hasReachedEnd = false;
    _mode = mode;

    setState(() => _isLoading = true);
    await _fetchPage();
    if (mounted) setState(() => _isLoading = false);
  }

  /// Solicita la siguiente página usando el modo activo.
  Future<void> _loadNextPage() async {
    if (_isLoadingMore || _hasReachedEnd) return;
    setState(() => _isLoadingMore = true);
    await _fetchPage();
    if (mounted) setState(() => _isLoadingMore = false);
  }

  /// Llama al endpoint correspondiente según [_mode] y actualiza [_items].
  Future<void> _fetchPage() async {
    if (!mounted) return;
    try {
      final List<ItemModel>? result;

      if (_mode == _SearchMode.filter) {
        result = await ItemService.fetchItemsPageFilter(
          context,
          page: _currentPage,
          search: _searchController.text.trim(),
        );
      } else {
        result = await ItemService.fetchItemsPage(
          context,
          page: _currentPage,
        );
      }

      if (!mounted) return;

      // null = servidor devolvió 400 → sin más páginas
      if (result == null) {
        setState(() => _hasReachedEnd = true);
        return;
      }

      setState(() {
        _items.addAll(result!);
        _currentPage++;
        if (result.isEmpty) _hasReachedEnd = true;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar items: $e')),
        );
      }
    }
  }

  // ── Acciones de la UI ──────────────────────────────────────────────────────

  void _onSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;
    _startLoad(_SearchMode.filter);
  }

  void _onViewAll() {
    _searchController.clear();
    _startLoad(_SearchMode.all);
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {});
  }

  void _selectItem(ItemModel item) => Navigator.pop(context, item);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      backgroundColor: AppTheme.dialogBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: AppTheme.dialogBorder, width: 1),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 650, maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──────────────────────────────────────────────────
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
                  const Icon(Icons.manage_search_rounded,
                      color: Colors.white, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.searchProductTitle,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            // ── Campo de búsqueda ────────────────────────────────────────
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
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: l10n.dialogSearchProductHint,
                          hintStyle:
                              TextStyle(color: Colors.white.withOpacity(0.5)),
                          prefixIcon: const Icon(Icons.search,
                              color: AppTheme.primaryButton),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear,
                                      color: AppTheme.primaryButton),
                                  onPressed: _clearSearch,
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) => _onSearch(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Botón buscar → /pagination/filter
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryButton,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.search, color: Colors.white),
                      onPressed: _searchController.text.trim().isNotEmpty
                          ? _onSearch
                          : null,
                      tooltip: 'Buscar',
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Botón ver todos → /pagination/all
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryButton,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.list, color: Colors.white),
                      onPressed: _onViewAll,
                      tooltip: 'Ver Todos',
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),

            // ── Resultados ───────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: _buildResults(l10n),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults(AppLocalizations l10n) {
    // Primera carga completa
    if (_isLoading) return const ContentLoadingWidget();

    // Sin resultados
    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined,
                size: 64, color: AppTheme.textSecondary.withOpacity(0.5)),
            const SizedBox(height: 16),
            Text(
              l10n.noDialogProductsFound,
              style:
                  const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
          ],
        ),
      );
    }

    // Lista con paginación infinita.
    // El ítem extra al final muestra el spinner de "cargando más".
    return ListView.builder(
      key: const ValueKey('product_search_list'),
      controller: _scrollController,
      itemCount: _items.length + (_hasReachedEnd ? 0 : 1),
      itemBuilder: (context, index) {
        if (index == _items.length) {
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
        final item = _items[index];
        return _buildItemCard(item);
      },
    );
  }

  Widget _buildItemCard(ItemModel item) {
    final hasTaxes = item.itemTaxes != null && item.itemTaxes!.isNotEmpty;
    final isService = item.isService == 'Y';

    return Card(
      key: ValueKey('product_card_${item.id}'),
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
                      '\$${item.pricing?.price?.toStringAsFixed(2) ?? '0.00'}',
                      style: const TextStyle(
                        color: AppTheme.primaryButton,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (!isService) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Stock: ${item.stock?.stock ?? 0}',
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
                        children: item.itemTaxes!.map((tax) {
                          return Container(
                            key: ValueKey('tax_${tax.id}'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryButton.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: AppTheme.primaryButton, width: 1),
                            ),
                            child: Text(
                              '${tax.name} ${tax.percentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                color: AppTheme.primaryButton,
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
