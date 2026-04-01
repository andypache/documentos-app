import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/provider/form/login_form_provider.dart';
import 'package:hdocumentos/src/provider/provider.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/share/preference.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
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
    final l10n = AppLocalizations.of(context);
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width > 480 ? 420 : double.infinity,
      decoration: BoxDecoration(
        color: AppTheme.loginCardBg,
        borderRadius: BorderRadius.circular(20),
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
          // ── Cabecera ──────────────────────────────────────────────────────
          _LoginHeader(l10n: l10n),
          // ── Divisor ───────────────────────────────────────────────────────
          const Divider(
            height: 1,
            thickness: 1,
            color: AppTheme.loginDivider,
          ),
          // ── Formulario ────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 28, 28, 20),
            child: _LoginForm(l10n: l10n),
          ),
          // ── Enlace registro ───────────────────────────────────────────────
          _RegisterLink(l10n: l10n),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Cabecera ──────────────────────────────────────────────────────────────────

class _LoginHeader extends StatelessWidget {
  const _LoginHeader({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
      child: Column(
        children: [
          // ── Selector de idioma alineado a la derecha ──────────────────────
          const Align(
            alignment: Alignment.centerRight,
            child: LanguageSelectorWidget(),
          ),
          const SizedBox(height: 16),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppTheme.primary,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppTheme.primaryButton.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              color: AppTheme.primaryButton,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.loginTitle,
            style: const TextStyle(
              color: AppTheme.white,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.loginSubtitle,
            style: TextStyle(
              color: AppTheme.white.withOpacity(0.55),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Formulario ────────────────────────────────────────────────────────────────

class _LoginForm extends StatelessWidget {
  const _LoginForm({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final loginForm = Provider.of<LoginFormProvider>(context);
    final authService = Provider.of<AuthService>(context);

    return Form(
      key: loginForm.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Campo usuario
          _LoginTextField(
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
          const SizedBox(height: 16),
          // Campo contraseña
          _LoginTextField(
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
          const SizedBox(height: 12),
          // Checkbox mantener sesión
          _KeepSessionRow(l10n: l10n, loginForm: loginForm),
          const SizedBox(height: 24),
          // Botón ingresar
          _SignInButton(
            l10n: l10n,
            loginForm: loginForm,
            authService: authService,
          ),
        ],
      ),
    );
  }
}

// ── Campo de texto estilo dark ────────────────────────────────────────────────

class _LoginTextField extends StatelessWidget {
  const _LoginTextField({
    required this.label,
    required this.hint,
    required this.prefixIcon,
    required this.onChanged,
    required this.validator,
    this.obscureText = false,
  });

  final String label;
  final String hint;
  final IconData prefixIcon;
  final void Function(String) onChanged;
  final String? Function(String?) validator;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: const TextStyle(color: AppTheme.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: TextStyle(
          color: AppTheme.white.withOpacity(0.6),
          fontSize: 13,
        ),
        hintStyle: TextStyle(
          color: AppTheme.white.withOpacity(0.3),
          fontSize: 13,
        ),
        prefixIcon: Icon(prefixIcon, color: AppTheme.primaryButton, size: 20),
        filled: true,
        fillColor: AppTheme.loginInputFill,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: AppTheme.loginInputBorder.withOpacity(0.7),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(color: AppTheme.primaryButton, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: AppTheme.red, width: 1.5),
        ),
        errorStyle: const TextStyle(color: AppTheme.red, fontSize: 11),
      ),
    );
  }
}

// ── Fila de mantener sesión ───────────────────────────────────────────────────

class _KeepSessionRow extends StatelessWidget {
  const _KeepSessionRow({required this.l10n, required this.loginForm});
  final AppLocalizations l10n;
  final LoginFormProvider loginForm;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => loginForm.keepSession = !loginForm.keepSession,
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: loginForm.keepSession,
              onChanged: (v) => loginForm.keepSession = v ?? false,
              activeColor: AppTheme.primaryButton,
              checkColor: AppTheme.secondary,
              side: const BorderSide(
                color: AppTheme.loginInputBorder,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            l10n.loginKeepSession,
            style: TextStyle(
              color: AppTheme.white.withOpacity(0.65),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Botón de inicio de sesión ─────────────────────────────────────────────────

class _SignInButton extends StatelessWidget {
  const _SignInButton({
    required this.l10n,
    required this.loginForm,
    required this.authService,
  });

  final AppLocalizations l10n;
  final LoginFormProvider loginForm;
  final AuthService authService;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: loginForm.isLoading ? null : () => _onSignIn(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryButton,
          foregroundColor: AppTheme.secondary,
          disabledBackgroundColor: AppTheme.grey,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: loginForm.isLoading
            ? const ButtonLoadingIndicator(size: 20)
            : Text(
                l10n.loginBtnSignIn,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
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
      loginForm.isLoading = false;

      if (response.statusHttp == 200) {
        Preferences.keepSession = loginForm.keepSession;
        navigator.pushReplacementNamed('home');
      } else {
        NotificationService.showError(
          response.error ?? response.message,
          title: l10n.loginTitle,
        );
      }
    } catch (_) {
      loginForm.isLoading = false;
      NotificationService.showError(l10n.loginErrGeneral);
    }
  }
}

// ── Enlace a registro ─────────────────────────────────────────────────────────

class _RegisterLink extends StatelessWidget {
  const _RegisterLink({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => Navigator.pushReplacementNamed(context, 'register'),
      style: TextButton.styleFrom(
        foregroundColor: AppTheme.primaryButton,
      ),
      child: Text(
        l10n.loginRegisterLink,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
