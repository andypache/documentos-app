import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Widget para campos switch
class InputSwitchFieldWidget extends StatefulWidget {
  final String label;
  final bool value;
  final void Function(bool) onChanged;
  final String? helperText;

  const InputSwitchFieldWidget({
    Key? key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.helperText,
  }) : super(key: key);

  @override
  State<InputSwitchFieldWidget> createState() => _InputSwitchFieldWidgetState();
}

class _InputSwitchFieldWidgetState extends State<InputSwitchFieldWidget> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(InputSwitchFieldWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _value = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (widget.helperText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      widget.helperText!,
                      style: TextStyle(
                        color: AppTheme.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Switch(
            value: _value,
            onChanged: (v) {
              setState(() => _value = v);
              widget.onChanged(v);
            },
            activeColor: AppTheme.primaryButton,
          ),
        ],
      ),
    );
  }
}
