import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Widget para mostrar una tarjeta de item en el listado
class ItemCardWidget extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onStockChange;
  final VoidCallback? onPriceChange;

  const ItemCardWidget({
    Key? key,
    required this.item,
    required this.onTap,
    this.onEdit,
    this.onDelete,
    this.onStockChange,
    this.onPriceChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      color: AppTheme.white.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Icono / imagen ────────────────────────────────────────
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryButton.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.primaryButton, width: 2),
                ),
                child: item.media?.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child:
                            Image.memory(item.media!.image!, fit: BoxFit.cover),
                      )
                    : Icon(
                        item.isService == 'Y'
                            ? Icons.home_repair_service
                            : Icons.inventory_2,
                        color: AppTheme.primaryButton,
                        size: 24,
                      ),
              ),
              const SizedBox(width: 10),
              // ── Textos ────────────────────────────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.isService == 'Y')
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(l10n.labelServiceBadge,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold)),
                          ),
                      ],
                    ),
                    if (item.searchKey != null &&
                        item.searchKey!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        l10n.labelSearchKeyPrefix(item.searchKey!),
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 11),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.attach_money,
                            color: Colors.green[300], size: 14),
                        Text(
                          '\$${item.pricing?.price?.toStringAsFixed(2) ?? "0.00"}',
                          style: TextStyle(
                              color: Colors.green[300],
                              fontSize: 13,
                              fontWeight: FontWeight.bold),
                        ),
                        if (item.isService == 'N') ...[
                          const SizedBox(width: 10),
                          Icon(Icons.inventory,
                              color: Colors.orange[300], size: 13),
                          const SizedBox(width: 2),
                          Text(
                            l10n.labelStockPrefix(item.stock?.stock ?? 0),
                            style: TextStyle(
                                color: Colors.orange[300], fontSize: 11),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // ── Botones de acción ─────────────────────────────────────
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onEdit != null)
                    _ActionBtn(
                        icon: Icons.edit_outlined,
                        color: Colors.blue,
                        onPressed: onEdit!),
                  if (onPriceChange != null)
                    _ActionBtn(
                        icon: Icons.attach_money_rounded,
                        color: Colors.green,
                        onPressed: onPriceChange!),
                  if (onStockChange != null && item.isService == 'N')
                    _ActionBtn(
                        icon: Icons.inventory_2_outlined,
                        color: Colors.orange,
                        onPressed: onStockChange!),
                  if (onDelete != null)
                    _ActionBtn(
                        icon: Icons.delete_outline_rounded,
                        color: Colors.red,
                        onPressed: onDelete!),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Icon(icon, color: color, size: 19),
      ),
    );
  }
}
