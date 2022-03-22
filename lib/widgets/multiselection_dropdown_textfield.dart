import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/input_text_field.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MultiSelectionDropDownTextFormField extends StatefulWidget {
  const MultiSelectionDropDownTextFormField({
    Key key,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 15,
    ),
    this.minimalized = false,
    this.enabled = true,
    @required this.value,
    @required this.values,
    @required this.selectedValues,
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
    this.maxLines = 10,
    this.inputType,
    this.inputFormatters = const <TextInputFormatter>[],
    this.focusNode,
    this.nextFocusNode,
    this.keyboardType = TextInputType.multiline,
    this.validator = UsefullMethods.validateNotNullOrEmpty,
    this.prefixIcon,
    this.fillColor = Colors.white,
    this.filled = true,
    this.onSubmitTap,
  }) : super(key: key);

  final bool enabled;
  final String value;
  final List<String> values;
  final Set<String> selectedValues;
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
  final void Function() onSubmitTap;

  @override
  _MultiSelectionDropDownTextFormFieldState createState() => _MultiSelectionDropDownTextFormFieldState();
}

class _MultiSelectionDropDownTextFormFieldState extends State<MultiSelectionDropDownTextFormField>
    with AutomaticKeepAliveClientMixin<MultiSelectionDropDownTextFormField>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Stack(
      children: [
        Stack(
          children: [
            GestureDetector(
              onTap: () {
                _presentSelectionList();
              },
              child: InputTextField(
                enabled: false,
                controller: widget.controller,
                focusNode: widget.focusNode,
                nextFocusNode: widget.nextFocusNode,
                fillColor: widget.enabled ? widget.fillColor : AppColors.lightestGrey,
                filled: widget.filled,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.enabled ? const DropdownIcon() : null,
                validator: widget.validator,
                inputType: widget.inputType,
                inputFormatters: widget.inputFormatters,
                maxLength: widget.maxLength,
                maxLines: 3,
                labelText: widget.labelText,
                labelSyle: widget.labelSyle,
                contentPadding: widget.contentPadding,
                minimalized: widget.minimalized,
              ),
            ),
          ],
        )
      ],
    );
  }

  void _presentSelectionList() {
    UsefullMethods.unfocus(context);

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
          content: MultiSelectionModal(
            values: widget.values,
            selectedValues: widget.selectedValues,
          ),
          actions: <Widget>[
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.blue),
              ),
              onPressed: widget.onSubmitTap,
              child: const Text(
                'Confirmer',
                style: AppStyles.mediumWhite13,
              ),
            ),
          ],
        );
      },
    ).then((value) {});
  }
}

// ignore: must_be_immutable
class MultiSelectionModal extends StatefulWidget {
  MultiSelectionModal({
    Key key,
    @required this.values,
    @required this.selectedValues,
  }) : super(key: key);

  final List<String> values;
  Set<String> selectedValues = <String>{};
  @override
  _State createState() => _State();
}

class _State extends State<MultiSelectionModal> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: ListTileTheme(
        child: ListBody(
          children: widget.values.map(_buildItem).toList(),
        ),
      ),
    );
  }

  Widget _buildItem(final String item) {
    final checked = widget.selectedValues.contains(item);
    return CheckboxListTile(
      contentPadding: const EdgeInsets.fromLTRB(14.0, 0.0, 25.0, 0.0),
      value: checked,
      title: Text(item),
      activeColor: AppColors.blue,
      selectedTileColor: AppColors.blue,
      controlAffinity: ListTileControlAffinity.leading,
      onChanged: (checked) => _onItemCheckedChange(item, checked),
    );
  }

  void _onItemCheckedChange(String itemValue, bool checked) {
    if (checked) {
      widget.selectedValues.add(itemValue);
    } else {
      widget.selectedValues.remove(itemValue);
    }
    setState(() {});
  }
}
