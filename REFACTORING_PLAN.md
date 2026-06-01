# Plan de Refactorización: Separar BillFormProvider

## Estado Actual
`BillFormProvider` tiene 546 líneas y múltiples responsabilidades:
- Gestión de cliente seleccionado
- Lista de productos (items)
- Cálculos del servidor (subtotal, impuestos, descuentos, totales)
- Método de pago
- Estados UI (isLoading, isCalculating, isSaving)
- Debouncing de cálculos

## Propuesta de Separación

### 1. BillCustomerProvider
**Responsabilidad**: Gestionar el cliente seleccionado

**Estado**:
```dart
CustomerModel? _selectedCustomer;
```

**Métodos**:
- `selectCustomer(CustomerModel? customer)`
- `removeCustomer()`
- `assignConsumerFinal()`

**Getters**:
- `CustomerModel? get selectedCustomer`
- `bool get hasCustomer`

**Callbacks**: Notificar a BillCalculationProvider cuando cambia el cliente

---

### 2. BillItemsProvider
**Responsabilidad**: Gestionar la lista de productos

**Estado**:
```dart
List<BillItemModel> _billItems = [];
```

**Métodos**:
- `Future<void> addItem(ItemModel item, {int quantity, double? customPrice})`
- `Future<void> updateItem(int index, {int? quantity, double? unitPrice, double? discount})`
- `Future<void> removeItem(int index)`
- `void clearItems()`

**Getters**:
- `List<BillItemModel> get billItems`
- `int get itemCount`
- `bool get hasItems`

**Callbacks**: Notificar a BillCalculationProvider cuando cambia la lista

---

### 3. BillCalculationProvider
**Responsabilidad**: Calcular totales en el servidor

**Estado**:
```dart
double _subtotal = 0.0;
double _customerDiscount = 0.0;
double _totalTax = 0.0;
double _total = 0.0;
double _discountItem = 0.0;
double _discountTotal = 0.0;
CustomerDiscountInfoModel? _customerDiscountInfo;
Map<String, DetailCalculateModel> _itemCalculations = {};
SaleCalculateResponseModel? _lastCalculateResponse;
bool _isCalculating = false;
Timer? _debounceTimer;
```

**Métodos**:
- `Future<void> calculateBill(BuildContext context)`
- `void triggerCalculation()` (debounced)
- `DetailCalculateModel? getItemCalculation(String itemId)`
- `void _resetCalculations()`

**Getters**:
- `double get subtotal`, `customerDiscount`, `totalTax`, `total`, etc.
- `bool get isCalculating`
- `CustomerDiscountInfoModel? get customerDiscountInfo`
- `SaleCalculateResponseModel? get lastCalculateResponse`

**Dependencias**: 
- Escucha cambios de BillCustomerProvider y BillItemsProvider
- Dispara cálculos automáticos cuando cambian

---

### 4. BillPaymentProvider
**Responsabilidad**: Gestionar método de pago

**Estado**:
```dart
PaymentMethodModel? _selectedPaymentMethod;
List<PaymentMethodModel> _paymentMethods = [];
```

**Métodos**:
- `void initialize(BuildContext context)`
- `void selectPaymentMethod(PaymentMethodModel? method)`

**Getters**:
- `PaymentMethodModel? get selectedPaymentMethod`
- `List<PaymentMethodModel> get paymentMethods`
- `bool get hasPaymentMethod`

---

### 5. BillStateProvider (Opcional)
**Responsabilidad**: Estados globales de UI

**Estado**:
```dart
bool _isLoading = false;
bool _isSaving = false;
```

**Métodos**:
- `void setLoading(bool value)`
- `void setSaving(bool value)`

**Getters**:
- `bool get isLoading`
- `bool get isSaving`
- `bool get canSave` (depende de otros providers)

---

## Plan de Implementación

### Fase 1: Crear providers individuales
1. Crear `bill_customer_provider.dart`
2. Crear `bill_items_provider.dart`
3. Crear `bill_calculation_provider.dart`
4. Crear `bill_payment_provider.dart`

### Fase 2: Configurar comunicación
- Usar `ChangeNotifierProvider` o `MultiProvider`
- BillCalculationProvider escucha cambios usando `context.watch` o callbacks

