import 'package:flutter/material.dart';
import 'package:hdocumentos/src/provider/form/login_form_provider.dart';
import 'package:hdocumentos/src/screen/common/widgets/widgets.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:provider/provider.dart';

/// Pantalla de inicio de sesión con UX empresarial.
class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LoginBackgroundWidget(
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingL,
                  vertical: AppDimens.paddingXL),
              child: ChangeNotifierProvider(
                create: (_) => LoginFormProvider(),
                child: const _LoginCard(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Tarjeta principal ─────────────────────────────────────────────────────────

class _LoginCard extends StatelessWidget {
  const _LoginCard();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width > 480 ? 420 : double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.loginCardBg,
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        border: Border.all(
          color: AppTheme.loginInputBorder.withOpacity(0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.secondary.withOpacity(0.6),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const LoginHeader(),
          const Divider(
            height: 1,
            thickness: 1,
            color: AppTheme.loginDivider,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(AppDimens.paddingXL,
                AppDimens.paddingXL, AppDimens.paddingXL, AppDimens.paddingL),
            child: const LoginForm(),
          ),
          const RegisterLink(),
          const SizedBox(height: AppDimens.spaceM),
          // ── Marca de la app ───────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimens.paddingM),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDimens.paddingS,
                  vertical: AppDimens.paddingXS),
              decoration: BoxDecoration(
                color: AppTheme.primaryButton.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppDimens.radiusS),
                border: Border.all(
                  color: AppTheme.primaryButton.withOpacity(0.35),
                  width: 1,
                ),
              ),
              child: ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [AppTheme.primaryButton, Color(0xFF80DEEA)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ).createShader(bounds),
                child: const Text(
                  'H·VENTAS',
                  style: TextStyle(
                    fontSize: AppDimens.fontCaption,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
