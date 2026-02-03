import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Widget para seleccionar un cliente en la factura
/// Muestra el cliente seleccionado con información de descuento destacada
class CustomerSelectionWidget extends StatelessWidget {
  final CustomerModel? selectedCustomer;
  final VoidCallback onSelectCustomer;
  final VoidCallback? onRemoveCustomer;
  final VoidCallback? onCreateCustomer;
  final VoidCallback? onAssignConsumerFinal;

  const CustomerSelectionWidget({
    Key? key,
    required this.selectedCustomer,
    required this.onSelectCustomer,
    this.onRemoveCustomer,
    this.onCreateCustomer,
    this.onAssignConsumerFinal,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.secondary.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selectedCustomer != null
              ? AppTheme.primaryButton
              : Colors.white30,
          width: 1.5,
        ),
      ),
      child: selectedCustomer == null
          ? _buildEmptyState()
          : _buildSelectedCustomer(),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Seleccionar Cliente',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              // Buscar cliente
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onSelectCustomer,
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('Buscar', style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryButton,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Crear cliente
              if (onCreateCustomer != null)
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onCreateCustomer,
                    icon: const Icon(Icons.person_add, size: 18),
                    label: const Text('Nuevo', style: TextStyle(fontSize: 13)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              // Consumidor final
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onAssignConsumerFinal,
                  icon: const Icon(Icons.person_outline, size: 18),
                  label: const Text('C. Final', style: TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
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

  Widget _buildSelectedCustomer() {
    final customer = selectedCustomer!;
    final hasDiscount = customer.customerDiscount != null &&
        customer.customerDiscount!.status == 'A' &&
        (customer.customerDiscount!.discountValue ?? 0) > 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con nombre y botones
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icono
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppTheme.primaryButton.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  customer.isCompany() ? Icons.business : Icons.person,
                  color: AppTheme.primaryButton,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),

              // Información principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.getDisplayName(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      customer.identificationType?.name ?? 'Sin tipo',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      customer.identification ?? 'Sin identificación',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),

              // Botones de acción en fila
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (onCreateCustomer != null)
                    IconButton(
                      icon: const Icon(Icons.person_add, size: 20),
                      color: Colors.greenAccent,
                      onPressed: onCreateCustomer,
                      tooltip: 'Crear nuevo cliente',
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    color: Colors.white70,
                    onPressed: onSelectCustomer,
                    tooltip: 'Cambiar cliente',
                    padding: const EdgeInsets.all(8),
                    constraints: const BoxConstraints(
                      minWidth: 36,
                      minHeight: 36,
                    ),
                  ),
                  if (onRemoveCustomer != null)
                    IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      color: Colors.red,
                      onPressed: onRemoveCustomer,
                      tooltip: 'Quitar cliente',
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 36,
                        minHeight: 36,
                      ),
                    ),
                ],
              ),
            ],
          ),

          // Descuento prominente (si existe)
          if (hasDiscount) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.3),
                    Colors.green.withOpacity(0.1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green, width: 1.5),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.local_offer,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '¡DESCUENTO DISPONIBLE!',
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${customer.customerDiscount!.discountValue}% de descuento',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (customer.customerDiscount!.endDate != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            'Válido hasta: ${_formatDate(customer.customerDiscount!.endDate!)}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Información adicional
          if (customer.email != null && customer.email!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildInfoRow(Icons.email_outlined, customer.email!),
          ],
          if (customer.phoneNumber != null &&
              customer.phoneNumber!.isNotEmpty) ...[
            const SizedBox(height: 4),
            _buildInfoRow(Icons.phone_outlined, customer.phoneNumber!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.white.withOpacity(0.5),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}
