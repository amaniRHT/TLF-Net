import 'package:e_loan_mobile/app/common_controller.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/config/styles/app_styles.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneInputTextField extends StatelessWidget {
  const PhoneInputTextField({
    Key key,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 15,
    ),
    this.minimalized = false,
    this.visible = true,
    this.invisibleText = false,
    this.autofocus = false,
    this.obscureText = false,
    this.enabled = true,
    this.requiredField = true,
    this.controller,
    this.hintText = '',
    this.labelText = '',
    this.style = AppStyles.regularBlue14,
    this.hintStyle = AppStyles.regularDarkGrey12,
    this.labelSyle = AppStyles.regularDarkGrey12,
    this.onChanged,
    this.onInputValidated,
    this.onSaved,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onTap,
    this.maxLength = 50,
    this.maxLines = 1,
    this.focusNode,
    this.nextFocusNode,
    this.keyboardType = TextInputType.multiline,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.fillColor = Colors.white,
    this.filled = true,
    this.showErrorText = true,
    this.getXcontroller,
  }) : super(key: key);

  final bool visible;
  final bool invisibleText;
  final bool autofocus;
  final bool enabled;
  final bool requiredField;
  final TextEditingController controller;
  final String hintText;
  final TextStyle hintStyle;
  final String labelText;
  final TextStyle labelSyle;
  final TextStyle style;
  final void Function() onTap;
  final void Function(PhoneNumber) onChanged;
  final void Function(bool) onInputValidated;
  final void Function(String) onSaved;
  final void Function() onEditingComplete;
  final void Function(String) onFieldSubmitted;
  final int maxLength;
  final int maxLines;
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
  final CommonController getXcontroller;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: GestureDetector(
        onTap: onTap,
        child: InternationalPhoneNumberInput(
          selectorConfig: SelectorConfig(
            selectorType: PhoneInputSelectorType.DIALOG,
            showFlags: true,
            useEmoji: false,
            trailingSpace: false,
            setSelectorButtonAsPrefixIcon: false,
          ),
          searchBoxDecoration: InputDecoration(
            fillColor: fillColor,
            filled: filled,
            labelText: 'Taper le nom du pays',
            labelStyle: labelSyle,
            errorMaxLines: 4,
            hintMaxLines: 2,
            border: InputBorder.none,
            enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.grey),
            ),
            focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            contentPadding: minimalized
                ? const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 7,
                  )
                : contentPadding,
          ),
          initialValue: PhoneNumber(isoCode: getXcontroller.isoCode),
          isEnabled: enabled,
          textFieldController: controller,
          formatInput: true,
          onInputValidated: onInputValidated,
          keyboardType: TextInputType.phone,
          maxLength: maxLength,
          onInputChanged: onChanged,
          textStyle:
              invisibleText ? style.copyWith(color: Colors.transparent) : style,
          cursorColor: AppColors.orange,

          inputDecoration: InputDecoration(
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
          autoValidateMode: AutovalidateMode.onUserInteraction,

          keyboardAction: TextInputAction.done,
          validator: validator,
          focusNode: focusNode,
          locale: 'TU',
          //countries: [],
          selectorButtonOnErrorPadding: 0,
          spaceBetweenSelectorAndTextField: 5,
        ),
      ),
    );
  }
}

// 'A': new RegExp(r'[A-Za-z]'),
// '0': new RegExp(r'[0-9]'),
// '@': new RegExp(r'[A-Za-z0-9]'),
// '*': new RegExp(r'.*')
