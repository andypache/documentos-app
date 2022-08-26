import 'package:flutter/material.dart';

///Widgets background for all form
class CardFormWidget extends StatelessWidget {
  final Widget child;

  //Constructor
  const CardFormWidget({Key? key, required this.child}) : super(key: key);

  //Build
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
            margin: const EdgeInsets.only(bottom: 50),
            width: double.infinity,
            height: 400,
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
