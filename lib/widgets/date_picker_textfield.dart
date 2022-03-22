import 'package:e_loan_mobile/Helpers/usefull_metods.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/input_text_field.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DatePickerTextField extends StatelessWidget {
  const DatePickerTextField({
    Key key,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 15,
    ),
    this.minimalized = false,
    this.enabled = true,
    this.controller,
    this.labelText = '',
    this.style = AppStyles.regularBlue14,
    this.labelSyle = AppStyles.regularDarkGrey11,
    this.onSaved,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onTap,
    this.maxLength = 50,
    this.maxLines = 2,
    this.inputType,
    this.inputFormatters = const <TextInputFormatter>[],
    this.focusNode,
    this.nextFocusNode,
    this.keyboardType = TextInputType.multiline,
    this.validator = UsefullMethods.validateNotNullOrEmpty,
    this.prefixIcon,
    this.fillColor = Colors.white,
    this.filled = true,
    this.visible = true,
  }) : super(key: key);

  final bool enabled;
  final TextEditingController controller;
  final String labelText;
  final TextStyle labelSyle;
  final TextStyle style;
  final void Function() onTap;
  final void Function(String) onSaved;
  final void Function() onEditingComplete;
  final void Function(String) onFieldSubmitted;
  final int maxLength;
  final int maxLines;
  final InputType inputType;
  final List<TextInputFormatter> inputFormatters;
  final FocusNode focusNode;
  final FocusNode nextFocusNode;
  final TextInputType keyboardType;
  final String Function(String) validator;
  final Widget prefixIcon;
  final Color fillColor;
  final bool filled;
  final bool visible;
  final EdgeInsetsGeometry contentPadding;
  final bool minimalized;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: InputTextField(
        enableInteractiveSelection: false,
        enabled: false,
        controller: controller,
        focusNode: focusNode,
        nextFocusNode: nextFocusNode,
        fillColor: fillColor,
        filled: filled,
        prefixIcon: prefixIcon,
        suffixIcon: enabled ? _buildCalendarIcon() : null,
        validator: validator,
        inputType: inputType,
        inputFormatters: inputFormatters,
        maxLength: maxLength,
        maxLines: maxLines,
        labelText: labelText,
        labelSyle: labelSyle,
        visible: visible,
        contentPadding: contentPadding,
        minimalized: minimalized,
      ),
    );
  }

  Padding _buildCalendarIcon() {
    return Padding(
      padding: const EdgeInsets.all(14.0),
      child: Image.asset(
        AppImages.calendar,
        height: 10,
        width: 10,
      ),
    );
  }
}
