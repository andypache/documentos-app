import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Widget para mostrar una tarjeta de item en el listado
class ItemCardWidget extends StatelessWidget {
  final ItemModel item;
  final VoidCallback onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ItemCardWidget({
    Key? key,
    required this.item,
    required this.onTap,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.white.withOpacity(0.1),
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              // Imagen o icono
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.primaryButton.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppTheme.primaryButton, width: 2),
                ),
                child: item.image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.memory(
                          item.image!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Icon(
                        item.isService == 'Y'
                            ? Icons.home_repair_service
                            : Icons.inventory_2,
                        color: AppTheme.primaryButton,
                        size: 30,
                      ),
              ),
              const SizedBox(width: 15),
              // Información del item
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (item.isService == 'Y')
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'SERVICIO',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    if (item.searchKey != null && item.searchKey!.isNotEmpty)
                      Text(
                        'Clave: ${item.searchKey}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.attach_money,
                          color: Colors.green[300],
                          size: 16,
                        ),
                        Text(
                          '\$${item.price?.toStringAsFixed(2) ?? "0.00"}',
                          style: TextStyle(
                            color: Colors.green[300],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (item.isService == 'N') ...[
                          const SizedBox(width: 15),
                          Icon(
                            Icons.inventory,
                            color: Colors.orange[300],
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Stock: ${item.stock ?? 0}',
                            style: TextStyle(
                              color: Colors.orange[300],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Botones de acción
              Column(
                children: [
                  if (onEdit != null)
                    IconButton(
                      icon:
                          const Icon(Icons.edit, color: Colors.blue, size: 20),
                      onPressed: onEdit,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  if (onDelete != null)
                    IconButton(
                      icon:
                          const Icon(Icons.delete, color: Colors.red, size: 20),
                      onPressed: onDelete,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
