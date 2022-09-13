import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Create general widget for check input all application
class InputCheckboxFieldWidget extends StatefulWidget {
  const InputCheckboxFieldWidget(
      {Key? key, this.onChanged, required this.label})
      : super(key: key);
  final Function(bool?)? onChanged;
  final String label;

  //Create state for widget check input
  @override
  State<InputCheckboxFieldWidget> createState() =>
      _InputCheckboxFieldWidgetState();
}

//State
class _InputCheckboxFieldWidgetState extends State<InputCheckboxFieldWidget> {
  bool isChecked = false;

  //Create widget
  @override
  Widget build(BuildContext context) {
    //Create color for input check
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

    //Create wrap for check
    return Wrap(
      direction: Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: -3,
      children: [
        Checkbox(
            checkColor: Colors.white,
            fillColor: MaterialStateProperty.resolveWith(getColor),
            value: isChecked,
            onChanged: (v) => _onCheckedChanged()),
        Text(widget.label)
      ],
    );
  }

  //Check changed
  _onCheckedChanged() {
    setState(() {
      isChecked = !isChecked;
    });
    if (widget.onChanged != null) {
      widget.onChanged!.call(isChecked);
    }
  }
}
