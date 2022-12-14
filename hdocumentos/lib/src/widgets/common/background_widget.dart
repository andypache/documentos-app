import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Create brackground for screens
class BrackgroundWidget extends StatelessWidget {
  const BrackgroundWidget({Key? key}) : super(key: key);

  //Decoration font and graint
  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.9, 4.0],
          colors: [AppTheme.secondary, AppTheme.primary]));

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [Container(decoration: boxDecoration), const _Box()]);
  }
}

//Lateral box angle corner left
class _Box extends StatelessWidget {
  const _Box({Key? key}) : super(key: key);

  ///Positioned box
  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: -100,
        left: -10,
        child: Transform.rotate(
            angle: -pi / 14,
            child: Container(
                width: 600,
                height: 180,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                    gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppTheme.primary, AppTheme.secondary])))));
  }
}
