import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/provider/provider.dart';

/// Wrapper con todos los providers necesarios para BillScreen
class BillProvidersWrapper extends StatelessWidget {
  final Widget child;

  const BillProvidersWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provider 1: Customer
        ChangeNotifierProvider(
          create: (_) => BillCustomerProvider(),
        ),
        // Provider 2: Items
        ChangeNotifierProvider(
          create: (_) => BillItemsProvider(),
        ),
        // Provider 3: Payment
        ChangeNotifierProvider(
          create: (_) => BillPaymentProvider()..initialize(),
        ),
        // Provider 4: Calculation (depende de Customer e Items)
        ChangeNotifierProxyProvider2<BillCustomerProvider, BillItemsProvider,
            BillCalculationProvider>(
          create: (context) => BillCalculationProvider(
            customerProvider: context.read<BillCustomerProvider>(),
            itemsProvider: context.read<BillItemsProvider>(),
          )..initialize(context),
          update: (context, customerProvider, itemsProvider, previous) {
            if (previous == null) {
              return BillCalculationProvider(
                customerProvider: customerProvider,
                itemsProvider: itemsProvider,
              )..initialize(context);
            }
            return previous;
          },
        ),
        // Provider 5: State (depende de todos los anteriores)
        ChangeNotifierProxyProvider4<BillCustomerProvider, BillItemsProvider,
            BillPaymentProvider, BillCalculationProvider, BillStateProvider>(
          create: (context) => BillStateProvider(
            customerProvider: context.read<BillCustomerProvider>(),
            itemsProvider: context.read<BillItemsProvider>(),
            paymentProvider: context.read<BillPaymentProvider>(),
            calculationProvider: context.read<BillCalculationProvider>(),
          ),
          update: (context, customerProvider, itemsProvider, paymentProvider,
              calculationProvider, previous) {
            if (previous == null) {
              return BillStateProvider(
                customerProvider: customerProvider,
                itemsProvider: itemsProvider,
                paymentProvider: paymentProvider,
                calculationProvider: calculationProvider,
              );
            }
            return previous;
          },
        ),
      ],
      child: child,
    );
  }
}
