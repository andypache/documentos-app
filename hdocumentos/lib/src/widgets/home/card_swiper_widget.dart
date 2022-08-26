import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:hdocumentos/src/model/common/menu_option_model.dart';
import 'package:hdocumentos/src/router/app_routes.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for menu swiper
class CardSwiperWidget extends StatelessWidget {
  const CardSwiperWidget({Key? key}) : super(key: key);

  //Build widgets
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    List<MenuOptionModel> homeMenus = AppRoutes.homeMenus;

    if (homeMenus.isEmpty) {
      return const LoadingWidget();
    }

    return SizedBox(
        width: double.infinity,
        height: size.height * 0.35,
        child: Swiper(
            itemCount: homeMenus.length,
            layout: SwiperLayout.STACK,
            itemWidth: size.width * 0.6,
            itemHeight: size.height * 0.4,
            itemBuilder: (_, int index) {
              final menu = homeMenus[index];
              menu.id = 'swiper-${menu.id}';
              return GestureDetector(
                  onTap: () => Navigator.pushNamed(context, menu.route),
                  child: Hero(
                      tag: menu.id!,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: _CartBackground(
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Icon(menu.icon, size: 75, color: menu.color),
                                Text(
                                  menu.text,
                                  style: TextStyle(
                                      color: menu.color,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                                const SizedBox(
                                  height: 7,
                                ),
                                Text(menu.description ?? "",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 3,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: AppTheme.white, fontSize: 15.0))
                              ])))));
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
    return Container(
        decoration: BoxDecoration(
            color: AppTheme.targetGradient,
            borderRadius: const BorderRadius.all(Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(1),
                  offset: const Offset(15, 15),
                  blurRadius: 5)
            ]),
        margin: const EdgeInsets.only(right: 8, left: 8, top: 15, bottom: 0),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white.withOpacity(0.5),
                              spreadRadius: 10,
                              blurRadius: 10,
                              offset: const Offset(6, 8))
                        ],
                        color: AppTheme.targetGradient,
                        borderRadius: BorderRadius.circular(20)),
                    child: child))));
  }
}
