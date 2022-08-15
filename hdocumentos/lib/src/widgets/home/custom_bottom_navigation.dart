import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/service/service.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Widgets for bottom button
class CustomBottomNavigation extends StatelessWidget {
  const CustomBottomNavigation({Key? key}) : super(key: key);

  ///Put buttom
  @override
  Widget build(BuildContext context) {
    final _authService = Provider.of<AuthService>(context);
    int currentIndex = 0;
    return BottomNavigationBar(
      onTap: (int index) async {
        currentIndex = index;
        if (currentIndex == 2) {
          await _authService.logout();
          Navigator.pushReplacementNamed(context, 'login');
        }
      },
      type: BottomNavigationBarType.fixed,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: AppTheme.primaryButton,
      backgroundColor: AppTheme.primaryBottomGradient,
      unselectedItemColor: AppTheme.primaryButton,
      currentIndex: currentIndex,
      //Create buttons navigation
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.build_outlined), label: 'Factura'),
        BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined), label: 'Reportes'),
        BottomNavigationBarItem(icon: Icon(Icons.logout_sharp), label: 'Salir'),
      ],
    );
  }
}
