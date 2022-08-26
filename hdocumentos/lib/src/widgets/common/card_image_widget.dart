import 'dart:io';

import 'package:flutter/material.dart';

///Widgets for view image loading and url
class CardImageWidget extends StatelessWidget {
  final String? url;

  //Costructor class
  const CardImageWidget({Key? key, this.url}) : super(key: key);

  //Build
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Container(
            decoration: _buildBoxDecoration(),
            width: double.infinity,
            height: 300,
            child: Opacity(
                opacity: 0.9,
                child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(45),
                        topRight: Radius.circular(45)),
                    child: getImage(url)))));
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
          color: Colors.black,
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(45), topRight: Radius.circular(45)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5))
          ]);

  Widget getImage(String? picture) {
    if (picture == null) {
      return const Image(
          image: AssetImage('assets/image/no-image.jpg'), fit: BoxFit.cover);
    }
    if (picture.startsWith('http')) {
      return FadeInImage(
          image: NetworkImage(url!),
          placeholder: const AssetImage('assets/image/jar-loading.gif'),
          fit: BoxFit.cover);
    }

    return Image.file(File(picture), fit: BoxFit.cover);
  }
}
