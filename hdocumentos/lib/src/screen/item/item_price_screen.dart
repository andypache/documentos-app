import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/item_list_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
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
        text: (widget.item.price ?? 0.0).toStringAsFixed(2));
    _costController = TextEditingController(
        text: (widget.item.cost ?? 0.0).toStringAsFixed(2));
  }

  @override
  void dispose() {
    _priceController.dispose();
    _costController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          const BrackgroundWidget(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: size.height * 0.02),
                    // Título
                    const PageTitleWidget(title: 'Actualizar Precio'),
                    SizedBox(height: size.height * 0.03),

                    // Info del producto
                    Container(
                      padding: EdgeInsets.all(size.width * 0.04),
                      decoration: BoxDecoration(
                        color: AppTheme.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                            color: AppTheme.primaryButton.withOpacity(0.4),
                            width: 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: size.width * 0.14,
                            height: size.width * 0.14,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryButton.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                  color: AppTheme.primaryButton, width: 2),
                            ),
                            child: widget.item.image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.memory(widget.item.image!,
                                        fit: BoxFit.cover),
                                  )
                                : const Icon(Icons.inventory_2,
                                    color: AppTheme.primaryButton, size: 30),
                          ),
                          SizedBox(width: size.width * 0.04),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.item.name,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: size.width * 0.045,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (widget.item.searchKey != null &&
                                    widget.item.searchKey!.isNotEmpty)
                                  Text(
                                    'Clave: ${widget.item.searchKey}',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: size.width * 0.032,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),

                    // Precios actuales
                    Row(
                      children: [
                        Expanded(
                          child: _PriceInfoBox(
                            label: 'Precio actual',
                            value:
                                '\$${(widget.item.price ?? 0).toStringAsFixed(2)}',
                            icon: Icons.attach_money_rounded,
                            color: Colors.green,
                          ),
                        ),
                        SizedBox(width: size.width * 0.03),
                        Expanded(
                          child: _PriceInfoBox(
                            label: 'Costo actual',
                            value:
                                '\$${(widget.item.cost ?? 0).toStringAsFixed(2)}',
                            icon: Icons.money_off_rounded,
                            color: Colors.amber,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.03),

                    // Formulario
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Precio de venta
                          Text(
                            'Nuevo precio de venta',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: size.width * 0.038,
                            ),
                          ),
                          SizedBox(height: size.height * 0.012),
                          TextFormField(
                            controller: _priceController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            autofocus: true,
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.attach_money_rounded,
                                  color: Colors.green),
                              labelText: 'Precio de venta *',
                              hintText: 'Ej: 99.99',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El precio es requerido';
                              }
                              final n = double.tryParse(value.trim());
                              if (n == null || n < 0) {
                                return 'Ingrese un valor válido (0 o mayor)';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),

                          SizedBox(height: size.height * 0.025),

                          // Costo
                          Text(
                            'Nuevo costo',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: size.width * 0.038,
                            ),
                          ),
                          SizedBox(height: size.height * 0.012),
                          TextFormField(
                            controller: _costController,
                            style: const TextStyle(color: Colors.white),
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(Icons.money_off_rounded,
                                  color: Colors.amber),
                              labelText: 'Costo',
                              hintText: 'Ej: 60.00',
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return null; // costo opcional
                              }
                              final n = double.tryParse(value.trim());
                              if (n == null || n < 0) {
                                return 'Ingrese un valor válido (0 o mayor)';
                              }
                              return null;
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.05),

                    // Botones
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed:
                                _isSaving ? null : () => Navigator.pop(context),
                            icon: const Icon(Icons.close_rounded),
                            label: const Text('Cancelar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.actionDanger,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.018),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        SizedBox(width: size.width * 0.04),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _isSaving ? null : _onSave,
                            icon: _isSaving
                                ? const ButtonLoadingIndicator()
                                : const Icon(Icons.save_rounded),
                            label: Text(_isSaving ? 'Guardando...' : 'Guardar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.actionSave,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.018),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: size.height * 0.04),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final newPrice = double.parse(_priceController.text.trim());
    final newCost = double.tryParse(_costController.text.trim()) ?? 0.0;

    setState(() => _isSaving = true);

    try {
      final provider = Provider.of<ItemListProvider>(context, listen: false);
      final success =
          await provider.updatePrice(widget.item.itemId!, newPrice, newCost);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Precio actualizado correctamente'
                : 'Error al actualizar el precio',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor:
              success ? AppTheme.actionSave : AppTheme.actionDanger,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        ),
      );

      if (success) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: AppTheme.actionDanger,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}

/// Caja de información de precio actual
class _PriceInfoBox extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _PriceInfoBox({
    Key? key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04, vertical: size.height * 0.018),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4), width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: size.width * 0.055),
          SizedBox(width: size.width * 0.025),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: size.width * 0.028,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: color,
                  fontSize: size.width * 0.042,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
