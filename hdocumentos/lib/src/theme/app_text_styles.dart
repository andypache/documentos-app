import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_colors.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';

/// Estilos de texto estandarizados de la aplicación
/// Centraliza todos los TextStyles para mantener consistencia
class AppTextStyles {
  // ============ DISPLAY STYLES ============

  /// Display grande - Para títulos principales de pantalla
  static TextStyle displayLarge({Color? color}) => TextStyle(
        fontSize: AppDimens.fontDisplay,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
        letterSpacing: -0.5,
      );

  /// Display mediano
  static TextStyle displayMedium({Color? color}) => TextStyle(
        fontSize: AppDimens.fontHeadingL,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
        letterSpacing: -0.25,
      );

  /// Display pequeño
  static TextStyle displaySmall({Color? color}) => TextStyle(
        fontSize: AppDimens.fontHeadingM,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
      );

  // ============ HEADING STYLES ============

  /// Heading 1 - Títulos de secciones principales
  static TextStyle h1({Color? color}) => TextStyle(
        fontSize: AppDimens.fontHeadingL,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
      );

  /// Heading 2 - Subtítulos importantes
  static TextStyle h2({Color? color}) => TextStyle(
        fontSize: AppDimens.fontHeadingM,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
      );

  /// Heading 3 - Subtítulos medianos
  static TextStyle h3({Color? color}) => TextStyle(
        fontSize: AppDimens.fontHeadingS,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  /// Heading 4 - Títulos pequeños
  static TextStyle h4({Color? color}) => TextStyle(
        fontSize: AppDimens.fontTitle,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
      );

  // ============ BODY STYLES ============

  /// Body large - Texto principal grande
  static TextStyle bodyLarge({Color? color}) => TextStyle(
        fontSize: AppDimens.fontBodyLarge,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textPrimary,
        height: 1.5,
      );

  /// Body medium - Texto principal estándar
  static TextStyle bodyMedium({Color? color}) => TextStyle(
        fontSize: AppDimens.fontBody,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textPrimary,
        height: 1.5,
      );

  /// Body small - Texto principal pequeño
  static TextStyle bodySmall({Color? color}) => TextStyle(
        fontSize: AppDimens.fontSmall,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textSecondary,
        height: 1.4,
      );

  // ============ LABEL STYLES ============

  /// Label large - Etiquetas grandes (botones, tabs)
  static TextStyle labelLarge({Color? color}) => TextStyle(
        fontSize: AppDimens.fontBody,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  /// Label medium - Etiquetas medianas
  static TextStyle labelMedium({Color? color}) => TextStyle(
        fontSize: AppDimens.fontSmall,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  /// Label small - Etiquetas pequeñas
  static TextStyle labelSmall({Color? color}) => TextStyle(
        fontSize: AppDimens.fontCaption,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textSecondary,
        letterSpacing: 0.5,
      );

  // ============ SPECIALIZED STYLES ============

  /// Caption - Texto auxiliar muy pequeño
  static TextStyle caption({Color? color}) => TextStyle(
        fontSize: AppDimens.fontCaption,
        fontWeight: FontWeight.normal,
        color: color ?? AppColors.textTertiary,
        height: 1.3,
      );

  /// Overline - Texto de categoría/sobretítulo
  static TextStyle overline({Color? color}) => TextStyle(
        fontSize: AppDimens.fontCaption,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textSecondary,
        letterSpacing: 1.5,
      );

  /// Subtitle 1 - Subtítulos grandes
  static TextStyle subtitle1({Color? color}) => TextStyle(
        fontSize: AppDimens.fontSubtitle,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textPrimary,
        height: 1.4,
      );

  /// Subtitle 2 - Subtítulos medianos
  static TextStyle subtitle2({Color? color}) => TextStyle(
        fontSize: AppDimens.fontBody,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textSecondary,
        height: 1.4,
      );

  // ============ BUTTON STYLES ============

  /// Button - Texto de botones
  static TextStyle button({Color? color}) => TextStyle(
        fontSize: AppDimens.fontBody,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
        letterSpacing: 0.75,
      );

  /// Button large - Botones grandes
  static TextStyle buttonLarge({Color? color}) => TextStyle(
        fontSize: AppDimens.fontBodyLarge,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textPrimary,
        letterSpacing: 0.75,
      );

  /// Button small - Botones pequeños
  static TextStyle buttonSmall({Color? color}) => TextStyle(
        fontSize: AppDimens.fontSmall,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
        letterSpacing: 0.5,
      );

  // ============ MONEY/NUMERIC STYLES ============

  /// Money - Estilo para cantidades monetarias
  static TextStyle money({Color? color, FontWeight? fontWeight}) => TextStyle(
        fontSize: AppDimens.fontBodyLarge,
        fontWeight: fontWeight ?? FontWeight.bold,
        color: color ?? AppColors.money,
        fontFeatures: [FontFeature.tabularFigures()],
      );

  /// Money large - Cantidades monetarias grandes
  static TextStyle moneyLarge({Color? color}) => TextStyle(
        fontSize: AppDimens.fontTitle,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.money,
        fontFeatures: [FontFeature.tabularFigures()],
      );

  /// Money small - Cantidades monetarias pequeñas
  static TextStyle moneySmall({Color? color}) => TextStyle(
        fontSize: AppDimens.fontBody,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.money,
        fontFeatures: [FontFeature.tabularFigures()],
      );

  // ============ STATUS STYLES ============

  /// Success - Texto de éxito
  static TextStyle success({double? fontSize}) => TextStyle(
        fontSize: fontSize ?? AppDimens.fontBody,
        fontWeight: FontWeight.w600,
        color: AppColors.success,
      );

  /// Error - Texto de error
  static TextStyle error({double? fontSize}) => TextStyle(
        fontSize: fontSize ?? AppDimens.fontBody,
        fontWeight: FontWeight.w600,
        color: AppColors.error,
      );

  /// Warning - Texto de advertencia
  static TextStyle warning({double? fontSize}) => TextStyle(
        fontSize: fontSize ?? AppDimens.fontBody,
        fontWeight: FontWeight.w600,
        color: AppColors.warning,
      );

  /// Info - Texto informativo
  static TextStyle info({double? fontSize}) => TextStyle(
        fontSize: fontSize ?? AppDimens.fontBody,
        fontWeight: FontWeight.w600,
        color: AppColors.info,
      );

  // ============ HELPER METHODS ============

  /// Aplica bold a cualquier TextStyle
  static TextStyle bold(TextStyle style) => style.copyWith(
        fontWeight: FontWeight.bold,
      );

  /// Aplica italic a cualquier TextStyle
  static TextStyle italic(TextStyle style) => style.copyWith(
        fontStyle: FontStyle.italic,
      );

  /// Aplica underline a cualquier TextStyle
  static TextStyle underline(TextStyle style) => style.copyWith(
        decoration: TextDecoration.underline,
      );

  /// Cambia el color de un TextStyle
  static TextStyle withColor(TextStyle style, Color color) => style.copyWith(
        color: color,
      );

  /// Cambia el tamaño de un TextStyle
  static TextStyle withSize(TextStyle style, double size) => style.copyWith(
        fontSize: size,
      );

  /// Cambia el peso de un TextStyle
  static TextStyle withWeight(TextStyle style, FontWeight weight) =>
      style.copyWith(
        fontWeight: weight,
      );
}
