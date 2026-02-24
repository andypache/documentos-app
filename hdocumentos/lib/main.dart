import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hdocumentos/src/constant/enviroment.dart';
import 'package:hdocumentos/src/provider/locale_provider.dart';
import 'package:hdocumentos/src/router/app_routes.dart';
import 'package:hdocumentos/src/service/service.dart';

import 'package:hdocumentos/src/share/preference.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:provider/provider.dart';

//Create main function
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //load preferences
  await Preferences.init();
  //load enviroment
  await Environment.init();
  //create app with generic provider
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => AuthService()),
      ChangeNotifierProvider(create: (_) => LocaleProvider()),
    ],
    child: const MyApp(),
  ));
}

///Main class to render application
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    // Usa Consumer para que el locale esté disponible en el contexto correcto
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'H-DOCUMENTOS',
            locale: localeProvider.locale,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('es'), Locale('en')],
            initialRoute: AppRoutes.initialRoute,
            routes: AppRoutes.getAppRoutes(),
            theme: AppTheme.lightTheme,
            scaffoldMessengerKey: NotificationService.messengerKey);
      },
    );
  }
}
