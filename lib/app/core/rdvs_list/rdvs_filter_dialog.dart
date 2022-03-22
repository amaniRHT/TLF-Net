import 'package:e_loan_mobile/config/config.dart';
import 'package:flutter/material.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class RDVsFilterDialog extends StatefulWidget {
  const RDVsFilterDialog({Key key}) : super(key: key);

  @override
  _RDVsFilterDialogState createState() => _RDVsFilterDialogState();
}

class _RDVsFilterDialogState extends State<RDVsFilterDialog> {
  final RDVsListController controller = Get.find();

  final GlobalKey<FormState> _fromDatePickerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _toDatePickerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _requestStatusFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _objectFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: KeyboardDismissOnTap(
        child: GetBuilder<RDVsListController>(
          builder: (_) {
            return FilterDialog(
              formKey: _formKey,
              filterContent: _buildContent(context),
              onSearchPressed: () {
                controller.setFilterData();
                controller.addTag();
                Get.back(closeOverlays: true);
                controller.getRDVs();
              },
              onResetPressed: () {
                _resetTECsAndValidations();
                controller.setFilterData();
                controller.getRDVs();
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
        const VerticalSpacing(35),
        _buildObjectTextField(),
        const VerticalSpacing(16),
        _buildRequestStatusDropDown(),
      ],
    );
  }

  Form _buildLastDate(BuildContext context) {
    return _buildDatePicker(context, 'A', _toDatePickerFormKey,
        controller.toTEC, controller.toFocusNode, true, () async {
      final DateTime _pickedDate = await showDatePicker(
        context: context,
        locale: const Locale('fr', 'FR'),
        firstDate: controller.fromNotifier == null
            ? DateTime.utc(2000)
            : controller.fromNotifier.value,
        initialDate: controller.toTEC.text.isEmpty
            ? DateTime.now()
            : controller.toDateTime,
        lastDate: DateTime.now(), //! CONSTANT
      );

      UsefullMethods.unfocus(context);
      if (_pickedDate != null) {
        controller.toNotifier = ValueNotifier<DateTime>(_pickedDate);
        controller.toDate = _pickedDate;
        controller.toDateTime = _pickedDate;
        controller.toDateAsISO8601 = _pickedDate.toIso8601String();
        controller.toTEC.text =
            UsefullMethods.toAbbreviatedDate(_pickedDate, 'fr-FR');
        controller.update();
        _toDatePickerFormKey.currentState.validate();
      }
    });
  }

  Form _buildStartDate(BuildContext context) {
    return _buildDatePicker(context, 'De', _fromDatePickerFormKey,
        controller.fromTEC, controller.fromFocusNode, true, () async {
      final DateTime _pickedDate = await showDatePicker(
        context: context,
        locale: const Locale('fr', 'FR'),
        firstDate: DateTime(2000), //! CONSTANT
        initialDate: controller.fromTEC.text.isEmpty
            ? controller.toNotifier == null
                ? DateTime.now()
                : controller.toNotifier.value
            : controller.fromDateTime,
        lastDate: controller.toNotifier == null
            ? DateTime.now()
            : controller.toNotifier.value,
      );
      UsefullMethods.unfocus(context);
      if (_pickedDate != null) {
        controller.fromNotifier = ValueNotifier<DateTime>(_pickedDate);
        controller.fromDateTime = _pickedDate;
        controller.fromDate = _pickedDate;
        controller.fromDateAsISO8601 =
            controller.fromDateTime.toIso8601String();
        controller.fromTEC.text =
            UsefullMethods.toAbbreviatedDate(controller.fromDateTime, 'fr-FR');
        controller.update();
        _fromDatePickerFormKey.currentState.validate();
      }
    });
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

  Text _buildFilterTitle(String title) =>
      Text(title, style: AppStyles.semiBoldBlue11);

  Form _buildObjectTextField() {
    return Form(
      key: _objectFormKey,
      child: InputTextField(
        controller: controller.objectTEC,
        focusNode: controller.objectFocusNode,
        labelText: "Objet du RDV",
        keyboardType: TextInputType.text,
        labelSyle: AppStyles.regularDarkGrey11,
      ),
    );
  }

  Form _buildRequestStatusDropDown() {
    return Form(
      key: _requestStatusFormKey,
      child: MultiSelectionDropDownTextFormField(
        onSubmitTap: () {
          controller.setSelectedStatus();
        },
        selectedValues: controller.selectedStatusList,
        value: controller.requestStatus,
        values: controller.requestStatusList,
        controller: controller.statusTEC,
        labelText: 'Statut de la demande',
        onDropValueChanged: (String value) {
          controller.statusTEC?.text = value;
          controller.statusText = controller.statusTEC.text;
          controller.requestStatusSelected = true;
          _requestStatusFormKey.currentState.validate();
          controller.update();
        },
      ),
    );
  }

  void _resetTECsAndValidations() {
    UsefullMethods.unfocus(context);
    controller.resetTECs();
    _formKey.currentState.reset();
    controller.filterCount = 0;
    controller.update();
  }
}
