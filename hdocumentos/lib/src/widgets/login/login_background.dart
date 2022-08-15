import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Widgets for render background login application
class LoginBackground extends StatelessWidget {
  const LoginBackground({Key? key, required this.child}) : super(key: key);

  final Widget child;
  //Create background application
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [_LoginBackgroundBox(), child],
      ),
    );
  }
}

///Create widgets to login background
class _LoginBackgroundBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: double.infinity,
      //height: size.height * 0.4,
      decoration: _background(),
      child: Stack(
        children: [
          Positioned(child: _Bubble(), top: 90, left: 30),
          Positioned(child: _Bubble(), top: -40, left: -30),
          Positioned(child: _Bubble(), top: -50, right: -20),
          Positioned(child: _Bubble(), bottom: -50, left: 10),
          //Positioned(child: _Bubble(), bottom: 340, left: 440),
          Positioned(child: _Bubble(), bottom: 120, right: 20),
          const _HeaderIcon(),
        ],
      ),
    );
  }

  //Background gradient into login
  BoxDecoration _background() => const BoxDecoration(
      gradient: LinearGradient(colors: [AppTheme.primary, AppTheme.secondary]));
}

///Create header icon login
class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    Key? key,
  }) : super(key: key);

  //Create icon
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 70),
      //child: const Icon(Icons.person_pin, color: Colors.white, size: 100),
      child: const FadeInImage(
        image: AssetImage('assets/image/haku_white.png'),
        placeholder: AssetImage('assets/image/haku_white.png'),
        fit: BoxFit.contain,
        height: 150.0,
      ),
    ));
  }
}

//Create bubble effect for sreenc
class _Bubble extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppTheme.whiteGradient),
    );
  }
}
