import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/provider/provider.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

/// Pantalla de registro de usuario
class RegisterUserScreen extends StatelessWidget {
  const RegisterUserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: LoginBackgroundWidget(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 250),
              CardContainerWidget(
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      l10n.registerTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 30),
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: const _RegisterForm(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, 'login'),
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primaryButton,
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  l10n.registerHaveAccount,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatelessWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final l10n = AppLocalizations.of(context);

    return Form(
      key: loginForm.formKey,
      child: Column(
        children: [
          InputFieldWidget(
            prefixIcon: Icons.person_outline_rounded,
            labelText: l10n.registerFieldUser,
            hintText: l10n.registerFieldUserHint,
            onChanged: (value) => loginForm.username = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.validatorRequired;
              }
              return value.length < 3 ? l10n.validatorMinLength(3) : null;
            },
          ),
          const SizedBox(height: 20),
          InputFieldWidget(
            prefixIcon: Icons.lock_outline_rounded,
            labelText: l10n.registerFieldPassword,
            hintText: l10n.registerFieldPasswordHint,
            obscureText: true,
            onChanged: (value) => loginForm.password = value,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return l10n.validatorRequired;
              }
              return value.length < 4 ? l10n.validatorMinLength(4) : null;
            },
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: loginForm.isLoading
                  ? null
                  : () => _onRegister(context, loginForm),
              icon: loginForm.isLoading
                  ? const ButtonLoadingIndicator()
                  : const Icon(Icons.app_registration_rounded),
              label:
                  Text(loginForm.isLoading ? l10n.btnSaving : l10n.registerBtn),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryButton,
                foregroundColor: AppTheme.secondary,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onRegister(
      BuildContext context, LoginFormProvider loginForm) async {
    FocusScope.of(context).unfocus();
    if (!loginForm.isValidForm()) return;
    Navigator.pushReplacementNamed(context, 'home');
  }
}
