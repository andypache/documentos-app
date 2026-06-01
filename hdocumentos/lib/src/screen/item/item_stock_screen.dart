import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/item_list_provider.dart';
import 'package:hdocumentos/src/screen/item/widgets/widgets.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Pantalla para actualizar únicamente el stock de un producto
class ItemStockScreen extends StatefulWidget {
  final ItemModel item;

  const ItemStockScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<ItemStockScreen> createState() => _ItemStockScreenState();
}

class _ItemStockScreenState extends State<ItemStockScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _stockController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _stockController = TextEditingController(text: '1');
    _locationController =
        TextEditingController(text: widget.item.stock?.location ?? '');
  }

  @override
  void dispose() {
    _stockController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: Stack(
        children: [
          const BrackgroundWidget(),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: isLandscape
                      ? _buildLandscape(context, l10n)
                      : _buildPortrait(context, l10n),
                ),
                StockActionButtons(
                  isSaving: _isSaving,
                  onCancel: () => Navigator.pop(context),
                  onSave: _onSave,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortrait(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: AppDimens.paddingM),
          PageTitleWidget(title: l10n.itemStockTitle),
          SizedBox(height: AppDimens.spaceL),
          StockProductInfoCard(item: widget.item),
          SizedBox(height: AppDimens.spaceL),
          StockInfoRow(
            label: l10n.labelCurrentStock,
            value: l10n.labelStockPrefix(widget.item.stock?.stock ?? 0),
            icon: Icons.inventory_rounded,
            color: Colors.orange,
          ),
          SizedBox(height: AppDimens.spaceL),
          StockForm(
            formKey: _formKey,
            stockController: _stockController,
            locationController: _locationController,
          ),
          SizedBox(height: AppDimens.spaceL),
        ],
      ),
    );
  }

  Widget _buildLandscape(BuildContext context, AppLocalizations l10n) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Panel izquierdo: info
        SizedBox(
          width: 280,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 12, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PageTitleWidget(title: l10n.itemStockTitle),
                const SizedBox(height: 14),
                StockProductInfoCard(item: widget.item),
                const SizedBox(height: 14),
                StockInfoRow(
                  label: l10n.labelCurrentStock,
                  value: l10n.labelStockPrefix(widget.item.stock?.stock ?? 0),
                  icon: Icons.inventory_rounded,
                  color: Colors.orange,
                ),
              ],
            ),
          ),
        ),
        // Divisor
        Container(width: 1, color: Colors.white.withOpacity(0.1)),
        // Panel derecho: formulario + botones
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StockForm(
                  formKey: _formKey,
                  stockController: _stockController,
                  locationController: _locationController,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final newStock = int.parse(_stockController.text.trim());
    final location = _locationController.text.trim();

    setState(() => _isSaving = true);

    try {
      final provider = Provider.of<ItemListProvider>(context, listen: false);
      final success = await provider.updateStock(
        widget.item.id!,
        newStock,
        context,
        location: location.isEmpty ? null : location,
      );

      if (!mounted) return;
      final l10n = AppLocalizations.of(context);

      if (success) {
        NotificationService.showSnackbarSuccess(l10n.itemStockSuccess);
        Navigator.pop(context, true);
      } else {
        NotificationService.showSnackbarError(l10n.itemStockError);
      }
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      NotificationService.showSnackbarError(l10n.errorGeneric(e.toString()));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
