import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Table over home that represent menu
class CartTableWidget extends StatelessWidget {
  const CartTableWidget({Key? key}) : super(key: key);

  //Create table row for menu
  @override
  Widget build(BuildContext context) {
    return Table(
      children: const [
        TableRow(children: [
          _SingleCart(
            color: Colors.purpleAccent,
            icon: Icons.settings_applications_outlined,
            text: 'CONFIGURACIÓN',
            description: 'Imagen y firma electrónica',
            route: "config",
          ),
          _SingleCart(
              color: Colors.green,
              icon: Icons.person_add_alt_1_outlined,
              text: 'CLIENTES',
              description: 'Gestione sus clientes',
              route: "client"),
        ]),
        TableRow(children: [
          _SingleCart(
              color: Colors.orange,
              icon: Icons.point_of_sale_sharp,
              text: 'FACTURAS',
              description: 'Genere sus facturas',
              route: "bill"),
          _SingleCart(
              color: Colors.amber,
              icon: Icons.shopping_cart_outlined,
              text: 'PRODUCTOS',
              description: 'Cree y edite sus productos',
              route: "item"),
        ]),
        TableRow(children: [
          _SingleCart(
              color: AppTheme.blue,
              icon: Icons.file_copy_outlined,
              text: 'REPORTES',
              description: 'Consulte sus facturas',
              route: "report"),
          _SingleCart(
              color: AppTheme.pinkAccent,
              icon: Icons.send_and_archive,
              text: 'REVISIÓN',
              description: 'Verifique sus facturas en el SRI',
              route: "review"),
        ])
      ],
    );
  }
}

//Widgets for content menu card
class _SingleCart extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  final String description;
  final String route;

  //Constructor
  const _SingleCart(
      {Key? key,
      required this.icon,
      required this.color,
      required this.text,
      required this.description,
      required this.route})
      : super(key: key);

  //Create menu for home
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.pushNamed(context, route),
        child: Container(
            padding: const EdgeInsets.only(top: 0),
            child: _CartBackground(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  radius: 25,
                  child: Icon(icon, size: 25, color: AppTheme.white),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  text,
                  style:
                      const TextStyle(color: Colors.blueAccent, fontSize: 15),
                ),
                const SizedBox(
                  height: 7,
                ),
                Container(
                    padding: const EdgeInsets.only(left: 6.0, right: 13.0),
                    child: Text(
                      description,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontSize: 10.0,
                      ),
                    ))
              ],
            ))));
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
            borderRadius: const BorderRadius.all(
              Radius.circular(25),
            ),
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
                            offset: const Offset(6, 8),
                          ),
                        ],
                        color: AppTheme.targetGradient,
                        borderRadius: BorderRadius.circular(20)),
                    child: child))));
  }
}
