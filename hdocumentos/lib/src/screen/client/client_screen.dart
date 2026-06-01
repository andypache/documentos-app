import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/screen/client/widgets/widgets.dart';
import 'package:hdocumentos/src/screen/customer/customer_wizard_screen.dart';
import 'package:hdocumentos/src/service/notification_service.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

/// Screen principal para gestión de clientes
class ClientScreen extends StatelessWidget {
  const ClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BrackgroundWidget(),
          Column(
            children: [
              const Expanded(child: ClientScreenBody()),
              ClientBottomActionBar(
                onNewCustomer: () => _navigateToCreateCustomer(context),
                onCancel: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToCreateCustomer(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CustomerWizardScreen()),
    );

    if (result == true && context.mounted) {
      NotificationService.showSuccess(
          AppLocalizations.of(context).customerCreatedSuccess);
    }
  }
}
