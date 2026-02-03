import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/model.dart';
import 'package:hdocumentos/src/share/preference.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Widgets that put user session into top screen
class UserSessionTitle extends StatelessWidget {
  final UserSessionModel session = Preferences.userSession;

  //Constructor
  UserSessionTitle({Key? key}) : super(key: key);

  //Build widgets
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final avatarSize = size.width * 0.08;

    return SafeArea(
        bottom: false,
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(
              left: 15,
              right: 10,
              top: size.height * 0.01,
              bottom: 5,
            ),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Avatar
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 1.2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: const ClipOval(
                  child: FadeInImage(
                    image: AssetImage('assets/image/user-default.png'),
                    placeholder: AssetImage('assets/image/user-default.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: size.width * 0.018),
              // User info
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                    Text(
                      '${session.names} ${session.surnames}',
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: AppTheme.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.15,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 1),
                    Text(
                      (session.companyName != null &&
                              session.companyName!.isNotEmpty)
                          ? session.companyName!
                          : 'HVENTAS',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withOpacity(0.7),
                        letterSpacing: 0.08,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 0.8),
                    Text(session.identification,
                        style: TextStyle(
                            fontSize: 9, color: Colors.white.withOpacity(0.6)))
                  ]))
              // Billing card
            ])));
  }
}
