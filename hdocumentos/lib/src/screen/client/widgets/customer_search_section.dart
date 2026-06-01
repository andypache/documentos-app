import 'package:flutter/material.dart';
import 'package:hdocumentos/src/constant/app_localizations.dart';
import 'package:hdocumentos/src/theme/app_dimens.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Sección de búsqueda con campo de texto y botones
class CustomerSearchSection extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final VoidCallback onLoadAll;
  final VoidCallback onClear;

  const CustomerSearchSection({
    Key? key,
    required this.controller,
    required this.onSearch,
    required this.onLoadAll,
    required this.onClear,
  }) : super(key: key);

  @override
  State<CustomerSearchSection> createState() => _CustomerSearchSectionState();
}

class _CustomerSearchSectionState extends State<CustomerSearchSection> {
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final size = MediaQuery.of(context).size;
    final hPad = isLandscape ? 12.0 : size.width * 0.05;
    final fontSize = isLandscape ? 13.0 : size.width * 0.035;
    final btnVPad = isLandscape ? 10.0 : 14.0;

    final searchField = Container(
      decoration: BoxDecoration(
        color: AppTheme.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppDimens.radiusM),
        border: Border.all(color: AppTheme.primaryButton, width: 1),
      ),
      child: TextField(
        controller: widget.controller,
        style: TextStyle(color: Colors.white, fontSize: fontSize),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context).searchCustomersHint,
          hintStyle: TextStyle(
              color: Colors.white.withOpacity(0.5), fontSize: fontSize),
          prefixIcon:
              Icon(Icons.search, color: AppTheme.primaryButton, size: 20),
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear,
                      color: AppTheme.primaryButton, size: 18),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onClear();
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
          if (value.trim().isNotEmpty) widget.onSearch();
        },
      ),
    );

    final btnSearch = ElevatedButton.icon(
      onPressed: () {
        if (widget.controller.text.trim().isNotEmpty) widget.onSearch();
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
      onPressed: widget.onLoadAll,
      icon: const Icon(Icons.list, size: 18),
      label: Text(AppLocalizations.of(context).btnLoadLast,
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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hPad),
      child: Column(
        children: [
          searchField,
          SizedBox(height: AppDimens.paddingS),
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
