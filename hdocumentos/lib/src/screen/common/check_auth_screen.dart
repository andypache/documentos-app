import 'package:flutter/material.dart';
import 'package:hdocumentos/src/screen/screen.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:provider/provider.dart';

///Class for check login into application
class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({Key? key}) : super(key: key);

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
                              pageBuilder: (_, __, ___) => const LoginScreen(),
                              transitionDuration: Duration.zero));
                    });
                  } else {
                    Future.microtask(() {
                      Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                              pageBuilder: (_, __, ___) => const HomeScreen(),
                              transitionDuration: Duration.zero));
                    });
                  }
                  return Container();
                })));
  }
}
