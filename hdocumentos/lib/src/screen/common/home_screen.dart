import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/constant.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for render home application
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  //Render principal widgets load background, body
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: const [BrackgroundWidget(), _HomeScreenBody()]),
        bottomNavigationBar: const BottomNavigationWidget());
  }
}

///Body for home into sroll view
class _HomeScreenBody extends StatelessWidget {
  const _HomeScreenBody({Key? key}) : super(key: key);

  ///Put user session title and cart menu
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      UserSessionTitle(),
      //SingleChildScrollView(child: CartTableWidget())
      SingleChildScrollView(
          child: Column(children: [
        const CardSwiperWidget(),
        const SizedBox(height: 20),
        CardSlider(bills: billExamples, title: "Mis Ventas", onNextPage: () {})
      ]))
    ]);
  }
}
