import 'package:basic_utils/basic_utils.dart';
import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'input_text_field.dart';

// ignore: must_be_immutable
class MonetaryTextField extends StatefulWidget {
  const MonetaryTextField({
    Key key,
    this.contentPadding = const EdgeInsets.symmetric(
      horizontal: 20,
      vertical: 15,
    ),
    this.minimalized = false,
    this.enabled = true,
    this.visible = true,
    this.onDropValueChanged,
    this.controller,
    this.labelText = '',
    this.style = AppStyles.regularBlue14,
    this.labelSyle = AppStyles.regularDarkGrey11,
    this.onChanged,
    this.onSaved,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onTap,
    this.maxLength = 50,
    this.inputType,
    this.inputFormatters = const <TextInputFormatter>[],
    this.focusNode,
    this.nextFocusNode,
    this.keyboardType = TextInputType.multiline,
    this.validator = UsefullMethods.validateNotNullOrEmpty,
    this.prefixIcon,
    this.fillColor = Colors.white,
    this.filled = true,
  }) : super(key: key);

  final bool enabled;
  final bool visible;
  final TextEditingController controller;
  final String labelText;
  final TextStyle labelSyle;
  final TextStyle style;
  final void Function() onTap;
  final void Function(String) onChanged;
  final void Function(String) onDropValueChanged;
  final void Function(String) onSaved;
  final void Function() onEditingComplete;
  final void Function(String) onFieldSubmitted;
  final int maxLength;
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
  @override
  _MonetaryTextFieldState createState() => _MonetaryTextFieldState();
}

class _MonetaryTextFieldState extends State<MonetaryTextField>
    with
        AutomaticKeepAliveClientMixin<MonetaryTextField>,
        TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  String text = '';

  @override
  void initState() {
    text = widget.controller.text;

    widget.controller.addListener(() {
      if (mounted) {
        var fff =
            StringUtils.reverse(widget.controller.text.removeAllWhitespace);
        fff = StringUtils.addCharAtPosition(fff, ' ', 3, repeat: true);
        text = StringUtils.reverse(fff);
        widget.onChanged(widget.controller.text);
        setState(() {});
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Visibility(
      visible: widget.visible,
      child: Stack(
        children: [
          InputTextField(
            enableInteractiveSelection: false,
            visible: widget.visible,
            invisibleText: true,
            controller: widget.controller,
            focusNode: widget.focusNode,
            nextFocusNode: widget.nextFocusNode,
            onChanged: widget.onChanged,
            onSaved: widget.onSaved,
            fillColor:
                widget.enabled ? widget.fillColor : AppColors.lightestGrey,
            filled: widget.filled,
            prefixIcon: widget.prefixIcon,
            validator: widget.validator,
            inputType: InputType.numeric,
            keyboardType: TextInputType.phone,
            inputFormatters: widget.inputFormatters,
            maxLength: widget.maxLength,
            labelText: widget.labelText,
            labelSyle: widget.labelSyle,
            onEditingComplete: widget.onEditingComplete,
            onFieldSubmitted: widget.onFieldSubmitted,
            contentPadding: widget.contentPadding,
            minimalized: widget.minimalized,
          ),
          GestureDetector(
            onTap: () {
              widget.focusNode.requestFocus();
            },
            child: Padding(
              padding: widget.minimalized
                  ? const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    )
                  : widget.contentPadding,
              child: Text(
                UsefullMethods.formatStringWithSpaceEach3Characters(text),
                style: AppStyles.regularBlue14,
              ),
            ),
          )
        ],
      ),
    );
  }
}
