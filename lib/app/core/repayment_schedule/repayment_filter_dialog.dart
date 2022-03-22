import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:get/get.dart';

class RepaymentScheduleFilterDialog extends StatefulWidget {
  const RepaymentScheduleFilterDialog({Key key}) : super(key: key);

  @override
  _RepaymentScheduleFilterDialogState createState() =>
      _RepaymentScheduleFilterDialogState();
}

class _RepaymentScheduleFilterDialogState
    extends State<RepaymentScheduleFilterDialog> {
  final RepaymentScheduleController controller = Get.find();

  final GlobalKey<FormState> _fromDatePickerFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.getContracts();
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: KeyboardDismissOnTap(
        child: GetBuilder<RepaymentScheduleController>(
          builder: (_) {
            return FilterDialog(
              formKey: _formKey,
              filterContent: _buildContent(context),
              onSearchPressed: () {
                controller.setFilterData();
                controller.addTagFilter();
                //controller.setFilterCount();
                Get.back(closeOverlays: true);
                controller.getRepayments();
              },
              onResetPressed: () {
                UsefullMethods.unfocus(context);
                controller.resetTECsAndValidations();
                _formKey.currentState.reset();
                controller.setFilterData();
                controller.getRepayments();
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
        _buildStartDate(context),
        const VerticalSpacing(15),
        AutocompleteTextField(
          labelText: 'Code contrat',
          onSuggestionSelected: (dynamic suggestion) {
            controller.addTag(suggestion);
          },
          suggestionsCallback: (pattern) async {
            return await controller.contractCodeList.where((int option) {
              return option
                  .toString()
                  .toLowerCase()
                  .contains(pattern.toLowerCase());
            });
          },
        ),
        VerticalSpacing(controller.filterTagsList.isEmpty ? 0 : 20),
        Tags(
          spacing: 12,
          alignment: WrapAlignment.start,
          itemCount: controller.filterTagsList.length,
          itemBuilder: (int index) {
            return Tooltip(
              message: controller.filterTagsList[index].toString(),
              child: ItemTags(
                padding: const EdgeInsets.all(10),
                activeColor: AppColors.lightestBlue,
                pressEnabled: false,
                textStyle: AppStyles.semiboldBlue12,
                textActiveColor: AppColors.blue,
                removeButton: ItemTagsRemoveButton(
                  onRemoved: () {
                    controller.removeTag(index);
                    return true;
                  },
                  icon: Icons.close,
                  backgroundColor: AppColors.blue,
                ),
                index: index,
                title: controller.filterTagsList[index].toString(),
              ),
            );
          },
        )
      ],
    );
  }

  Form _buildStartDate(BuildContext context) {
    return _buildDatePicker(context, 'Echéance', _fromDatePickerFormKey,
        controller.fromTEC, controller.fromFocusNode, true, () async {
      final DateTime _pickedDate = await showDatePicker(
        context: context,
        locale: const Locale('fr', 'FR'),
        firstDate: DateTime(2000), //! CONSTANT
        initialDate: controller.fromTEC.text.isEmpty
            ? DateTime.now()
            : controller.fromNotifier.value,
        lastDate: DateTime(3000), //! CONSTANT
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
}
