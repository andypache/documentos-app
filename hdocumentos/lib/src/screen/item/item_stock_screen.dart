import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/item_list_provider.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
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
                _actionButtons(context, l10n),
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
          const SizedBox(height: 16),
          PageTitleWidget(title: l10n.itemStockTitle),
          const SizedBox(height: 20),
          _productInfoCard(l10n),
          const SizedBox(height: 20),
          _stockInfoRow(l10n),
          const SizedBox(height: 20),
          _form(l10n),
          const SizedBox(height: 20),
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
                _productInfoCard(l10n),
                const SizedBox(height: 14),
                _stockInfoRow(l10n),
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
                _form(l10n),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _productInfoCard(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppTheme.primaryButton.withOpacity(0.4), width: 1),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: AppTheme.primaryButton.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppTheme.primaryButton, width: 2),
            ),
            child: widget.item.media?.image != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                        widget.item.media?.image ?? Uint8List(0),
                        fit: BoxFit.cover),
                  )
                : const Icon(Icons.inventory_2,
                    color: AppTheme.primaryButton, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.name,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.item.searchKey != null &&
                    widget.item.searchKey!.isNotEmpty)
                  Text(
                    l10n.labelSearchKeyPrefix(widget.item.searchKey!),
                    style: const TextStyle(color: Colors.white60, fontSize: 12),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _stockInfoRow(AppLocalizations l10n) {
    return _StockInfoRow(
      label: l10n.labelCurrentStock,
      value: l10n.labelStockPrefix(widget.item.stock?.stock ?? 0),
      icon: Icons.inventory_rounded,
      color: Colors.orange,
    );
  }

  Widget _form(AppLocalizations l10n) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.labelNewStock,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 10),
          TextFormField(
            controller: _stockController,
            style: const TextStyle(color: Colors.white),
            keyboardType: const TextInputType.numberWithOptions(decimal: false),
            decoration: InputDecoration(
              prefixIcon:
                  const Icon(Icons.inventory_2_outlined, color: Colors.orange),
              labelText: l10n.labelStockField,
              hintText: l10n.hintStockNew,
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return l10n.validatorStockRequired;
              }
              final n = int.tryParse(value.trim());
              if (n == null || n < 0) return l10n.validatorValueInvalid;
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _locationController,
            style: const TextStyle(color: Colors.white),
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon:
                  const Icon(Icons.location_on_outlined, color: Colors.orange),
              labelText: l10n.labelStockLocation,
              hintText: l10n.hintStockLocation,
              floatingLabelStyle:
                  TextStyle(color: Colors.white.withOpacity(0.8)),
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            ),
            validator: (value) {
              if (value != null &&
                  value.trim().isNotEmpty &&
                  value.trim().length < 3) {
                return l10n.validatorMinLength(3);
              }
              return null;
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ],
      ),
    );
  }

  Widget _actionButtons(BuildContext context, AppLocalizations l10n) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLandscape ? 16.0 : size.width * 0.05,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : () => Navigator.pop(context),
              icon: const Icon(Icons.close_rounded),
              label: Text(l10n.btnCancel),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.actionDanger,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _isSaving ? null : _onSave,
              icon: _isSaving
                  ? const ButtonLoadingIndicator()
                  : const Icon(Icons.save_rounded),
              label: Text(_isSaving ? l10n.btnSaving : l10n.btnSave),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.actionSave,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
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

/// Fila de información de stock
class _StockInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StockInfoRow({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(color: Colors.white60, fontSize: 12)),
              Text(
                value,
                style: TextStyle(
                    color: color, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
