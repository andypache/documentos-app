# Fragmentación de Widgets Grandes

## Estado Actual

### Archivos más largos identificados:

**Widgets:**
- `company_wizard_step5_widget.dart`: 973 líneas (8 clases privadas)
- `product_list_widget.dart`: 573 líneas
- `customer_search_dialog.dart`: 449 líneas  
- `product_search_dialog.dart`: 434 líneas
- `totals_panel_widget.dart`: 395 líneas
- `product_edit_dialog.dart`: 395 líneas
- `tax_selection_dialog_widget.dart`: 393 líneas
- `company_wizard_step6_widget.dart`: 381 líneas
- `last_sales_widget.dart`: 360 líneas
- `customer_selection_widget.dart`: 358 líneas
- `customer_wizard_step1_widget.dart`: 333 líneas

**Screens:**
- `client_screen.dart`: 1062 líneas
- `item_screen.dart`: 810 líneas
- `bill_screen.dart`: 600 líneas (ya refactorizado con MultiProvider)
- `configuration_wizard_screen.dart`: 553 líneas
- `item_wizard_screen.dart`: 550 líneas
- `login_screen.dart`: 459 líneas
- `item_price_screen.dart`: 435 líneas
- `customer_wizard_screen.dart`: 415 líneas
- `item_stock_screen.dart`: 393 líneas

## Estrategia de Fragmentación

### Prioridad Alta (>800 líneas)

#### 1. client_screen.dart (1062 líneas)
**Fragmentar en:**
- `client_list_view.dart`: Vista de lista con cards
- `client_filters_widget.dart`: Filtros de búsqueda
- `client_card_widget.dart`: Card individual de cliente
- `client_actions_widget.dart`: Acciones (agregar, editar, eliminar)

#### 2. item_screen.dart (810 líneas)
**Fragmentar en:**
- `item_list_view.dart`: Vista de lista con cards
- `item_filters_widget.dart`: Filtros de búsqueda  
- `item_card_widget.dart`: Card individual de producto
- `item_actions_widget.dart`: Acciones (agregar, editar, eliminar)

### Prioridad Media (500-800 líneas)

#### 3. product_list_widget.dart (573 líneas)
**Ya actualizado en Fase 3**, revisar si necesita más fragmentación:
- Extraer cálculos complejos a utility
- Separar card de producto individual
- Extraer dialogs de edición

#### 4. configuration_wizard_screen.dart (553 líneas)
**Fragmentar en:**
- `wizard_step_widget.dart`: Componente genérico de paso
- `wizard_navigation_widget.dart`: Navegación entre pasos
- Cada paso en archivo separado si aún no lo está

#### 5. item_wizard_screen.dart (550 líneas)
**Similar a configuration_wizard_screen**

### Prioridad Baja (400-499 líneas)

#### 6. customer_search_dialog.dart (449 líneas)
**Fragmentar en:**
- `customer_search_bar.dart`: Barra de búsqueda
- `customer_result_list.dart`: Lista de resultados
- `customer_filters_panel.dart`: Panel de filtros

#### 7. product_search_dialog.dart (434 líneas)
**Fragmentar en:**
- `product_search_bar.dart`: Barra de búsqueda
- `product_result_list.dart`: Lista de resultados
- `product_filters_panel.dart`: Panel de filtros

#### 8. login_screen.dart (459 líneas)
**Fragmentar en:**
- `login_form_widget.dart`: Formulario de login
- `login_logo_section.dart`: Logo y header
- `login_footer_widget.dart`: Footer con enlaces

## Notas sobre company_wizard_step5_widget.dart

Este widget ya está fragmentado internamente en 8 clases privadas:
- `_CompanyWizardStep5WidgetState`: Estado principal (279 líneas)
- `_EmissionPointCard`: Card de punto de emisión (180 líneas)
- `_EmptyEmissionPointsWidget`: Empty state (44 líneas)
- `_EmissionPointForm`: Formulario de edición (306 líneas)
- `_EmissionPointFormState`: Estado del formulario (276 líneas)
- `_ActionIconBtn`: Botón de acción (28 líneas)
- `_FinalSummaryWidget`: Resumen final (89 líneas)
- `_SummaryRow`: Fila de resumen (47 líneas)

**Recomendación**: Convertir las clases privadas en públicas y crear archivos separados:
- `emission_point_card.dart`
- `emission_point_form.dart`
- `emission_point_summary.dart`

## Beneficios de Fragmentar

1. **Mantenibilidad**: Archivos más pequeños son más fáciles de entender
2. **Reutilización**: Componentes extraídos pueden usarse en otros lugares
3. **Testing**: Widgets más pequeños son más fáciles de testear
4. **Performance**: Rebuild optimization más granular
5. **Colaboración**: Menos conflictos en git con archivos pequeños

## Plan de Ejecución

### Fase 1: Súper Críticos (>900 líneas)
1. ✅ Identificar archivos
2. ⏳ Fragmentar client_screen.dart
3. ⏳ Fragmentar item_screen.dart
4. ⏳ Fragmentar company_wizard_step5_widget.dart

### Fase 2: Críticos (500-800 líneas)
5. ⏳ Fragmentar product_list_widget.dart
6. ⏳ Fragmentar configuration_wizard_screen.dart
7. ⏳ Fragmentar item_wizard_screen.dart

### Fase 3: Moderados (400-499 líneas)
8. ⏳ Fragmentar dialogs de búsqueda
9. ⏳ Fragmentar login_screen.dart
10. ⏳ Fragmentar otros screens >400 líneas

## Tiempo Estimado

- **Súper críticos**: 8-10 horas (3 archivos)
- **Críticos**: 4-6 horas (3 archivos)
- **Moderados**: 6-8 horas (6 archivos)
- **Total**: 18-24 horas de trabajo
