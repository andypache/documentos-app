import 'package:flutter/material.dart';

/// Paleta de colores extendida de la aplicación
/// Centraliza todos los colores para mantener consistencia
class AppColors {
  // ============ BRAND COLORS ============

  /// Color primario principal (#16434D)
  static const Color primary = Color(0xff16434D);

  /// Variante clara del primario
  static const Color primaryLight = Color(0xff1e5a67);

  /// Variante oscura del primario
  static const Color primaryDark = Color(0xff0d2a32);

  /// Color secundario (#202333)
  static const Color secondary = Color(0xff202333);

  /// Variante clara del secundario
  static const Color secondaryLight = Color(0xff2a2d42);

  /// Variante oscura del secundario
  static const Color secondaryDark = Color(0xff16182a);

  // ============ ACCENT COLORS ============

  /// Color de botón primario (#51cbce)
  static const Color accent = Color(0xff51cbce);

  /// Variante del accent
  static const Color accentVariant = Color(0xff51cb90);

  /// Accent con opacidad baja
  static Color get accentLight => accent.withOpacity(0.2);

  /// Accent con opacidad media
  static Color get accentMedium => accent.withOpacity(0.5);

  // ============ SURFACE COLORS ============

  /// Superficie principal
  static const Color surface = Color(0xff202333);

  /// Superficie con elevación
  static const Color surfaceElevated = Color(0xff2a2d42);

  /// Superficie de tarjetas
  static Color get surfaceCard => surface.withOpacity(0.3);

  // ============ STATUS COLORS ============

  /// Color de éxito / confirmación
  static const Color success = Color(0xff51cb90);

  /// Variante clara del success
  static Color get successLight => success.withOpacity(0.2);

  /// Color de advertencia
  static const Color warning = Color(0xffffb74d);

  /// Variante clara del warning
  static Color get warningLight => warning.withOpacity(0.2);

  /// Color de error
  static const Color error = Color(0xfff44336);

  /// Variante clara del error
  static Color get errorLight => error.withOpacity(0.2);

  /// Color de información
  static const Color info = Color(0xff51cbce);

  /// Variante clara del info
  static Color get infoLight => info.withOpacity(0.2);

  // ============ TEXT COLORS ============

  /// Texto principal
  static const Color textPrimary = Colors.white;

  /// Texto secundario
  static Color get textSecondary => Colors.white.withOpacity(0.7);

  /// Texto terciario / hint
  static Color get textTertiary => Colors.white.withOpacity(0.5);

  /// Texto deshabilitado
  static Color get textDisabled => Colors.white.withOpacity(0.3);

  // ============ SPECIFIC USE CASES ============

  /// Color para totales y montos
  static const Color money = Colors.greenAccent;

  /// Color para descuentos de productos
  static const Color discountProduct = Colors.amberAccent;

  /// Color para descuentos de clientes
  static const Color discountCustomer = Colors.orangeAccent;

  /// Color para descuentos totales
  static const Color discountTotal = Colors.deepOrangeAccent;

  /// Color para impuestos
  static const Color tax = Colors.lightBlueAccent;

  /// Color para servicios
  static const Color service = Colors.blue;

  /// Color para productos
  static const Color product = Colors.purple;

  // ============ UI ELEMENTS ============

  /// Borde de elementos activos
  static Color get borderActive => accent;

  /// Borde de elementos inactivos
  static Color get borderInactive => Colors.white.withOpacity(0.3);

  /// Fondo de inputs
  static Color get inputBackground => Colors.white.withOpacity(0.1);

  /// Divider
  static Color get divider => Colors.white.withOpacity(0.1);

  /// Overlay / Scrim
  static Color get overlay => Colors.black.withOpacity(0.5);

  /// Shimmer base
  static Color get shimmerBase => Colors.grey[300]!;

  /// Shimmer highlight
  static Color get shimmerHighlight => Colors.grey[100]!;

  // ============ GRADIENTS ============

  /// Gradiente primario
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [secondary, primary],
  );

  /// Gradiente de botón
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentVariant],
  );

  // ============ LEGACY COMPATIBILITY ============
  // Mantener para compatibilidad con código existente

  static const Color primaryButton = accent;
  static const Color secondaryButton = accentVariant;
  static const Color white = Colors.white;
  static const Color blue = Colors.blue;
  static const Color pinkAccent = Colors.pinkAccent;
  static const Color black = Colors.black;
  static const Color grey = Colors.grey;
  static const Color pink = Colors.pink;
  static const Color red = Colors.red;
  static const Color transparent = Colors.transparent;
  static const Color notificationWarning = warning;
  static const Color notificationSuccess = success;
  static const Color notificationError = error;
  static const Color primaryGradientLegacy = Color.fromRGBO(236, 98, 188, 1);
  static const Color secondaryGradient = Color.fromRGBO(251, 142, 172, 1);
  static const Color whiteGradient = Color.fromRGBO(255, 255, 255, 0.1);
  static const Color targetGradient = Color.fromRGBO(62, 66, 107, 0.7);
  static const Color primaryBottomGradient = Color.fromRGBO(55, 57, 84, 1);
  static const Color secondaryBottomGradient = Color.fromRGBO(116, 117, 152, 1);

  // ============ HELPER METHODS ============

  /// Aplica opacidad a un color
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Obtiene un color basado en el estado de éxito/error
  static Color getStatusColor(bool isSuccess) {
    return isSuccess ? success : error;
  }

  /// Obtiene un color de texto basado en el fondo
  static Color getTextColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
