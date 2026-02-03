import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Widget para campos switch
class InputSwitchFieldWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (helperText != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      helperText!,
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
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryButton,
          ),
        ],
      ),
    );
  }
}
