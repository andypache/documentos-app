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
      child: const Stack(
        children: [
          // Burbujas decorativas con tamaños variados para profundidad visual
          Positioned(top: 80, left: 20, child: _Bubble(size: 120)),
          Positioned(top: -50, left: -40, child: _Bubble(size: 160)),
          Positioned(top: -30, right: -30, child: _Bubble(size: 140)),
          Positioned(bottom: -60, left: 0, child: _Bubble(size: 180)),
          Positioned(bottom: 100, right: 10, child: _Bubble(size: 100)),
          Positioned(top: 200, right: -20, child: _Bubble(size: 80)),
          // Logo centrado en la parte superior
          _HeaderLogo(),
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
    return SafeArea(
      child: SizedBox(
        width: double.infinity,
        height: size.height * 0.18,
        child: const Padding(
          padding: EdgeInsets.only(top: 24),
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
