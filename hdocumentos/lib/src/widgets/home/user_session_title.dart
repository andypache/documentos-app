import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/share/preference.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';

///Widgets that put user session into top screen
class UserSessionTitle extends StatelessWidget {
  final UserSessionModel session = Preferences.userSession;

  //Constructor
  UserSessionTitle({Key? key}) : super(key: key);

  //Build widgets
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
        bottom: false,
        child: SizedBox(
            width: double.infinity,
            child: Column(children: [
              Row(children: [
                const Padding(
                    padding: EdgeInsets.only(left: 20, top: 5),
                    child: FadeInImage(
                        image: AssetImage('assets/image/user-default.png'),
                        placeholder:
                            AssetImage('assets/image/user-default.png'),
                        height: 80.0)),
                const SizedBox(width: 5),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 0, top: 0),
                      child: Text(session.username,
                          style: const TextStyle(
                              fontSize: 16, color: AppTheme.white))),
                  Padding(
                      padding: const EdgeInsets.only(left: 0, top: 0),
                      child: Text(session.identification.toString(),
                          style: const TextStyle(
                              fontSize: 18, color: AppTheme.white)))
                ]),
                SizedBox(
                    width: size.width * 0.45,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [BillingCard()]))
              ])
            ])));
  }
}