### Fase 3: Actualizar BillScreen
- Cambiar `ChangeNotifierProvider<BillFormProvider>` por:
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => BillCustomerProvider()),
    ChangeNotifierProvider(create: (_) => BillItemsProvider()),
    ChangeNotifierProxyProvider2<BillCustomerProvider, BillItemsProvider, BillCalculationProvider>(
      create: (context) => BillCalculationProvider(
        customerProvider: context.read<BillCustomerProvider>(),
        itemsProvider: context.read<BillItemsProvider>(),
      ),
      update: (context, customer, items, calc) => calc!..updateDependencies(customer, items),
    ),
    ChangeNotifierProvider(create: (_) => BillPaymentProvider()),
  ],
  child: BillScreen(),
)
```

### Fase 4: Actualizar Selectors
- Cambiar `Selector<BillFormProvider, BillFormData>` por múltiples Selectors específicos
- Ejemplo: 
```dart
Selector<BillItemsProvider, List<BillItemModel>>(
  selector: (_, provider) => provider.billItems,
  builder: (_, items, __) => ProductListWidget(billItems: items),
)
```

### Fase 5: Migrar lógica y probar
1. Mover código de BillFormProvider a providers especializados
2. Probar cada funcionalidad:
   - Seleccionar cliente
   - Agregar/editar/eliminar productos
   - Cálculos automáticos
   - Seleccionar método de pago
   - Guardar factura

### Fase 6: Limpiar y documentar
- Eliminar `BillFormProvider` original
- Actualizar imports en todos los archivos
- Documentar nueva arquitectura

---

## Archivos Afectados

### Providers
- ❌ `bill_form_provider.dart` (eliminar)
- ✅ `bill_customer_provider.dart` (crear)
- ✅ `bill_items_provider.dart` (crear)
- ✅ `bill_calculation_provider.dart` (crear)
- ✅ `bill_payment_provider.dart` (crear)
- 🔄 `provider.dart` (actualizar exports)

### Screens
- 🔄 `bill_screen.dart` (actualizar MultiProvider y Selectors)

### Widgets
- 🔄 `customer_selection_widget.dart`
- 🔄 `product_list_widget.dart`
- 🔄 `payment_method_widget.dart`
- 🔄 `bill_totals_widget.dart`
- 🔄 `bill_action_buttons_widget.dart`

### Models
- ✅ `bill_form_data.dart` (ya creado)
- Posiblemente crear más modelos para otros Selectors

---

## Riesgos y Consideraciones

### Riesgos Altos
1. **Romper funcionalidad existente**: Los cálculos automáticos dependen de timing preciso
2. **Sincronización entre providers**: Customer/Items → Calculation debe funcionar correctamente
3. **Muchos archivos afectados**: ~10 archivos necesitan cambios coordinados

### Mitigaciones
1. Implementar por fases, probar cada fase
2. Mantener BillFormProvider original hasta validar nueva implementación
3. Escribir tests unitarios para cada provider nuevo
4. Probar flujo completo: seleccionar cliente → agregar productos → calcular → guardar

### Alternativa: Refactorización Interna
En lugar de separar en múltiples providers, considerar:
- Extraer métodos a clases helper privadas
- Mantener un solo provider pero mejor organizado
- Menos riesgo, menor impacto arquitectónico

---

## Estimación de Esfuerzo
- **Crear providers**: 4-6 horas
- **Configurar comunicación**: 2-3 horas
- **Actualizar BillScreen y widgets**: 3-4 horas
- **Probar y debuggear**: 4-6 horas
- **Documentar**: 1-2 horas

**Total estimado**: 14-21 horas de trabajo

---

## Recomendación
Dado que:
- Es una refactorización de arquitectura mayor
- Alto riesgo de romper funcionalidad crítica
- El código actual funciona correctamente

**Sugerencia**: 
1. Implementar en rama separada
2. Validar exhaustivamente antes de merge
3. O considerar refactorización interna menos invasiva
4. Priorizar según necesidades del proyecto (si hay problemas de performance/mantenibilidad actuales)
