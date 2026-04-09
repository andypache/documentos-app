import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Fondo animado de la pantalla de login con gradiente y burbujas decorativas.
class LoginBackgroundWidget extends StatelessWidget {
  const LoginBackgroundWidget({Key? key, required this.child})
      : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [const _LoginBackgroundWidgetBox(), child],
      ),
    );
  }
}

/// Capa de fondo: gradiente + burbujas + logo.
class _LoginBackgroundWidgetBox extends StatelessWidget {
  const _LoginBackgroundWidgetBox();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Usar el lado más corto como referencia para que las burbujas
    // sean proporcionales tanto en portrait como landscape
    final s = size.shortestSide;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppTheme.primary, AppTheme.secondary],
          stops: [0.0, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Burbujas decorativas con tamaños proporcionales a la pantalla
          Positioned(
              top: s * 0.22, left: s * 0.05, child: _Bubble(size: s * 0.3)),
          Positioned(
              top: -s * 0.13, left: -s * 0.1, child: _Bubble(size: s * 0.4)),
          Positioned(
              top: -s * 0.08, right: -s * 0.08, child: _Bubble(size: s * 0.35)),
          Positioned(
              bottom: -s * 0.15, left: 0, child: _Bubble(size: s * 0.45)),
          Positioned(
              bottom: s * 0.25,
              right: s * 0.025,
              child: _Bubble(size: s * 0.25)),
          Positioned(
              top: s * 0.5, right: -s * 0.05, child: _Bubble(size: s * 0.2)),
          // Logo centrado en la parte superior
          const _HeaderLogo(),
        ],
      ),
    );
  }
}

/// Logo de la empresa en la parte superior del fondo.
class _HeaderLogo extends StatelessWidget {
  const _HeaderLogo();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape = size.width > size.height;
    // En landscape el logo toma menos altura para dejar espacio al formulario
    final logoHeight = isLandscape ? size.height * 0.22 : size.height * 0.18;

    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: logoHeight,
        child: const Padding(
          padding: EdgeInsets.only(top: 16),
          child: FadeInImage(
            image: AssetImage('assets/image/haku_white.png'),
            placeholder: AssetImage('assets/image/haku_white.png'),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

/// Burbuja decorativa semitransparente.
class _Bubble extends StatelessWidget {
  const _Bubble({this.size = 100});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
        color: AppTheme.whiteGradient,
      ),
    );
  }
}
