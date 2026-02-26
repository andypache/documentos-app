import 'package:flutter/material.dart';
import 'package:hdocumentos/src/model/common/catalog_model.dart';
import 'package:hdocumentos/src/provider/app_init_provider.dart';
import 'package:hdocumentos/src/provider/form/company_form_provider.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';
import 'package:hdocumentos/src/widgets/config/company_wizard_shared.dart';
import 'package:provider/provider.dart';

// ─── Grupos de impuesto por defecto (fallback si no hay catálogos) ────────────

List<CatalogModel> get _defaultTaxGroups => [
      CatalogModel(code: '1', description: 'IVA — Impuesto al Valor Agregado'),
      CatalogModel(
          code: '2', description: 'ICE — Impuesto a los Consumos Especiales'),
      CatalogModel(
          code: '3', description: 'IRBPNR — Imp. Redimible Botellas Plásticas'),
      CatalogModel(
          code: '4', description: 'ISD — Impuesto a la Salida de Divisas'),
    ];

// ─── Guía de ejemplos ─────────────────────────────────────────────────────────

class _TaxExample {
  final String emoji;
  final String label;
  final String taxes;
  const _TaxExample(this.emoji, this.label, this.taxes);
}

const List<_TaxExample> _examples = [
  _TaxExample('🛒', 'Productos normales', 'IVA'),
  _TaxExample('🍺', 'Alcohol / cigarrillos', 'IVA + ICE'),
  _TaxExample('🥤', 'Bebidas plásticas', 'IVA + IRBPNR'),
  _TaxExample('💻', 'Servicios profesionales', 'IVA'),
];

// ─── Widget principal ─────────────────────────────────────────────────────────

/// Paso 6: Selección de grupos de impuesto habilitados para la empresa
class CompanyWizardStep6Widget extends StatelessWidget {
  const CompanyWizardStep6Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<CompanyFormProvider>(context);
    final catalogs = context.watch<AppInitProvider>().catalogs;

    final taxGroups = (catalogs?.systemParameters.isNotEmpty ?? false)
        ? catalogs!.systemParameters
        : _defaultTaxGroups;

    return Form(
      key: provider.formKeyStep6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CompanyWizardSectionHeader(
            icon: Icons.receipt_long_outlined,
            title: 'Grupos de Impuesto',
            size: size,
          ),
          SizedBox(height: size.height * 0.015),
          _TaxGroupSelector(
            taxGroups: taxGroups,
            selectedCodes: provider.company.taxGroupCodes,
            size: size,
            onChanged: (codes) {
              provider.company.taxGroupCodes = codes;
            },
          ),
          SizedBox(height: size.height * 0.025),
          _TaxGuideCard(size: size),
        ],
      ),
    );
  }
}

// ─── Selector de grupos ───────────────────────────────────────────────────────

class _TaxGroupSelector extends StatefulWidget {
  final List<CatalogModel> taxGroups;
  final List<String> selectedCodes;
  final Size size;
  final ValueChanged<List<String>> onChanged;

  const _TaxGroupSelector({
    required this.taxGroups,
    required this.selectedCodes,
    required this.size,
    required this.onChanged,
  });

  @override
  State<_TaxGroupSelector> createState() => _TaxGroupSelectorState();
}

class _TaxGroupSelectorState extends State<_TaxGroupSelector> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedCodes);
  }

  void _toggle(String code) {
    setState(() {
      if (_selected.contains(code)) {
        _selected.remove(code);
      } else {
        _selected.add(code);
      }
    });
    widget.onChanged(List.from(_selected));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.taxGroups
          .map((tax) => _TaxGroupTile(
                tax: tax,
                isSelected: _selected.contains(tax.code),
                size: widget.size,
                onTap: () => _toggle(tax.code),
              ))
          .toList(),
    );
  }
}

// ─── Tile de impuesto ─────────────────────────────────────────────────────────

class _TaxGroupTile extends StatelessWidget {
  final CatalogModel tax;
  final bool isSelected;
  final Size size;
  final VoidCallback onTap;

  const _TaxGroupTile({
    required this.tax,
    required this.isSelected,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(bottom: size.height * 0.012),
        padding: EdgeInsets.symmetric(
          horizontal: size.width * 0.04,
          vertical: size.height * 0.014,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryButton.withOpacity(0.15)
              : Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryButton
                : Colors.white.withOpacity(0.2),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: size.width * 0.055,
              height: size.width * 0.055,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected
                    ? AppTheme.primaryButton
                    : Colors.white.withOpacity(0.1),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryButton
                      : Colors.white.withOpacity(0.3),
                ),
              ),
              child: isSelected
                  ? Icon(Icons.check_rounded,
                      color: Colors.white, size: size.width * 0.035)
                  : null,
            ),
            SizedBox(width: size.width * 0.035),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tax.description.split('—').first.trim(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size.width * 0.036,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  if (tax.description.contains('—'))
                    Text(
                      tax.description.split('—').last.trim(),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: size.width * 0.028,
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.022,
                  vertical: size.height * 0.004),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryButton.withOpacity(0.25)
                    : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                tax.code,
                style: TextStyle(
                  color: isSelected
                      ? AppTheme.primaryButton
                      : Colors.white.withOpacity(0.5),
                  fontSize: size.width * 0.03,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tarjeta guía de ejemplos ─────────────────────────────────────────────────

class _TaxGuideCard extends StatelessWidget {
  final Size size;
  const _TaxGuideCard({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(size.width * 0.042),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline_rounded,
                  color: Colors.amber.shade300, size: size.width * 0.042),
              SizedBox(width: size.width * 0.02),
              Text(
                'Guía rápida',
                style: TextStyle(
                  color: Colors.amber.shade300,
                  fontSize: size.width * 0.034,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.012),
          Text(
            'Selecciona los grupos de impuesto que aplican a los productos o servicios que vende tu empresa.',
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: size.width * 0.029,
              height: 1.4,
            ),
          ),
          SizedBox(height: size.height * 0.014),
          ..._examples.map(
            (e) => Padding(
              padding: EdgeInsets.only(bottom: size.height * 0.008),
              child: Row(
                children: [
                  Text(e.emoji, style: TextStyle(fontSize: size.width * 0.038)),
                  SizedBox(width: size.width * 0.025),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                            fontSize: size.width * 0.029, height: 1.3),
                        children: [
                          TextSpan(
                            text: '${e.label}  ',
                            style:
                                TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                          TextSpan(
                            text: e.taxes,
                            style: const TextStyle(
                              color: AppTheme.primaryButton,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
