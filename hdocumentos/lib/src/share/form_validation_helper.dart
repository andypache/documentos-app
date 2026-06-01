import 'package:flutter/material.dart';
import 'package:hdocumentos/src/exception/app_exceptions.dart';

/// Helper para validaciones de formularios que lanzan ValidationException
/// cuando hay errores, en lugar de solo retornar strings
class FormValidationHelper {
  /// Valida un formulario y lanza ValidationException si hay errores
  ///
  /// Uso:
  /// ```dart
  /// try {
  ///   FormValidationHelper.validateForm(
  ///     formKey: _formKey,
  ///     formName: 'Datos del cliente',
  ///   );
  ///   // Continuar con el guardado...
  /// } on ValidationException catch (e) {
  ///   ErrorHandler.handleError(e);
  /// }
  /// ```
  static void validateForm({
    required GlobalKey<FormState> formKey,
    required String formName,
  }) {
    if (formKey.currentState == null) {
      throw ValidationException(
        message: 'El formulario "$formName" no está inicializado',
        code: 'FORM_NOT_INITIALIZED',
      );
    }

    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      throw ValidationException(
        message:
            'Por favor, completa todos los campos requeridos en "$formName"',
        code: 'FORM_VALIDATION_FAILED',
      );
    }
  }

  /// Valida un campo específico y lanza ValidationException si es inválido
  ///
  /// Uso:
  /// ```dart
  /// FormValidationHelper.validateField(
  ///   value: email,
  ///   fieldName: 'Email',
  ///   validators: [
  ///     (v) => v.isEmpty ? 'Email es requerido' : null,
  ///     (v) => !v.contains('@') ? 'Email inválido' : null,
  ///   ],
  /// );
  /// ```
  static void validateField({
    required String? value,
    required String fieldName,
    required List<FormFieldValidator<String>> validators,
  }) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) {
        throw ValidationException.invalidData(fieldName, error);
      }
    }
  }

  /// Valida múltiples campos y recopila todos los errores
  ///
  /// Uso:
  /// ```dart
  /// FormValidationHelper.validateFields({
  ///   'Nombre': (name.isEmpty, 'El nombre es requerido'),
  ///   'Email': (!email.contains('@'), 'Email inválido'),
  ///   'Teléfono': (phone.length < 10, 'Teléfono debe tener 10 dígitos'),
  /// });
  /// ```
  static void validateFields(
      Map<String, (bool hasError, String message)> fieldChecks) {
    final errors = <String, String>{};

    fieldChecks.forEach((fieldName, check) {
      if (check.$1) {
        // check.$1 es hasError (bool)
        errors[fieldName] = check.$2; // check.$2 es message (String)
      }
    });

    if (errors.isNotEmpty) {
      throw ValidationException(
        message: 'Errores en la validación del formulario',
        code: 'MULTIPLE_VALIDATION_ERRORS',
        fieldErrors: errors,
      );
    }
  }

  /// Valida campos requeridos (no null, no vacío, no solo espacios)
  ///
  /// Uso:
  /// ```dart
  /// FormValidationHelper.validateRequiredFields({
  ///   'Nombre': firstName,
  ///   'Apellido': lastName,
  ///   'Email': email,
  /// });
  /// ```
  static void validateRequiredFields(Map<String, String?> fields) {
    final errors = <String, String>{};

    fields.forEach((fieldName, value) {
      if (value == null || value.trim().isEmpty) {
        errors[fieldName] = 'El campo $fieldName es requerido';
      }
    });

    if (errors.isNotEmpty) {
      throw ValidationException(
        message: 'Campos requeridos faltantes',
        code: 'REQUIRED_FIELDS_MISSING',
        fieldErrors: errors,
      );
    }
  }

  /// Valida que un valor numérico esté en un rango
  static void validateRange({
    required num? value,
    required String fieldName,
    num? min,
    num? max,
  }) {
    if (value == null) {
      throw ValidationException.requiredField(fieldName);
    }

    if (min != null && value < min) {
      throw ValidationException.invalidData(
        fieldName,
        'El valor debe ser mayor o igual a $min',
      );
    }

    if (max != null && value > max) {
      throw ValidationException.invalidData(
        fieldName,
        'El valor debe ser menor o igual a $max',
      );
    }
  }

  /// Valida que un string tenga una longitud específica
  static void validateLength({
    required String? value,
    required String fieldName,
    int? minLength,
    int? maxLength,
    int? exactLength,
  }) {
    if (value == null || value.trim().isEmpty) {
      throw ValidationException.requiredField(fieldName);
    }

    final length = value.trim().length;

    if (exactLength != null && length != exactLength) {
      throw ValidationException.invalidData(
        fieldName,
        'Debe tener exactamente $exactLength caracteres',
      );
    }

    if (minLength != null && length < minLength) {
      throw ValidationException.invalidData(
        fieldName,
        'Debe tener al menos $minLength caracteres',
      );
    }

    if (maxLength != null && length > maxLength) {
      throw ValidationException.invalidData(
        fieldName,
        'Debe tener máximo $maxLength caracteres',
      );
    }
  }

  /// Valida formato de email
  static void validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      throw ValidationException.requiredField('Email');
    }

    final regex = RegExp(r'^[\w\.\+\-]+@[\w\-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(email.trim())) {
      throw ValidationException.invalidData(
          'Email', 'Formato de email inválido');
    }
  }

  /// Valida que un objeto no sea null
  static T validateNotNull<T>({
    required T? value,
    required String fieldName,
    String? customMessage,
  }) {
    if (value == null) {
      throw ValidationException(
        message: customMessage ?? 'El campo $fieldName es requerido',
        code: 'NULL_VALUE',
        fieldErrors: {fieldName: customMessage ?? 'Valor no puede ser nulo'},
      );
    }
    return value;
  }
}
