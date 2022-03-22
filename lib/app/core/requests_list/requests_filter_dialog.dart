import 'package:flutter/material.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class RequestsFilterDialog<T extends CommonRequestsListController> extends StatelessWidget {
  RequestsFilterDialog({Key key}) : super(key: key);

  final T controller = Get.find<T>();

  final GlobalKey<FormState> _fromDatePickerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _toDatePickerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _requestStatusFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _fundingTypeFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: KeyboardDismissOnTap(
        child: GetBuilder<T>(
          builder: (_) {
            return FilterDialog(
              formKey: _formKey,
              filterContent: _buildContent(context),
              onSearchPressed: controller.amountControlErrorText.isEmpty
                  ? () {
                      controller.setFilterData();
                      controller.addTag();
                      Get.back(closeOverlays: true);
                      controller.getRequests(fromBeginnig: true);
                    }
                  : () {},
              onResetPressed: () {
                _resetTECsAndValidations(context);
                controller.setFilterData();
                controller.getRequests(fromBeginnig: true);
                Get.back(closeOverlays: true);
              },
            );
          },
        ),
      ),
    );
  }

  Column _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFilterTitle('Date de création'),
        const VerticalSpacing(9),
        _buildStartDate(context),
        const VerticalSpacing(16),
        _buildLastDate(context),
        const VerticalSpacing(16),
        _buildFilterTitle('Montant de Financement (HT)'),
        const VerticalSpacing(9),
        Row(
          children: [
            _buildMinAmount(),
            _buildMaxAmount(),
          ],
        ),
        _buildAmountErrorText(),
        const VerticalSpacing(16),
        _buildFundingTypeDropDown(),
        const VerticalSpacing(16),
        _buildRequestStatusDropDown(),
      ],
    );
  }

  Form _buildLastDate(BuildContext context) {
    return _buildDatePicker(context, 'A', _toDatePickerFormKey, controller.toTEC, controller.toFocusNode, true, () async {
      final DateTime _pickedDate = await showDatePicker(
        context: context,
        locale: const Locale('fr', 'FR'),
        firstDate: controller.fromNotifier == null ? DateTime.utc(2000) : controller.fromNotifier.value,
        initialDate: controller.toTEC.text.isEmpty ? DateTime.now() : controller.toDateTime,
        lastDate: DateTime.now(), //! CONSTANT
      );

      UsefullMethods.unfocus(context);
      if (_pickedDate != null) {
        controller.toNotifier = ValueNotifier<DateTime>(_pickedDate);
        controller.toDate = _pickedDate;
        controller.toDateTime = _pickedDate;
        controller.toDateAsISO8601 = _pickedDate.toIso8601String();
        controller.toTEC.text = UsefullMethods.toAbbreviatedDate(_pickedDate, 'fr-FR');
        controller.update();
        _toDatePickerFormKey.currentState.validate();
      }
    });
  }

  Form _buildStartDate(BuildContext context) {
    return _buildDatePicker(context, 'De', _fromDatePickerFormKey, controller.fromTEC, controller.fromFocusNode, true, () async {
      final DateTime _pickedDate = await showDatePicker(
        context: context,
        locale: const Locale('fr', 'FR'),
        firstDate: DateTime(2000), //! CONSTANT
        initialDate: controller.fromTEC.text.isEmpty
            ? controller.toNotifier == null
                ? DateTime.now()
                : controller.toNotifier.value
            : controller.fromDateTime,
        lastDate: controller.toNotifier == null ? DateTime.now() : controller.toNotifier.value,
      );
      UsefullMethods.unfocus(context);
      if (_pickedDate != null) {
        controller.fromNotifier = ValueNotifier<DateTime>(_pickedDate);
        controller.fromDateTime = _pickedDate;
        controller.fromDate = _pickedDate;
        controller.fromDateAsISO8601 = controller.fromDateTime.toIso8601String();
        controller.fromTEC.text = UsefullMethods.toAbbreviatedDate(controller.fromDateTime, 'fr-FR');
        controller.update();
        _fromDatePickerFormKey.currentState.validate();
      }
    });
  }

  Expanded _buildMaxAmount() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 6),
        child: _buildAmountTextField(
            labelText: 'Max',
            textEditingController: controller.maxAmountTEC,
            focusNode: controller.maxAmountFocusNode,
            onChanged: (String value) {
              if (value != null && value.isNotEmpty && controller.minAmountTEC.text != null && controller.minAmountTEC.text.isNotEmpty) {
                if (double.tryParse(value.removeAllWhitespace) <= double.tryParse(controller.minAmountTEC.text.removeAllWhitespace)) {
                  controller.setAmountError(true, 2);
                } else {
                  controller.setAmountError(false, 0);
                }
              } else {
                controller.setAmountError(false, 0);
              }
            }),
      ),
    );
  }

  Expanded _buildMinAmount() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(right: 6),
        child: _buildAmountTextField(
          labelText: 'Min',
          textEditingController: controller.minAmountTEC,
          focusNode: controller.minAmountFocusNode,
          nextFocusNode: controller.maxAmountFocusNode,
          onChanged: (String value) {
            if (value != null && value.isNotEmpty && controller.maxAmountTEC.text != null && controller.maxAmountTEC.text.isNotEmpty) {
              if (double.tryParse(value.removeAllWhitespace) >= double.tryParse(controller.maxAmountTEC.text.removeAllWhitespace)) {
                controller.setAmountError(true, 1);
              } else {
                controller.setAmountError(false, 0);
              }
            } else {
              controller.setAmountError(false, 0);
            }
          },
        ),
      ),
    );
  }

  Visibility _buildAmountErrorText() {
    return Visibility(
      visible: controller.isError,
      child: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Text(
          controller.amountControlErrorText,
          style: AppStyles.errorStyle,
        ),
      ),
    );
  }

  Form _buildDatePicker(
    BuildContext context,
    String labelText,
    GlobalKey<FormState> key,
    TextEditingController textEditingController,
    FocusNode focusNode,
    bool visible,
    void Function() onTap,
  ) {
    return Form(
      key: key,
      child: DatePickerTextField(
        visible: visible,
        controller: textEditingController,
        focusNode: focusNode,
        labelText: labelText,
        onTap: onTap,
      ),
    );
  }

  Text _buildFilterTitle(String title) => Text(title, style: AppStyles.semiBoldBlue11);

  Form _buildAmountTextField({
    String labelText,
    GlobalKey<FormState> key,
    TextEditingController textEditingController,
    FocusNode focusNode,
    FocusNode nextFocusNode,
    Function(String) onChanged,
    String Function(String) validator,
  }) {
    return Form(
      key: key,
      child: MonetaryTextField(
        labelText: labelText,
        controller: textEditingController,
        focusNode: focusNode,
        nextFocusNode: nextFocusNode,
        maxLength: 11,
        inputType: InputType.numeric,
        keyboardType: TextInputType.phone,
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }

  Form _buildFundingTypeDropDown() {
    return Form(
      key: _fundingTypeFormKey,
      child: MultiSelectionDropDownTextFormField(
        onSubmitTap: () {
          controller.setSelectedFundingTypes();
        },
        selectedValues: controller.selectedFundingTypesList,
        value: controller.fundingType,
        values: controller.fundingTypes,
        controller: controller.fundingTypeTEC,
        labelText: 'Type de bien',
        onDropValueChanged: (String value) {
          if (true) {}
        },
      ),
    );
  }

  Form _buildRequestStatusDropDown() {
    return Form(
      key: _requestStatusFormKey,
      child: MultiSelectionDropDownTextFormField(
        onSubmitTap: () {
          controller.setSelectedRequestStatus();
        },
        selectedValues: controller.selectedRequestStatusList,
        value: controller.requestStatus,
        values: controller.requestStatusList,
        controller: controller.requestStatusTEC,
        labelText: 'Statut de la demande',
        onDropValueChanged: (String value) {
          controller.requestStatusTEC?.text = value;
          controller.requestStatusText = controller.requestStatusTEC.text;
          controller.requestStatusSelected = true;
          _requestStatusFormKey.currentState.validate();
          controller.update();
        },
      ),
    );
  }

  void _resetTECsAndValidations(final BuildContext context) {
    UsefullMethods.unfocus(context);
    controller.resetTECs();
    _formKey.currentState.reset();
    controller.filterCount = 0;
    controller.update();
  }
}
