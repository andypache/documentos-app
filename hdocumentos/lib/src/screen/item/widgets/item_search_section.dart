import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/provider/item_list_provider.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';

/// Sección de búsqueda de items con TextField y botones
class ItemSearchSection extends StatefulWidget {
  const ItemSearchSection({Key? key}) : super(key: key);

  @override
  State<ItemSearchSection> createState() => _ItemSearchSectionState();
}

class _ItemSearchSectionState extends State<ItemSearchSection> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ItemListProvider>(context, listen: false);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final hPad = isLandscape ? 12.0 : MediaQuery.of(context).size.width * 0.05;
    final fontSize =
        isLandscape ? 13.0 : MediaQuery.of(context).size.width * 0.035;
    final btnVPad =
        isLandscape ? 10.0 : MediaQuery.of(context).size.height * 0.018;

    final searchField = Container(
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(color: AppTheme.primaryButton, width: 1),
      ),
      child: TextField(
        controller: _searchController,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).searchItemsHint,
          hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5), fontSize: fontSize),
          prefixIcon:
              Icon(Icons.search, color: AppTheme.primaryButton, size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear,
                      color: AppTheme.primaryButton, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    provider.clearSearch();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          isDense: isLandscape,
        ),
        onChanged: (_) => setState(() {}),
        onSubmitted: (value) {
          if (value.trim().isNotEmpty) {
            provider.startLoadFilter(context, value.trim());
          }
        },
      ),
    );

    final btnSearch = ElevatedButton.icon(
      onPressed: () {
        if (_searchController.text.trim().isNotEmpty) {
          provider.startLoadFilter(context, _searchController.text.trim());
        }
      },
      icon: const Icon(Icons.search, size: 18),
      label: Text(AppLocalizations.of(context).btnSearch,
          style: TextStyle(fontSize: fontSize)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryButton,
        foregroundColor: AppTheme.secondary,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: btnVPad, horizontal: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM)),
      ),
    );

    final btnAll = ElevatedButton.icon(
      onPressed: () => provider.startLoadAll(context),
      icon: const Icon(Icons.list, size: 18),
      label: Text(AppLocalizations.of(context).btnLoadAll,
          style: TextStyle(fontSize: fontSize)),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.secondaryButton,
        foregroundColor: AppTheme.secondary,
        elevation: 0,
        padding: EdgeInsets.symmetric(vertical: btnVPad, horizontal: 12),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimens.radiusM)),
      ),
    );

    if (isLandscape) {
      // Landscape: campo + botones en columna compacta
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            searchField,
            SizedBox(height: AppDimens.spaceS),
            btnSearch,
            SizedBox(height: AppDimens.spaceXS),
            btnAll,
          ],
        ),
      );
    }

    // Portrait: layout original en columna
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        children: [
          searchField,
          SizedBox(height: AppDimens.spaceM),
          Row(
            children: [
              Expanded(child: btnSearch),
              const SizedBox(width: 12),
              Expanded(child: btnAll),
            ],
          ),
        ],
      ),
    );
  }
}
