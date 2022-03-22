import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/config/styles/app_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum InputType { numeric, alphabetic, alphaNumeric }

class InputTextField extends StatelessWidget {
  const InputTextField({
    Key key,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 15,
    ),
    this.capitalize = false,
    this.enableInteractiveSelection = true,
    this.minimalized = false,
    this.visible = true,
    this.invisibleText = false,
    this.autofocus = false,
    this.obscureText = false,
    this.enabled = true,
    this.requiredField = true,
    this.initialValue,
    this.controller,
    this.hintText = '',
    this.labelText = '',
    this.style = AppStyles.regularBlue14,
    this.hintStyle = AppStyles.regularDarkGrey12,
    this.labelSyle = AppStyles.regularDarkGrey12,
    this.onChanged,
    this.onSaved,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onTap,
    this.maxLength = 50,
    this.maxLines = 1,
    this.inputType,
    this.inputFormatters = const <TextInputFormatter>[],
    this.focusNode,
    this.nextFocusNode,
    this.keyboardType = TextInputType.multiline,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor = Colors.white,
    this.filled = true,
    this.showErrorText = true,
  }) : super(key: key);

  final bool visible;
  final bool enableInteractiveSelection;
  final bool capitalize;
  final bool invisibleText;
  final bool autofocus;
  final bool enabled;
  final bool requiredField;
  final String initialValue;
  final TextEditingController controller;
  final String hintText;
  final TextStyle hintStyle;
  final String labelText;
  final TextStyle labelSyle;
  final TextStyle style;
  final void Function() onTap;
  final void Function(String) onChanged;
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
  final bool obscureText;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final Color fillColor;
  final bool filled;
  final EdgeInsetsGeometry contentPadding;
  final bool minimalized;
  final bool showErrorText;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: GestureDetector(
        onTap: onTap,
        child: Focus(
          onFocusChange: (bool gainingFocus) {
            // if (!gainingFocus && controller != null)
            //   controller.selection =
            //       TextSelection.fromPosition(TextPosition(offset: 0));
          },
          child: TextFormField(
            textCapitalization:
                capitalize ? TextCapitalization.words : TextCapitalization.none,
            key: key,
            autofocus: autofocus,
            obscureText: obscureText,
            initialValue: initialValue,
            enabled: enabled,
            controller: controller,
            inputFormatters: (maxLength != null || inputType != null)
                ? <TextInputFormatter>[
                    if (maxLength != null)
                      LengthLimitingTextInputFormatter(maxLength),
                    if (inputType != null) _specifyInputType(inputType),
                  ]
                : const <TextInputFormatter>[],
            keyboardType: keyboardType,
            minLines: 1,
            maxLines: maxLines,
            buildCounter: (
              BuildContext context, {
              int currentLength,
              int maxLength,
              bool isFocused,
            }) =>
                null,
            maxLength: maxLength,
            onChanged: onChanged,
            onSaved: onSaved,
            onEditingComplete: () {
              nextFocusNode != null
                  ? nextFocusNode.requestFocus()
                  : focusNode != null
                      ? focusNode.unfocus()
                      : UsefullMethods.unfocus(context);
              if (onEditingComplete != null) onEditingComplete;
            },
            onFieldSubmitted: (String value) {
              nextFocusNode != null
                  ? nextFocusNode.requestFocus()
                  : focusNode != null
                      ? focusNode.unfocus()
                      : UsefullMethods.unfocus(context);
              if (onFieldSubmitted != null) onFieldSubmitted(value);
            },
            style: invisibleText
                ? style.copyWith(color: Colors.transparent)
                : style,
            cursorColor: AppColors.orange,
            cursorHeight: 20,
            decoration: InputDecoration(
              fillColor: fillColor,
              filled: filled,
              hintStyle: hintStyle,
              hintText: hintText,
              labelText: labelText,
              labelStyle: labelSyle,
              errorMaxLines: 4,
              hintMaxLines: 2,
              border: InputBorder.none,
              errorStyle:
                  showErrorText ? AppStyles.errorStyle : TextStyle(height: 0),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.grey),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.grey),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.orange),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.red),
              ),
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.red),
              ),
              contentPadding: minimalized
                  ? const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    )
                  : contentPadding,
              prefixIcon: prefixIcon,
              isDense: true,
              suffixIcon: suffixIcon,
              // suffixIconConstraints: BoxConstraints(
              //   minWidth: 20,
              //   minHeight: 20,
              // ),
            ),
            autocorrect: false,
            enableSuggestions: false,
            textInputAction: TextInputAction.done,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: validator,
            enableInteractiveSelection: enableInteractiveSelection,
            focusNode: focusNode,
          ),
        ),
      ),
    );
  }

  TextInputFormatter _specifyInputType(InputType inputType) {
    switch (inputType) {
      case InputType.numeric:
        return FilteringTextInputFormatter.allow(RegExp(r'[0-9]+|\s'));

      case InputType.alphabetic:
        return FilteringTextInputFormatter.allow(
          RegExp(AppConstants.accentuedRegExp),
        );

      case InputType.alphaNumeric:
        return FilteringTextInputFormatter.allow(
          RegExp(AppConstants.numberedAndAccentuedRegExp),
        );
      default:
        return FilteringTextInputFormatter.allow(RegExp(r'.*'));
    }
  }
}

// 'A': new RegExp(r'[A-Za-z]'),
// '0': new RegExp(r'[0-9]'),
// '@': new RegExp(r'[A-Za-z0-9]'),
// '*': new RegExp(r'.*')
