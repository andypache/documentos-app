import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/bill_totals_data.dart';
import 'package:hdocumentos/src/provider/provider.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

/// Panel de totales responsive (landscape y portrait)
class BillTotalsPanel extends StatelessWidget {
  final VoidCallback onSave;

  const BillTotalsPanel({
    Key? key,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Selector<BillCalculationProvider, BillTotalsData>(
      selector: (_, provider) => BillTotalsData(
        subtotal: provider.subtotal,
        customerDiscount: provider.customerDiscount,
        itemDiscount: provider.discountItem,
        discountTotal: provider.discountTotal,
        totalTax: provider.totalTax,
        total: provider.total,
        isCalculating: provider.isCalculating,
        canSave: context.select((BillStateProvider p) => p.canSave),
        customerDiscountLabel: provider.customerDiscountInfo != null
            ? AppLocalizations.of(context).labelDiscountValue(
                provider.customerDiscountInfo!.percentage.toStringAsFixed(0))
            : null,
      ),
      builder: (context, totalsData, _) {
        final widget = TotalsPanelWidget(
          subtotal: totalsData.subtotal,
          customerDiscount: totalsData.customerDiscount,
          itemDiscount: totalsData.itemDiscount,
          discountTotal: totalsData.discountTotal,
          totalTax: totalsData.totalTax,
          total: totalsData.total,
          isCalculating: totalsData.isCalculating,
          canSave: totalsData.canSave,
          onSave: onSave,
          customerDiscountLabel: totalsData.customerDiscountLabel,
        );

        return isLandscape ? SizedBox(width: 300, child: widget) : widget;
      },
    );
  }
}
