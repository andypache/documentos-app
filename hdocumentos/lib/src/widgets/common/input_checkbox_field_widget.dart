import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

/// Widget de checkbox controlado por el padre.
/// El padre es responsable de mantener el estado [value] y reaccionar
/// en [onChanged]. Sigue el mismo patrón que [Checkbox] nativo de Flutter.
class InputCheckboxFieldWidget extends StatelessWidget {
  const InputCheckboxFieldWidget({
    Key? key,
    required this.label,
    required this.value,
    this.onChanged,
  }) : super(key: key);

  final String label;

  /// Valor actual del checkbox (controlado por el padre).
  final bool value;

  /// Callback invocado cuando el usuario cambia el estado.
  final ValueChanged<bool?>? onChanged;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return AppTheme.primaryButton;
      }
      return AppTheme.primary;
    }

    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: -3,
      children: [
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: value,
          onChanged: onChanged,
        ),
        Text(label),
      ],
    );
  }
}
