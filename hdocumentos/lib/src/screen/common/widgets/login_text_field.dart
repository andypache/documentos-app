import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Campo de texto estilizado para el formulario de login
class LoginTextField extends StatelessWidget {
  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;

  const LoginTextField({
    Key? key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.white,
            fontSize: AppDimens.fontSmall,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppDimens.spaceXS),
        TextFormField(
          obscureText: obscureText,
          onChanged: onChanged,
          validator: validator,
          style: const TextStyle(
            color: AppTheme.white,
            fontSize: AppDimens.fontBody,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: AppTheme.white.withOpacity(0.35),
              fontSize: AppDimens.fontBody,
            ),
            prefixIcon: Icon(
              prefixIcon,
              color: AppTheme.loginInputBorder,
              size: AppDimens.iconS,
            ),
            filled: true,
            fillColor: AppTheme.loginInputFill,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppDimens.paddingM,
              vertical: AppDimens.paddingM,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
              borderSide: const BorderSide(
                color: AppTheme.loginInputBorder,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
              borderSide: const BorderSide(
                color: AppTheme.primaryButton,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
              borderSide: const BorderSide(
                color: AppTheme.actionDanger,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimens.radiusM),
              borderSide: const BorderSide(
                color: AppTheme.actionDanger,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
