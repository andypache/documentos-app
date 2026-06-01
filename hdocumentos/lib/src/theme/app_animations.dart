import 'package:flutter/widgets.dart';

/// Duraciones y curvas de animación estandarizadas de la aplicación
/// Proporciona constantes consistentes para animaciones y transiciones
class AppAnimations {
  // ============ DURACIONES ============

  /// Animación instantánea (100ms) - Para feedback inmediato
  static const Duration instant = Duration(milliseconds: 100);

  /// Animación rápida (200ms) - Para microinteracciones
  static const Duration fast = Duration(milliseconds: 200);

  /// Animación normal (300ms) - Duración estándar para la mayoría de animaciones
  static const Duration normal = Duration(milliseconds: 300);

  /// Animación lenta (500ms) - Para transiciones complejas
  static const Duration slow = Duration(milliseconds: 500);

  /// Animación muy lenta (800ms) - Para efectos dramáticos
  static const Duration verySlow = Duration(milliseconds: 800);

  // ============ DURACIONES ESPECÍFICAS ============

  /// Duración para fade de diálogos
  static const Duration dialogFade = Duration(milliseconds: 200);

  /// Duración para transiciones de página
  static const Duration pageTransition = Duration(milliseconds: 300);

  /// Duración para slide de bottom sheets
  static const Duration bottomSheetSlide = Duration(milliseconds: 250);

  /// Duración para expansión de tiles
  static const Duration tileExpansion = Duration(milliseconds: 200);

  /// Duración para ripple effects
  static const Duration ripple = Duration(milliseconds: 300);

  /// Duración para snackbars
  static const Duration snackbarSlide = Duration(milliseconds: 250);

  /// Duración para tooltips
  static const Duration tooltipFade = Duration(milliseconds: 150);

  /// Duración para hover effects
  static const Duration hover = Duration(milliseconds: 150);

  /// Duración para rotaciones
  static const Duration rotation = Duration(milliseconds: 400);

  /// Duración para scale effects
  static const Duration scale = Duration(milliseconds: 200);

  // ============ CURVAS BÁSICAS ============

  /// Curva ease in - Aceleración gradual
  static const Curve easeIn = Curves.easeIn;

  /// Curva ease out - Desaceleración gradual
  static const Curve easeOut = Curves.easeOut;

  /// Curva ease in-out - Aceleración y desaceleración gradual
  static const Curve easeInOut = Curves.easeInOut;

  /// Curva linear - Sin aceleración
  static const Curve linear = Curves.linear;

  // ============ CURVAS MATERIAL ============

  /// Curva estándar de Material Design
  static const Curve materialStandard = Curves.easeInOut;

  /// Curva de aceleración de Material Design
  static const Curve materialAccelerate = Curves.easeIn;

  /// Curva de desaceleración de Material Design
  static const Curve materialDecelerate = Curves.easeOut;

  /// Curva elástica de Material Design
  static const Curve materialElastic = Curves.elasticOut;

  // ============ CURVAS ESPECIALIZADAS ============

  /// Curva bounce - Efecto de rebote
  static const Curve bounce = Curves.bounceOut;

  /// Curva elastic - Efecto elástico
  static const Curve elastic = Curves.elasticOut;

  /// Curva emphasized - Mayor énfasis al final
  static const Curve emphasized = Curves.easeOutCubic;

  /// Curva deemphasized - Menor énfasis al final
  static const Curve deemphasized = Curves.easeInCubic;

  /// Curva smooth - Muy suave
  static const Curve smooth = Curves.easeInOutCubic;

  /// Curva snap - Rápido al final
  static const Curve snap = Curves.easeOutQuart;

  // ============ CURVAS PERSONALIZADAS ============

  /// Curva personalizada para entrada de diálogos
  static const Curve dialogEntry = Curves.easeOut;

  /// Curva personalizada para salida de diálogos
  static const Curve dialogExit = Curves.easeIn;

  /// Curva personalizada para entrada de páginas
  static const Curve pageEntry = Curves.easeOut;

  /// Curva personalizada para salida de páginas
  static const Curve pageExit = Curves.easeIn;

  /// Curva personalizada para expansión
  static const Curve expansion = Curves.easeInOut;

  /// Curva personalizada para colapso
  static const Curve collapse = Curves.easeInOut;

  // ============ ANIMACIONES COMPUESTAS ============

  /// Configuración para fade in
  static AnimationConfig get fadeIn => AnimationConfig(
        duration: fast,
        curve: easeOut,
      );

  /// Configuración para fade out
  static AnimationConfig get fadeOut => AnimationConfig(
        duration: fast,
        curve: easeIn,
      );

  /// Configuración para slide up
  static AnimationConfig get slideUp => AnimationConfig(
        duration: normal,
        curve: easeOut,
      );

  /// Configuración para slide down
  static AnimationConfig get slideDown => AnimationConfig(
        duration: normal,
        curve: easeIn,
      );

  /// Configuración para scale up
  static AnimationConfig get scaleUp => AnimationConfig(
        duration: scale,
        curve: easeOut,
      );

  /// Configuración para scale down
  static AnimationConfig get scaleDown => AnimationConfig(
        duration: scale,
        curve: easeIn,
      );

  // ============ HELPER METHODS ============

  /// Combina duración y curva en una configuración
  static AnimationConfig config({
    required Duration duration,
    required Curve curve,
  }) =>
      AnimationConfig(duration: duration, curve: curve);

  /// Duración inversa (útil para animaciones de reversión)
  static Duration reverse(Duration duration) =>
      Duration(milliseconds: (duration.inMilliseconds * 0.7).round());
}

/// Clase para configuraciones de animación
class AnimationConfig {
  final Duration duration;
  final Curve curve;

  const AnimationConfig({
    required this.duration,
    required this.curve,
  });

  /// Copia la configuración con cambios opcionales
  AnimationConfig copyWith({
    Duration? duration,
    Curve? curve,
  }) {
    return AnimationConfig(
      duration: duration ?? this.duration,
      curve: curve ?? this.curve,
    );
  }

  /// Crea una configuración inversa (duración más corta)
  AnimationConfig get reversed {
    return AnimationConfig(
      duration: AppAnimations.reverse(duration),
      curve: curve,
    );
  }
}
