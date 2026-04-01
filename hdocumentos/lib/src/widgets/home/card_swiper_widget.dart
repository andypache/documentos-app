import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:hdocumentos/src/model/common/menu_option_model.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

/// Widget swiper del menú principal.
/// Recibe [menus] desde el padre (ya filtrados según [hasCompany]).
class CardSwiperWidget extends StatelessWidget {
  final List<MenuOptionModel> menus;

  const CardSwiperWidget({Key? key, required this.menus}) : super(key: key);

  //Build widgets
  @override
  Widget build(BuildContext context) {
    if (menus.isEmpty) {
      return const LoadingWidget();
    }

    final size = MediaQuery.of(context).size;

    // Calcular dimensiones responsivas
    final cardWidth = size.width * 0.65;
    final cardHeight = size.height * 0.28;
    final iconSize = size.width * 0.15;
    final titleFontSize = size.width * 0.055;
    final descriptionFontSize = size.width * 0.035;

    return SizedBox(
        width: double.infinity,
        height: cardHeight,
        child: Swiper(
            itemCount: menus.length,
            layout: SwiperLayout.STACK,
            itemWidth: cardWidth,
            itemHeight: cardHeight,
            itemBuilder: (_, int index) {
              final menu = menus[index];
              menu.id = 'swiper-${menu.id}';
              return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, menu.route),
                  child: Hero(
                      tag: menu.id!,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _CartBackground(
                              child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.04,
                              vertical: size.height * 0.015,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(menu.icon,
                                    size: iconSize, color: menu.color),
                                SizedBox(height: size.height * 0.012),
                                Text(
                                  menu.text,
                                  style: TextStyle(
                                      color: menu.color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: titleFontSize),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: size.height * 0.008),
                                Flexible(
                                  child: Text(
                                    menu.description ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppTheme.white,
                                        fontSize: descriptionFontSize),
                                  ),
                                ),
                              ],
                            ),
                          )))));
            }));
  }
}

//Widgets for background content card
class _CartBackground extends StatelessWidget {
  final Widget child;

  const _CartBackground({Key? key, required this.child}) : super(key: key);

  //Create content card
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        decoration: BoxDecoration(
            color: AppTheme.targetGradient,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.6),
                  offset: Offset(size.width * 0.02, size.width * 0.02),
                  blurRadius: 8)
            ]),
        margin: EdgeInsets.symmetric(
          horizontal: size.width * 0.02,
          vertical: size.height * 0.01,
        ),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white.withOpacity(0.3),
                              spreadRadius: 5,
                              blurRadius: 8,
                              offset: Offset(
                                  size.width * 0.012, size.height * 0.008))
                        ],
                        color: AppTheme.targetGradient,
                        borderRadius: BorderRadius.circular(20)),
                    child: child))));
  }
}
