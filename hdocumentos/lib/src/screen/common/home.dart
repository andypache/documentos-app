import 'package:flutter/material.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets for render home application
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  //Render principal widgets load background, body
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const [
          Brackground(),
          _HomeBody(),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}

///Body for home into sroll view
class _HomeBody extends StatelessWidget {
  const _HomeBody({Key? key}) : super(key: key);

  ///Put title and cart menu
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(children: const [
      PageTitle(title: 'Facturación Electrónica'),
      CartTable()
    ]));
  }
}
