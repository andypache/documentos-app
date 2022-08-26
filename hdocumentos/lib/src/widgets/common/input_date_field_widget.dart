import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:hdocumentos/src/theme/app_theme.dart';

///Create general widget for text input date all application
class InputDateFieldWidget extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final IconData? icon;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool? filled;
  final Color? fillColor;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  //Constructor class
  const InputDateFieldWidget(
      {Key? key,
      this.hintText,
      this.labelText,
      this.helperText,
      this.icon,
      this.prefixIcon,
      this.suffixIcon,
      this.validator,
      this.onChanged,
      this.filled,
      this.fillColor})
      : super(key: key);

  @override
  State<InputDateFieldWidget> createState() => _InputDateFieldWidgetState();
}

//Class state for change calendar
class _InputDateFieldWidgetState extends State<InputDateFieldWidget> {
  //Create widget
  final TextEditingController _date = TextEditingController();

  //Build
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: _date,
        keyboardType: TextInputType.phone,
        autocorrect: false,
        onTap: () async {
          // Below line stops keyboard from appearing
          FocusScope.of(context).requestFocus(FocusNode());
          // Show Date Picker Here
          DateTime? date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100));
          if (date != null) {
            setState(() {
              _date.text = DateFormat('dd/MM/yyyy').format(date);
            });
          } else {
            _date.text = "";
          }
        },
        autofocus: false,
        validator: widget.validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: _inputDecoration());
  }

  //Create widget decoration
  InputDecoration _inputDecoration() {
    return InputDecoration(
        filled: widget.filled ?? false,
        fillColor: widget.fillColor ?? AppTheme.whiteGradient,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        prefixIcon: widget.prefixIcon == null
            ? const Icon(
                Icons.calendar_today_outlined,
                color: AppTheme.primaryButton,
              )
            : Icon(
                widget.prefixIcon,
                color: AppTheme.primaryButton,
              ),
        suffixIcon: widget.suffixIcon == null
            ? null
            : Icon(widget.suffixIcon, color: AppTheme.primaryButton),
        icon: widget.icon == null
            ? null
            : Icon(widget.icon, color: AppTheme.primaryButton),
        //enabledBorder: const UnderlineInputBorder(
        //    borderSide: BorderSide(color: AppTheme.secondary)),
        //focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppTheme.secondary)),
        labelStyle: const TextStyle(color: AppTheme.grey));
  }
}
