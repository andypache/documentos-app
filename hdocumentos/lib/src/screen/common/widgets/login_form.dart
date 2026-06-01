import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/provider/form/login_form_provider.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/screen/common/widgets/widgets.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:provider/provider.dart';

/// Formulario de login con campos de usuario y contraseña
class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final loginForm = Provider.of<LoginFormProvider>(context);
    final authService = Provider.of<AuthService>(context);

    return Form(
      key: loginForm.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campo usuario
          LoginTextField(
            label: l10n.loginFieldUser,
            hint: l10n.loginFieldUserHint,
            prefixIcon: Icons.person_outline_rounded,
            onChanged: (v) => loginForm.username = v,
            validator: (v) {
              if (v == null || v.isEmpty) return l10n.loginErrUserRequired;
              if (v.length < 3) return l10n.loginErrUserMin;
              return null;
            },
          ),
          const SizedBox(height: AppDimens.spaceL),
          // Campo contraseña
          LoginTextField(
            label: l10n.loginFieldPassword,
            hint: l10n.loginFieldPasswordHint,
            prefixIcon: Icons.lock_outline_rounded,
            obscureText: true,
            onChanged: (v) => loginForm.password = v,
            validator: (v) {
              if (v == null || v.isEmpty) return l10n.loginErrPasswordRequired;
              if (v.length < 4) return l10n.loginErrPasswordMin;
              return null;
            },
          ),
          const SizedBox(height: AppDimens.spaceM),
          // Checkbox mantener sesión
          KeepSessionRow(loginForm: loginForm),
          const SizedBox(height: AppDimens.spaceXL),
          // Botón ingresar
          SignInButton(
            loginForm: loginForm,
            authService: authService,
          ),
        ],
      ),
    );
  }
}
