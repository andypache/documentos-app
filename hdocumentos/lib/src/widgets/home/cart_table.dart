import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Table over home that represent menu
class CartTable extends StatelessWidget {
  const CartTable({Key? key}) : super(key: key);

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
            description: 'Cambie su imagen y seleccione su firma electrónica',
            route: "config",
          ),
          _SingleCart(
              color: Colors.green,
              icon: Icons.person_add_alt_1_outlined,
              text: 'CLIENTES',
              description:
                  'Verifique y gestione la información de sus clientes',
              route: "client"),
        ]),
        TableRow(children: [
          _SingleCart(
              color: Colors.orange,
              icon: Icons.point_of_sale_sharp,
              text: 'FACTURAS',
              description: 'Genere sus facturas y conéctelas al SRI',
              route: "bill"),
          _SingleCart(
              color: Colors.amber,
              icon: Icons.car_rental,
              text: 'PRODUCTOS',
              description: 'Cree y edite sus productos para la facturación',
              route: "item"),
        ]),
        TableRow(children: [
          _SingleCart(
              color: AppTheme.blue,
              icon: Icons.file_copy_outlined,
              text: 'REPORTES',
              description:
                  'Consulte y genere reportes de sus facturas anteriores',
              route: "report"),
          _SingleCart(
              color: AppTheme.pinkAccent,
              icon: Icons.send_and_archive,
              text: 'REVISIÓN',
              description:
                  'Verifique el estado de sus facturas enviadas hacia el SRI',
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
        child: _CartBackground(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, size: 70, color: AppTheme.white),
              radius: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              text,
              style: const TextStyle(color: Colors.blueAccent, fontSize: 26),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
                padding: const EdgeInsets.only(left: 50, right: 5),
                child: Text(
                  description,
                  style: const TextStyle(color: AppTheme.white, fontSize: 16),
                ))
          ],
        )));
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
        margin: const EdgeInsets.all(15),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                    height: 230,
                    decoration: BoxDecoration(
                        color: AppTheme.targetGradient,
                        borderRadius: BorderRadius.circular(20)),
                    child: child))));
  }
}
