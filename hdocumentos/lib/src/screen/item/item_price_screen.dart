import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/item_list_provider.dart';
import 'package:hdocumentos/src/screen/item/widgets/widgets.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Pantalla para actualizar únicamente el precio y costo de un producto
class ItemPriceScreen extends StatefulWidget {
  final ItemModel item;

  const ItemPriceScreen({Key? key, required this.item}) : super(key: key);

  @override
  State<ItemPriceScreen> createState() => _ItemPriceScreenState();
}

class _ItemPriceScreenState extends State<ItemPriceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _priceController;
  late TextEditingController _costController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _priceController = TextEditingController(
        text: (widget.item.pricing?.price ?? 0.0).toStringAsFixed(2));
    _costController = TextEditingController(
        text: (widget.item.pricing?.cost ?? 0.0).toStringAsFixed(2));
  }

  @override
  void dispose() {
    _priceController.dispose();
    _costController.dispose();
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
                PriceActionButtons(
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
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppDimens.paddingM),
            PageTitleWidget(title: l10n.itemPriceTitle),
            SizedBox(height: AppDimens.spaceL),
            ProductInfoCard(item: widget.item),
            SizedBox(height: AppDimens.spaceL),
            CurrentPricesRow(item: widget.item),
            SizedBox(height: AppDimens.paddingM),
            const PriceInfoPanel(),
            SizedBox(height: AppDimens.spaceL),
            PriceForm(
              formKey: _formKey,
              priceController: _priceController,
              costController: _costController,
            ),
            SizedBox(height: AppDimens.spaceXL),
          ],
        ),
      ),
    );
  }

  Widget _buildLandscape(BuildContext context, AppLocalizations l10n) {
    final size = MediaQuery.of(context).size;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Panel izquierdo: info producto + precios actuales
        SizedBox(
          width: size.width * 0.38,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.itemPriceTitle,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: AppDimens.spaceM),
                ProductInfoCard(item: widget.item),
                SizedBox(height: AppDimens.spaceM),
                CurrentPricesRow(item: widget.item),
                SizedBox(height: AppDimens.spaceM),
                const PriceInfoPanel(),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1, color: Colors.white12),
        // Panel derecho: formulario + botones
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PriceForm(
                  formKey: _formKey,
                  priceController: _priceController,
                  costController: _costController,
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

    final newPrice = double.parse(_priceController.text.trim());
    final newCost = double.tryParse(_costController.text.trim()) ?? 0.0;

    setState(() => _isSaving = true);

    try {
      final provider = Provider.of<ItemListProvider>(context, listen: false);
      final success = await provider.updatePrice(
          widget.item.id!, newPrice, newCost, context);

      if (!mounted) return;
      final l10n = AppLocalizations.of(context);

      if (success) {
        NotificationService.showSnackbarSuccess(l10n.itemPriceSuccess);
        Navigator.pop(context, true);
      } else {
        NotificationService.showSnackbarError(l10n.itemPriceError);
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
