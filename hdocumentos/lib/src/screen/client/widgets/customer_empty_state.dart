import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Widget para mostrar estado vacío en la lista de clientes
class CustomerEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const CustomerEmptyState({
    Key? key,
    required this.icon,
    required this.title,
    required this.message,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Padding(
      padding: EdgeInsets.all(isLandscape ? 16 : 32),
      child: Column(
        children: [
          Icon(icon,
              size: isLandscape ? 40.0 : size.width * 0.18,
              color: AppTheme.primaryButton.withOpacity(0.5)),
          SizedBox(height: isLandscape ? 8 : 20),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isLandscape ? 14.0 : size.width * 0.048,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isLandscape ? 4 : 10),
          Text(
            message,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: isLandscape ? 11.0 : size.width * 0.035,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
