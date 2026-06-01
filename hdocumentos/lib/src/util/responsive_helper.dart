import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Utility para manejo responsive de la UI
/// Detecta tamaño de pantalla, orientación y proporciona helpers
class ResponsiveHelper {
  final BuildContext context;
  late final MediaQueryData _mediaQuery;
  late final Size _screenSize;
  late final Orientation _orientation;

  ResponsiveHelper(this.context) {
    _mediaQuery = MediaQuery.of(context);
    _screenSize = _mediaQuery.size;
    _orientation = _mediaQuery.orientation;
  }

  // ============ BREAKPOINTS ============

  /// Breakpoints estándar para diseño responsive
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 900;
  static const double desktopBreakpoint = 1200;
  static const double largeDesktopBreakpoint = 1800;

  // ============ TIPOS DE DISPOSITIVO ============

  /// Es un dispositivo móvil (< 600dp)
  bool get isMobile => _screenSize.width < mobileBreakpoint;

  /// Es una tablet (600-900dp)
  bool get isTablet =>
      _screenSize.width >= mobileBreakpoint &&
      _screenSize.width < tabletBreakpoint;

  /// Es un desktop (> 900dp)
  bool get isDesktop => _screenSize.width >= tabletBreakpoint;

  /// Es un desktop grande (> 1200dp)
  bool get isLargeDesktop => _screenSize.width >= desktopBreakpoint;

  /// Es un desktop extra grande (> 1800dp)
  bool get isXLargeDesktop => _screenSize.width >= largeDesktopBreakpoint;

  // ============ ORIENTACIÓN ============

  /// Está en modo portrait (vertical)
  bool get isPortrait => _orientation == Orientation.portrait;

  /// Está en modo landscape (horizontal)
  bool get isLandscape => _orientation == Orientation.landscape;

  // ============ DIMENSIONES ============

  /// Ancho de la pantalla
  double get screenWidth => _screenSize.width;

  /// Alto de la pantalla
  double get screenHeight => _screenSize.height;

  /// Dimensión más pequeña
  double get shortestSide => _screenSize.shortestSide;

  /// Dimensión más grande
  double get longestSide => _screenSize.longestSide;

  /// Diagonal de la pantalla (en dp)
  double get diagonal =>
      math.sqrt(math.pow(screenWidth, 2) + math.pow(screenHeight, 2));

  // ============ PADDING/INSETS ============

  /// Padding seguro del sistema (notch, status bar, etc)
  EdgeInsets get safeAreaPadding => _mediaQuery.padding;

  /// Padding seguro inferior (para navegación)
  double get safeAreaBottom => _mediaQuery.padding.bottom;

  /// Padding seguro superior (para status bar)
  double get safeAreaTop => _mediaQuery.padding.top;

  // ============ SCALING ============

  /// Factor de escala de texto del sistema
  double get textScaleFactor => _mediaQuery.textScaleFactor;

  /// Ancho escalado según el diseño base (375dp - iPhone)
  double scaleWidth(double size) => size * (screenWidth / 375);

  /// Alto escalado según el diseño base (812dp - iPhone X)
  double scaleHeight(double size) => size * (screenHeight / 812);

  /// Escala proporcional (usa el menor entre ancho y alto)
  double scale(double size) =>
      size * math.min(screenWidth / 375, screenHeight / 812);

  // ============ HELPERS RESPONSIVOS ============

  /// Obtener valor según el tipo de dispositivo
  T valueWhen<T>({
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    if (isLargeDesktop && largeDesktop != null) return largeDesktop;
    if (isDesktop && desktop != null) return desktop;
    if (isTablet && tablet != null) return tablet;
    return mobile;
  }

  /// Padding responsivo horizontal
  double get paddingHorizontal => valueWhen(
        mobile: 16.0,
        tablet: 24.0,
        desktop: 32.0,
        largeDesktop: 48.0,
      );

  /// Padding responsivo vertical
  double get paddingVertical => valueWhen(
        mobile: 16.0,
        tablet: 20.0,
        desktop: 24.0,
        largeDesktop: 32.0,
      );

  /// Tamaño de fuente responsivo para título
  double get titleFontSize => valueWhen(
        mobile: 24.0,
        tablet: 28.0,
        desktop: 32.0,
        largeDesktop: 36.0,
      );

  /// Tamaño de fuente responsivo para subtítulo
  double get subtitleFontSize => valueWhen(
        mobile: 18.0,
        tablet: 20.0,
        desktop: 22.0,
        largeDesktop: 24.0,
      );

  /// Tamaño de fuente responsivo para cuerpo
  double get bodyFontSize => valueWhen(
        mobile: 14.0,
        tablet: 15.0,
        desktop: 16.0,
        largeDesktop: 17.0,
      );

  /// Tamaño de fuente responsivo para caption
  double get captionFontSize => valueWhen(
        mobile: 12.0,
        tablet: 13.0,
        desktop: 14.0,
        largeDesktop: 15.0,
      );

  /// Número de columnas en grid según dispositivo
  int get gridColumns => valueWhen(
        mobile: 2,
        tablet: 3,
        desktop: 4,
        largeDesktop: 6,
      );

  /// Máximo ancho para contenido centrado (como formularios)
  double get maxContentWidth => valueWhen(
        mobile: double.infinity,
        tablet: 600.0,
        desktop: 800.0,
        largeDesktop: 1000.0,
      );

  // ============ MÉTODOS ESTÁTICOS ============

  /// Obtener ResponsiveHelper desde contexto
  static ResponsiveHelper of(BuildContext context) => ResponsiveHelper(context);

  /// Verificar si es móvil sin contexto (usando ancho)
  static bool isMobileWidth(double width) => width < mobileBreakpoint;

  /// Verificar si es tablet sin contexto
  static bool isTabletWidth(double width) =>
      width >= mobileBreakpoint && width < tabletBreakpoint;

  /// Verificar si es desktop sin contexto
  static bool isDesktopWidth(double width) => width >= tabletBreakpoint;

  // ============ LAYOUT BUILDERS ============

  /// Widget builder responsivo simplificado
  static Widget builder({
    required BuildContext context,
    required Widget mobile,
    Widget? tablet,
    Widget? desktop,
  }) {
    final responsive = ResponsiveHelper(context);

    if (responsive.isDesktop && desktop != null) {
      return desktop;
    }
    if (responsive.isTablet && tablet != null) {
      return tablet;
    }
    return mobile;
  }

  /// Value builder responsivo
  static T value<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? desktop,
    T? largeDesktop,
  }) {
    return ResponsiveHelper(context).valueWhen(
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
      largeDesktop: largeDesktop,
    );
  }
}

/// Extension para acceso rápido a ResponsiveHelper
extension ResponsiveExtension on BuildContext {
  ResponsiveHelper get responsive => ResponsiveHelper(this);
}
