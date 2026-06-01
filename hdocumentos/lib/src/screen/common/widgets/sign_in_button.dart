import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/form/login_form_provider.dart';
import 'package:hdocumentos/src/provider/provider.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/share/preference.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Botón de inicio de sesión con lógica de autenticación
class SignInButton extends StatelessWidget {
  final LoginFormProvider loginForm;
  final AuthService authService;

  const SignInButton({
    Key? key,
    required this.loginForm,
    required this.authService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SizedBox(
      width: double.infinity,
      height: AppDimens.buttonHeight,
      child: ElevatedButton(
        onPressed: loginForm.isLoading ? null : () => _onSignIn(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryButton,
          foregroundColor: AppTheme.secondary,
          disabledBackgroundColor: AppTheme.grey,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM),
          ),
        ),
        child: loginForm.isLoading
            ? const ButtonLoadingIndicator(size: AppDimens.iconS)
            : Text(
                l10n.loginBtnSignIn,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: AppDimens.fontBody,
                  letterSpacing: 0.4,
                ),
              ),
      ),
    );
  }

  Future<void> _onSignIn(BuildContext context) async {
    FocusScope.of(context).unfocus();
    if (!loginForm.isValidForm()) return;

    final l10n = AppLocalizations.of(context);
    final navigator = Navigator.of(context);

    loginForm.isLoading = true;
    try {
      final ServiceResponseModel response =
          await authService.login(loginForm.username, loginForm.password);

      if (response.statusHttp == 200) {
        Preferences.keepSession = loginForm.keepSession;
        // Cargar catálogos y empresa — mantener isLoading=true hasta terminar
        if (context.mounted) {
          await context.read<AppInitProvider>().init(context);
        }
        loginForm.isLoading = false;
        navigator.pushReplacementNamed('home');
      } else {
        loginForm.isLoading = false;
        NotificationService.showError(
          getError(response).toString(),
          title: l10n.loginTitle,
        );
      }
    } catch (_) {
      loginForm.isLoading = false;
      NotificationService.showError(l10n.loginErrGeneral);
    }
  }
}
