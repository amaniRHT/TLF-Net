import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/activity_area_model.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/input_text_field.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DropDownTextFormField extends StatelessWidget {
  const DropDownTextFormField(
      {Key key,
      this.contentPadding = const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 15,
      ),
      this.minimalized = false,
      this.enabled = true,
      @required this.value,
      @required this.values,
      this.onDropValueChanged,
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
      this.isActivityAreaDropDown = false,
      this.activityAreaValues})
      : super(key: key);

  final bool enabled;
  final String value;
  final List<String> values;
  final TextEditingController controller;
  final String labelText;
  final TextStyle labelSyle;
  final TextStyle style;
  final void Function() onTap;
  final void Function(String) onDropValueChanged;
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
  final EdgeInsetsGeometry contentPadding;
  final bool minimalized;
  final bool isActivityAreaDropDown;
  final List<ActivityAreaModel> activityAreaValues;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            InputTextField(
              enableInteractiveSelection: false,
              enabled: false,
              controller: controller,
              focusNode: focusNode,
              nextFocusNode: nextFocusNode,
              fillColor: enabled ? fillColor : AppColors.lightestGrey,
              filled: filled,
              prefixIcon: prefixIcon,
              suffixIcon: enabled ? const DropdownIcon() : null,
              validator: validator,
              inputType: inputType,
              inputFormatters: inputFormatters,
              maxLength: maxLength,
              maxLines: 2,
              labelText: labelText,
              labelSyle: labelSyle,
              contentPadding: contentPadding,
              minimalized: minimalized,
            ),
            Padding(
              padding: AppConstants.dropDownPadding,
              child: Opacity(
                opacity: 0,
                child: isActivityAreaDropDown
                    ? DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: value,
                        onChanged: (String value) {
                          UsefullMethods.unfocus(context);
                          onDropValueChanged(value);
                        },
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          errorStyle: AppStyles.errorStyle,
                        ),
                        selectedItemBuilder: (BuildContext context) {
                          return activityAreaValues
                              .map<Text>((ActivityAreaModel activity) {
                            return Text(
                              activity.label,
                              style: AppStyles.mediumBlue14,
                              overflow: TextOverflow.ellipsis,
                            );
                          }).toList();
                        },
                        validator: (value) =>
                            value == null ? AppConstants.REQUIRED_FIELD : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        items: enabled
                            ? List<DropdownMenuItem<String>>.generate(
                                activityAreaValues.length,
                                (int index) {
                                  return DropdownMenuItem(
                                    value: activityAreaValues[index].label,
                                    child: Text(
                                      activityAreaValues[index].label,
                                      style: AppStyles.mediumBlue14,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                    ),
                                  );
                                },
                              )
                            : [],
                      )
                    : DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: value,
                        onChanged: (String value) {
                          UsefullMethods.unfocus(context);
                          onDropValueChanged(value);
                        },
                        decoration: const InputDecoration(
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          errorStyle: AppStyles.errorStyle,
                        ),
                        selectedItemBuilder: (BuildContext context) {
                          return values.map<Text>((String text) {
                            return Text(
                              text,
                              style: AppStyles.mediumBlue14,
                              overflow: TextOverflow.ellipsis,
                            );
                          }).toList();
                        },
                        validator: (value) =>
                            value == null ? AppConstants.REQUIRED_FIELD : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        items: enabled
                            ? List<DropdownMenuItem<String>>.generate(
                                values.length,
                                (int index) {
                                  return DropdownMenuItem(
                                    value: values[index],
                                    child: Text(
                                      values[index],
                                      style: AppStyles.mediumBlue14,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                    ),
                                  );
                                },
                              )
                            : [],
                      ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
