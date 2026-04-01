import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Spinner de pantalla completa con fondo semitransparente.
/// Retrocompatible — alias de [AppLoadingWidget].
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppLoadingWidget();
  }
}

/// Spinner empresarial reutilizable.
///
/// • [label]   — texto bajo el spinner (por defecto l10n.loading)
/// • [overlay] — true: fondo oscuro que cubre todo el espacio disponible
///               false: solo el spinner centrado, sin fondo
/// • [size]    — diámetro del anillo (por defecto 36)
/// • [color]   — color del indicador (por defecto AppTheme.primaryButton)
class AppLoadingWidget extends StatelessWidget {
  const AppLoadingWidget({
    Key? key,
    this.label,
    this.overlay = true,
    this.size = 36.0,
    this.color = AppTheme.primaryButton,
  }) : super(key: key);

  final String? label;
  final bool overlay;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
        const SizedBox(height: 14),
        Text(
          label ?? l10n.loading,
          style: TextStyle(
            color: AppTheme.white.withOpacity(0.85),
            fontSize: 13,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );

    if (!overlay) {
      return Center(child: content);
    }

    // Modo overlay: SizedBox.expand cubre todo el espacio que le asigne el padre
    return SizedBox.expand(
      child: ColoredBox(
        color: AppTheme.secondary.withOpacity(0.60),
        child: Center(child: content),
      ),
    );
  }
}

/// Spinner inline dentro de [ElevatedButton.icon].
///
/// ```dart
/// icon: isLoading ? const ButtonLoadingIndicator() : const Icon(Icons.save),
/// ```
class ButtonLoadingIndicator extends StatelessWidget {
  const ButtonLoadingIndicator({Key? key, this.size = 18.0}) : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.white),
      ),
    );
  }
}

/// Spinner centrado para listas, diálogos y paneles internos.
///
/// ```dart
/// if (isLoading) const ContentLoadingWidget()
/// ```
class ContentLoadingWidget extends StatelessWidget {
  const ContentLoadingWidget({
    Key? key,
    this.padding = const EdgeInsets.all(32),
  }) : super(key: key);

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryButton),
        ),
      ),
    );
  }
}
