import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/exception/app_exceptions.dart';
import 'package:hdocumentos/src/exception/error_handler.dart';
import 'package:hdocumentos/src/provider/form/customer_form_provider.dart';
import 'package:hdocumentos/src/service/notification_service.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Botones de navegación del wizard (Anterior/Cancelar, Siguiente/Guardar)
class CustomerNavigationButtons extends StatelessWidget {
  const CustomerNavigationButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final customerForm = Provider.of<CustomerFormProvider>(context);
    final size = MediaQuery.of(context).size;
    final l10n = AppLocalizations.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final double iconSize = isLandscape ? 18.0 : size.width * 0.045;
    final double fontSize = isLandscape ? 13.0 : size.width * 0.034;
    final btnPadding = EdgeInsets.symmetric(
      horizontal: isLandscape ? 16.0 : size.width * 0.05,
      vertical: isLandscape ? 10.0 : 12.0,
    );

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Botón Anterior / Cancelar
          if (customerForm.currentStep > 0)
            ElevatedButton.icon(
              onPressed: customerForm.isLoading
                  ? null
                  : () => customerForm.previousStep(),
              icon: Icon(Icons.arrow_back_rounded, size: iconSize),
              label:
                  Text(l10n.btnPrevious, style: TextStyle(fontSize: fontSize)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.grey,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: btnPadding,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusM)),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.close_rounded, size: iconSize),
              label: Text(l10n.btnCancel, style: TextStyle(fontSize: fontSize)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.actionDanger,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: btnPadding,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusM)),
              ),
            ),

          // Indicador de paso
          Text(
            '${customerForm.currentStep + 1} de 3',
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: isLandscape ? 12.0 : size.width * 0.032,
            ),
          ),

          // Botón Siguiente / Guardar
          if (customerForm.currentStep < 2)
            ElevatedButton.icon(
              onPressed: customerForm.isLoading
                  ? null
                  : () {
                      if (!customerForm.nextStep()) {
                        NotificationService.showError(l10n.msgRequiredFields);
                      }
                    },
              icon: Icon(Icons.arrow_forward_rounded, size: iconSize),
              label: Text(l10n.btnNext,
                  style: TextStyle(
                      fontSize: fontSize, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryButton,
                foregroundColor: AppTheme.secondary,
                elevation: 0,
                padding: btnPadding,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusM)),
              ),
            )
          else
            ElevatedButton.icon(
              onPressed: customerForm.isLoading
                  ? null
                  : () => _handleSaveCustomer(context, customerForm),
              icon: customerForm.isLoading
                  ? ButtonLoadingIndicator(size: iconSize)
                  : Icon(Icons.save_rounded, size: iconSize),
              label: Text(
                customerForm.isLoading ? l10n.btnSaving : l10n.btnSave,
                style:
                    TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.actionSave,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: btnPadding,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimens.radiusM)),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleSaveCustomer(
      BuildContext context, CustomerFormProvider customerForm) async {
    customerForm.isLoading = true;

    try {
      // Validar y construir customer con validaciones tipadas
      final customer = customerForm.validateAndBuildCustomer();

      // TODO: Implementar guardado en el servicio
      // await CustomerService.saveCustomer(context, customer);
      await Future.delayed(const Duration(seconds: 1));

      customerForm.isLoading = false;

      if (context.mounted) {
        final l10n = AppLocalizations.of(context);
        NotificationService.showSuccess(
          customer.customerId != null
              ? l10n.customerUpdatedSuccess
              : l10n.customerCreatedSuccess,
        );
        Navigator.pop(context, customer);
      }
    } on ValidationException catch (e) {
      customerForm.isLoading = false;
      if (context.mounted) {
        ErrorHandler.handleError(e, context: context);
      }
    } catch (e) {
      customerForm.isLoading = false;
      if (context.mounted) {
        NotificationService.showError(
            AppLocalizations.of(context).saveError(e.toString()));
      }
    }
  }
}
