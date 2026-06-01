import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/provider/item_list_provider.dart';
import 'package:hdocumentos/src/screen/item/item_wizard_screen.dart';
import 'package:hdocumentos/src/widgets/widgets.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/screen/item/widgets/widgets.dart';

///Pantalla principal de gestión de productos
class ItemScreen extends StatelessWidget {
  const ItemScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ItemListProvider(),
      child: const _ItemScreenContent(),
    );
  }
}

///Contenido principal con Scaffold
class _ItemScreenContent extends StatelessWidget {
  const _ItemScreenContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BrackgroundWidget(),
          Column(
            children: [
              const Expanded(child: _ItemScreenBody()),
              _BottomActionBar(
                onNewProduct: () => _navigateToCreateItem(context),
                onCancel: () => Navigator.pop(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToCreateItem(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ItemWizardScreen()),
    );

    // Si se guardó un item, recargar la lista
    if (result == true && context.mounted) {
      final provider = Provider.of<ItemListProvider>(context, listen: false);
      if (provider.hasStarted) {
        provider.startLoadAll(context);
      }
    }
  }
}

///Barra inferior con botón Cancelar y Nuevo Producto
class _BottomActionBar extends StatelessWidget {
  final VoidCallback onNewProduct;
  final VoidCallback onCancel;

  const _BottomActionBar({
    Key? key,
    required this.onNewProduct,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final hPad = isLandscape ? 16.0 : MediaQuery.of(context).size.width * 0.05;
    final vPad = isLandscape ? 6.0 : 12.0;
    final iconSize = isLandscape ? 18.0 : 22.0;
    final fontSize = isLandscape ? 13.0 : 14.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        border: Border(
          top: BorderSide(color: Colors.white.withOpacity(0.1), width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Cancelar
          ElevatedButton.icon(
            onPressed: onCancel,
            icon: Icon(Icons.close_rounded, size: iconSize),
            label: Text(l10n.btnCancel, style: TextStyle(fontSize: fontSize)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.actionDanger,
              foregroundColor: Colors.white,
              elevation: 0,
              padding:
                  EdgeInsets.symmetric(horizontal: hPad, vertical: vPad + 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusM)),
            ),
          ),
          // Nuevo Producto
          ElevatedButton.icon(
            onPressed: onNewProduct,
            icon: Icon(Icons.add_rounded, size: iconSize),
            label:
                Text(l10n.btnNewProduct, style: TextStyle(fontSize: fontSize)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryButton,
              foregroundColor: AppTheme.secondary,
              elevation: 0,
              padding:
                  EdgeInsets.symmetric(horizontal: hPad, vertical: vPad + 2),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimens.radiusM)),
            ),
          ),
        ],
      ),
    );
  }
}

///Cuerpo principal de la pantalla
class _ItemScreenBody extends StatelessWidget {
  const _ItemScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLandscape) {
      // En horizontal: layout de dos columnas — búsqueda | lista
      return Row(
        children: [
          // Panel izquierdo: búsqueda
          SizedBox(
            width: 320,
            child: Column(
              children: [
                SizedBox(height: AppDimens.spaceS),
                const ItemSearchSection(),
                SizedBox(height: AppDimens.spaceS),
              ],
            ),
          ),
          const VerticalDivider(width: 1, color: Colors.white12, thickness: 1),
          // Panel derecho: lista
          const Expanded(child: ItemListSection()),
        ],
      );
    }

    // Portrait: layout original
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        const UserSessionTitle(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
          child: const PageTitleWidget(title: ''),
        ),
        SizedBox(height: AppDimens.paddingM),
        const ItemSearchSection(),
        SizedBox(height: AppDimens.spaceL),
        const Expanded(child: ItemListSection()),
      ],
    );
  }
}
