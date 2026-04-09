import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/bill/last_sale_model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:intl/intl.dart';

/// Sección "Mis Ventas" en HomeScreen.
///
/// - Si [sales] es null (carga en curso o error) → spinner compacto.
/// - Si [sales] está vacío → empty state enterprise con CTA.
/// - Si hay ventas → scroll horizontal de tarjetas de resumen.
class LastSalesWidget extends StatelessWidget {
  final List<LastSaleModel>? sales;
  final String title;

  const LastSalesWidget({
    Key? key,
    required this.sales,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Título solo cuando hay ventas reales
    final hasSales = sales != null && sales!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasSales) ...[
          _SectionHeader(title: title, itemCount: sales!.length),
          const SizedBox(height: 10),
          _SalesCarousel(sales: sales!),
        ] else if (sales == null)
          const _LoadingCards()
        else
          const _EmptyState(),
      ],
    );
  }
}

// ─── Encabezado de sección ───────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  final int? itemCount;

  const _SectionHeader({required this.title, this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          if (itemCount != null && itemCount! > 0) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.primaryButton.withOpacity(0.18),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$itemCount',
                style: const TextStyle(
                  color: AppTheme.primaryButton,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
          const Spacer(),
          if (itemCount != null && itemCount! > 0)
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, 'bill'),
              child: Row(
                children: const [
                  Text(
                    'Ver todo',
                    style: TextStyle(
                      color: AppTheme.primaryButton,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.chevron_right_rounded,
                      color: AppTheme.primaryButton, size: 16),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Skeleton de carga ────────────────────────────────────────────────────────

class _LoadingCards extends StatelessWidget {
  const _LoadingCards();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, __) => Container(
          width: 180,
          decoration: BoxDecoration(
            color: AppTheme.cardBackground.withOpacity(0.5),
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}

// ─── Empty state enterprise ───────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 24),
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: AppTheme.primaryButton.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.homeSalesEmpty,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.homeSalesEmptyDesc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Carrusel horizontal de ventas ────────────────────────────────────────────

class _SalesCarousel extends StatelessWidget {
  final List<LastSaleModel> sales;

  const _SalesCarousel({required this.sales});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 140,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: sales.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _SaleCard(sale: sales[index]),
      ),
    );
  }
}

// ─── Tarjeta de venta ─────────────────────────────────────────────────────────

class _SaleCard extends StatelessWidget {
  final LastSaleModel sale;

  static final _dateFormat = DateFormat('dd MMM yyyy');
  static final _currencyFormat =
      NumberFormat.currency(locale: 'es_EC', symbol: '\$', decimalDigits: 2);

  const _SaleCard({required this.sale});

  @override
  Widget build(BuildContext context) {
    final dateStr = sale.date != null ? _dateFormat.format(sale.date!) : '—';

    return Container(
      width: 190,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.cardBackground,
            AppTheme.primary.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.primaryButton.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Fecha + badge de estado
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded,
                  color: AppTheme.textSecondary, size: 11),
              const SizedBox(width: 4),
              Text(
                dateStr,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 10,
                ),
              ),
              const Spacer(),
              if (sale.status != null) _StatusBadge(status: sale.status!),
            ],
          ),
          const SizedBox(height: 10),
          // Nombre del cliente
          Text(
            sale.customerName ?? '—',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (sale.customerIdentification != null) ...[
            const SizedBox(height: 2),
            Text(
              sale.customerIdentification!,
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
          const Spacer(),
          // Total + cantidad de ítems
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  _currencyFormat.format(sale.total),
                  style: const TextStyle(
                    color: AppTheme.primaryButton,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (sale.itemCount > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryButton.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${sale.itemCount} ítem${sale.itemCount != 1 ? 's' : ''}',
                    style: const TextStyle(
                      color: AppTheme.primaryButton,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
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

// ─── Badge de estado de factura ───────────────────────────────────────────────

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status.toUpperCase()) {
      'AUTHORIZED' || 'AUTORIZADA' => (AppTheme.actionSave, 'Auth'),
      'CANCELLED' || 'ANULADA' => (AppTheme.actionDanger, 'Anul'),
      'PENDING' || 'PENDIENTE' => (AppTheme.notificationWarning, 'Pend'),
      _ => (AppTheme.textSecondary, status),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color.withOpacity(0.5), width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
