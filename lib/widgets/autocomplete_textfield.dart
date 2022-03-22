import 'dart:async';

import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class AutocompleteTextField extends StatelessWidget {
  const AutocompleteTextField({
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
    this.onSuggestionSelected,
    this.suggestionsCallback,
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
  final void Function(dynamic) onSuggestionSelected;
  final FutureOr<Iterable<dynamic>> Function(String) suggestionsCallback;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: GestureDetector(
        onTap: onTap,
        child: TypeAheadField(
            itemBuilder: (context, suggestion) {
              return SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, top: 12),
                  child: Text(
                    suggestion.toString(),
                    style: AppStyles.semiBoldBlue13,
                  ),
                ),
              );
            },
            hideOnLoading: true,
            hideOnEmpty: true,
            animationDuration: Duration(seconds: 0),
            hideSuggestionsOnKeyboardHide: true,
            suggestionsCallback: suggestionsCallback,
            onSuggestionSelected: onSuggestionSelected,
            textFieldConfiguration: TextFieldConfiguration(
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
              ),
              autocorrect: false,
              enableSuggestions: false,
              textInputAction: TextInputAction.done,
              enableInteractiveSelection: enableInteractiveSelection,
              focusNode: focusNode,
              keyboardType: TextInputType .number,
            )),
      ),
    );
  }
}

// 'A': new RegExp(r'[A-Za-z]'),
// '0': new RegExp(r'[0-9]'),
// '@': new RegExp(r'[A-Za-z0-9]'),
// '*': new RegExp(r'.*')
