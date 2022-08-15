import 'package:flutter/material.dart';
import 'package:hdocumentos/src/screen/screen.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:provider/provider.dart';

///Class for check login into application
class CheckOut extends StatelessWidget {
  const CheckOut({Key? key}) : super(key: key);

  //Create a widget for send home or login in case that user its authenticated
  @override
  Widget build(BuildContext context) {
    //Load provider Authentication
    final authService = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
        body: Center(
            child: FutureBuilder(
                future: authService.readToken(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  if (!snapshot.hasData) return const Text('');
                  if (snapshot.data == "") {
                    Future.microtask(() {
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const Login(),
                              transitionDuration: Duration.zero));
                    });
                  } else {
                    Future.microtask(() {
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const Home(),
                              transitionDuration: Duration.zero));
                    });
                  }
                  return Container();
                })));
  }
}
