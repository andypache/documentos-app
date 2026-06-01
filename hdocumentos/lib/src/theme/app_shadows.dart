import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_colors.dart';

/// Sombras estandarizadas de la aplicación
/// Proporciona BoxShadow consistentes para diferentes elevaciones
class AppShadows {
  // ============ ELEVATION SHADOWS ============

  /// Sin sombra
  static List<BoxShadow> get none => [];

  /// Sombra baja - Para elementos sutilmente elevados
  static List<BoxShadow> get low => [
        BoxShadow(
          color: AppColors.black.withOpacity(0.08),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  /// Sombra media - Para cards y elementos elevados
  static List<BoxShadow> get medium => [
        BoxShadow(
          color: AppColors.black.withOpacity(0.12),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: AppColors.black.withOpacity(0.06),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];

  /// Sombra alta - Para elementos flotantes (FABs, dialogs)
  static List<BoxShadow> get high => [
        BoxShadow(
          color: AppColors.black.withOpacity(0.16),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: AppColors.black.withOpacity(0.08),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  /// Sombra muy alta - Para modals y overlays
  static List<BoxShadow> get veryHigh => [
        BoxShadow(
          color: AppColors.black.withOpacity(0.2),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
        BoxShadow(
          color: AppColors.black.withOpacity(0.12),
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ];

  // ============ COLORED SHADOWS ============

  /// Sombra con color primario - Para botones y elementos destacados
  static List<BoxShadow> primary({double opacity = 0.3}) => [
        BoxShadow(
          color: AppColors.primary.withOpacity(opacity),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// Sombra con color accent - Para elementos de acción
  static List<BoxShadow> accent({double opacity = 0.3}) => [
        BoxShadow(
          color: AppColors.accent.withOpacity(opacity),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  /// Sombra de éxito
  static List<BoxShadow> success({double opacity = 0.25}) => [
        BoxShadow(
          color: AppColors.success.withOpacity(opacity),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ];

  /// Sombra de error
  static List<BoxShadow> error({double opacity = 0.25}) => [
        BoxShadow(
          color: AppColors.error.withOpacity(opacity),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ];

  /// Sombra de advertencia
  static List<BoxShadow> warning({double opacity = 0.25}) => [
        BoxShadow(
          color: AppColors.warning.withOpacity(opacity),
          blurRadius: 8,
          offset: const Offset(0, 3),
        ),
      ];

  // ============ SPECIALIZED SHADOWS ============

  /// Sombra interna - Para elementos empotrados
  static List<BoxShadow> get inner => [
        BoxShadow(
          color: AppColors.black.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
          spreadRadius: -2,
        ),
      ];

  /// Sombra suave difuminada - Para fondos
  static List<BoxShadow> get soft => [
        BoxShadow(
          color: AppColors.black.withOpacity(0.05),
          blurRadius: 20,
          offset: const Offset(0, 10),
          spreadRadius: -5,
        ),
      ];

  /// Sombra de card elevado
  static List<BoxShadow> get card => [
        BoxShadow(
          color: AppColors.black.withOpacity(0.1),
          blurRadius: 10,
          offset: const Offset(0, 5),
          spreadRadius: 0,
        ),
      ];

  /// Sombra de botón presionado
  static List<BoxShadow> get pressed => [
        BoxShadow(
          color: AppColors.black.withOpacity(0.15),
          blurRadius: 2,
          offset: const Offset(0, 1),
        ),
      ];

  // ============ HELPER METHODS ============

  /// Crea una sombra personalizada
  static List<BoxShadow> custom({
    required Color color,
    required double blurRadius,
    required Offset offset,
    double spreadRadius = 0,
    double opacity = 1.0,
  }) =>
      [
        BoxShadow(
          color: color.withOpacity(opacity),
          blurRadius: blurRadius,
          offset: offset,
          spreadRadius: spreadRadius,
        ),
      ];

  /// Combina múltiples listas de sombras
  static List<BoxShadow> combine(List<List<BoxShadow>> shadows) {
    return shadows.expand((shadow) => shadow).toList();
  }
}
