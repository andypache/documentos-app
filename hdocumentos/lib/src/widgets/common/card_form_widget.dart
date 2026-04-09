import 'package:flutter/material.dart';

///Widgets background for all form
class CardFormWidget extends StatelessWidget {
  final Widget child;

  //Constructor
  const CardFormWidget({Key? key, required this.child}) : super(key: key);

  //Build
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Altura dinámica: 50% del lado más corto para funcionar en portrait y landscape
    final cardHeight = size.shortestSide * 0.75;

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child: Container(
            margin: EdgeInsets.only(bottom: size.height * 0.06),
            width: double.infinity,
            height: cardHeight,
            decoration: _cardBorders(),
            child: Stack(alignment: Alignment.bottomLeft, children: [child])));
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 7), blurRadius: 10)
          ]);
}
