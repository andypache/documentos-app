import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/screen/client/widgets/customer_card.dart';
import 'package:hdocumentos/src/screen/client/widgets/customer_empty_state.dart';
import 'package:hdocumentos/src/screen/client/widgets/customer_detail_sheet.dart';
import 'package:hdocumentos/src/screen/customer/customer_wizard_screen.dart';
import 'package:hdocumentos/src/service/notification_service.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'customer_result_widgets.dart';

/// Sección que muestra los resultados de búsqueda de clientes
class CustomerResultSection extends StatelessWidget {
  final bool isLoading;
  final bool hasSearched;
  final List<Map<String, dynamic>> customers;
  final VoidCallback onRefresh;

  const CustomerResultSection({
    Key? key,
    required this.isLoading,
    required this.hasSearched,
    required this.customers,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    // Estado inicial
    if (!hasSearched) {
      return Builder(
        builder: (ctx) => CustomerEmptyState(
          icon: Icons.search_rounded,
          title: AppLocalizations.of(ctx).searchCustomersTitle,
          message: AppLocalizations.of(ctx).searchCustomersMsg,
        ),
      );
    }

    // Cargando
    if (isLoading) {
      return const ContentLoadingWidget();
    }

    // Sin resultados
    if (customers.isEmpty) {
      return Builder(
        builder: (ctx) => CustomerEmptyState(
          icon: Icons.people_outline_rounded,
          title: AppLocalizations.of(ctx).noCustomersFound,
          message: AppLocalizations.of(ctx).noCustomersFoundMsg,
        ),
      );
    }

    // Lista de clientes
    final hPad = isLandscape ? 16.0 : size.width * 0.05;
    final listView = ListView.builder(
      key: const ValueKey('customer_list'),
      shrinkWrap: !isLandscape,
      physics: isLandscape
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: hPad),
      itemCount: customers.length,
      itemBuilder: (context, index) {
        final customer = customers[index];
        return CustomerCard(
          key: ValueKey('customer_${customer['customerId']}'),
          customer: customer,
          onTap: () => _showCustomerDetail(context, customer),
          onEdit: () => _navigateToEditCustomer(context, customer, onRefresh),
          onDelete: () => _confirmDeleteCustomer(context, customer, onRefresh),
        );
      },
    );

    if (isLandscape) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomersCountHeader(
            customerCount: customers.length,
            isLandscape: true,
          ),
          Expanded(child: listView),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomersCountHeader(
          customerCount: customers.length,
          isLandscape: false,
        ),
        listView,
      ],
    );
  }

  void _showCustomerDetail(
      BuildContext context, Map<String, dynamic> customer) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.dialogBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        side: BorderSide(color: AppTheme.dialogBorder, width: 1),
      ),
      builder: (context) => CustomerDetailSheet(customer: customer),
    );
  }

  Future<void> _navigateToEditCustomer(BuildContext context,
      Map<String, dynamic> customer, VoidCallback onRefresh) async {
    // Crear modelo temporal del cliente
    final customerModel = CustomerModel(
      customerId: customer['customerId'],
      identificationTypeId: customer['identificationTypeId'],
      identificationType: IdentificationTypeModel(
        identificationTypeId: customer['identificationTypeId'],
        name: customer['type'],
        description: customer['type'],
        inicials: customer['type'] == 'RUC'
            ? 'RUC'
            : customer['type'] == 'Cédula'
                ? 'CED'
                : 'PAS',
        sriCode: customer['sriCode'],
        length: customer['identification'].length,
        status: 'A',
      ),
      identification: customer['identification'],
      firstName: customer['firstName'],
      lastName: customer['lastName'],
      businessName: customer['businessName'],
      email: customer['email'],
      phoneNumber: customer['phone'],
      address: customer['address'],
      status: 'A',
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            CustomerWizardScreen(customerToEdit: customerModel),
      ),
    );

    if (result == true && context.mounted) {
      onRefresh(); // Recargar la lista
    }
  }

  Future<void> _confirmDeleteCustomer(BuildContext context,
      Map<String, dynamic> customer, VoidCallback onRefresh) async {
    final displayName = customer['businessName'] ??
        '${customer['firstName'] ?? ''} ${customer['lastName'] ?? ''}'.trim();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => DeleteCustomerDialog(displayName: displayName),
    );

    if (confirmed == true && context.mounted) {
      // TODO: Implementar eliminación en el servicio
      NotificationService.showSuccess(
          AppLocalizations.of(context).customerDeletedSuccess);
      onRefresh();
    }
  }
}
