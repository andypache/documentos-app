import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:intl/intl.dart' as intl;

/// Utilidad centralizada de validaciones para campos de formulario.
///
/// Uso en un [TextFormField] o [InputFieldWidget]:
/// ```dart
/// validator: FieldValidators.compose([
///   FieldValidators.required(l10n),
///   FieldValidators.email(l10n),
/// ]),
/// ```
abstract class FieldValidators {
  FieldValidators._();

  // ─── Primitivos ──────────────────────────────────────────────────────────

  /// Campo obligatorio — rechaza null, vacío o solo espacios.
  static FormFieldValidator<String> required(AppLocalizations l10n) {
    return (v) =>
        (v == null || v.trim().isEmpty) ? l10n.validatorRequired : null;
  }

  /// Longitud mínima de caracteres (sin contar espacios extremos).
  static FormFieldValidator<String> minLength(AppLocalizations l10n, int min) {
    return (v) {
      if (v == null || v.trim().isEmpty) return null; // required lo maneja
      return v.trim().length < min ? l10n.validatorMinLength(min) : null;
    };
  }

  /// Longitud máxima de caracteres.
  static FormFieldValidator<String> maxLength(AppLocalizations l10n, int max) {
    return (v) {
      if (v == null || v.trim().isEmpty) return null;
      return v.trim().length > max ? l10n.validatorMaxLength(max) : null;
    };
  }

  /// Longitud exacta de caracteres (útil para RUC, códigos, etc.).
  static FormFieldValidator<String> exactLength(
      AppLocalizations l10n, int length) {
    return (v) {
      if (v == null || v.trim().isEmpty) return null;
      return v.trim().length != length
          ? l10n.validatorExactLength(length)
          : null;
    };
  }

  // ─── Formato ─────────────────────────────────────────────────────────────

  /// Correo electrónico válido.
  static FormFieldValidator<String> email(AppLocalizations l10n) {
    return (v) {
      if (v == null || v.trim().isEmpty) return null;
      final regex = RegExp(r'^[\w\.\+\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
      return regex.hasMatch(v.trim()) ? null : l10n.validatorEmail;
    };
  }

  /// Solo dígitos numéricos (sin puntos ni comas).
  static FormFieldValidator<String> numeric(AppLocalizations l10n) {
    return (v) {
      if (v == null || v.trim().isEmpty) return null;
      return RegExp(r'^\d+$').hasMatch(v.trim()) ? null : l10n.validatorNumeric;
    };
  }

  static FormFieldValidator<String> minValue(AppLocalizations l10n, int min) {
    return (v) {
      if (v == null || v.trim().isEmpty) return null;
      final n = num.tryParse(v.trim());
      return (n != null && n >= min) ? null : l10n.validatorMinValue(min);
    };
  }

  static FormFieldValidator<String> decimal(AppLocalizations l10n) {
    return (v) {
      if (v == null || v.trim().isEmpty) return null;
      return RegExp(r'^\d+(\.\d+)?$').hasMatch(v.trim())
          ? null
          : l10n.validatorDecimal;
    };
  }

  /// Solo letras y números (con caracteres especiales).
  static FormFieldValidator<String> alphanumeric(AppLocalizations l10n) {
    return (v) {
      if (v == null || v.trim().isEmpty) return null;
      return RegExp(r'^[a-zA-Z0-9\sáéíóúÁÉÍÓÚñÑüÜ .,]+$').hasMatch(v.trim())
          ? null
          : l10n.validatorAlphanumeric;
    };
  }

  /// Solo letras y números (sin caracteres especiales).
  static FormFieldValidator<String> alphanumericBasic(AppLocalizations l10n) {
    return (v) {
      if (v == null || v.trim().isEmpty) return null;
      return RegExp(r'^[a-zA-Z0-9\s]+$').hasMatch(v.trim())
          ? null
          : l10n.validatorAlphanumericBasic;
    };
  }

  /// Teléfono: dígitos, espacios, +, -, ( ) permitidos.
  static FormFieldValidator<String> phone(AppLocalizations l10n) {
    return (v) {
      if (v == null || v.trim().isEmpty) return null;
      return RegExp(r'^[\d\s\+\-\(\)]{7,15}$').hasMatch(v.trim())
          ? null
          : l10n.validatorPhone;
    };
  }

  /// URL válida (http o https).
  static FormFieldValidator<String> url(AppLocalizations l10n) {
    return (v) {
      if (v == null || v.trim().isEmpty) return null;
      final regex =
          RegExp(r'^https?:\/\/([\w\-]+\.)+[\w\-]+(\/[\w\-\.\/?%&=]*)?$');
      return regex.hasMatch(v.trim()) ? null : l10n.validatorUrl;
    };
  }

  static FormFieldValidator<String> moreThanCurrentDate(AppLocalizations l10n) {
    return (v) {
      if (v == null || v.trim().isEmpty) return null;
      try {
        final inputDate = intl.DateFormat('dd/MM/yyyy').parseStrict(v.trim());
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        return inputDate.isAfter(today) ? null : l10n.validatorDateMustBeFuture;
      } catch (_) {
        return l10n.validatorInvalidDate;
      }
    };
  }

  /// Puerto de red: número entre 1 y 65535.
  static FormFieldValidator<String> port(AppLocalizations l10n) {
    return (v) {
      if (v == null || v.trim().isEmpty) return null;
      final n = int.tryParse(v.trim());
      return (n != null && n >= 1 && n <= 65535) ? null : l10n.validatorPort;
    };
  }

  /// Sin espacios al inicio o al final.
  static FormFieldValidator<String> noLeadingTrailingSpaces(
      AppLocalizations l10n) {
    return (v) {
      if (v == null || v.isEmpty) return null;
      return v != v.trim() ? l10n.validatorNoSpaces : null;
    };
  }

  // ─── Compositor ──────────────────────────────────────────────────────────

  /// Ejecuta múltiples validadores en orden y retorna el primer error.
  ///
  /// ```dart
  /// validator: FieldValidators.compose([
  ///   FieldValidators.required(l10n),
  ///   FieldValidators.minLength(l10n, 3),
  ///   FieldValidators.alphanumeric(l10n),
  /// ]),
  /// ```
  static FormFieldValidator<String> compose(
      List<FormFieldValidator<String>> validators) {
    return (v) {
      for (final validate in validators) {
        final error = validate(v);
        if (error != null) return error;
      }
      return null;
    };
  }
}
