import 'package:flutter/material.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:get/get.dart';

class UsersFilterDialog extends StatefulWidget {
  const UsersFilterDialog({Key key}) : super(key: key);

  @override
  _UsersFilterDialogState createState() => _UsersFilterDialogState();
}

class _UsersFilterDialogState extends State<UsersFilterDialog> {
  final UsersListController controller = Get.find();

  final GlobalKey<FormState> _userNameFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _userStatusFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UsersListController>(
      builder: (_) {
        return FilterDialog(
          formKey: _formKey,
          filterContent: _buildContent(),
          onSearchPressed: () {
            _emailFormKey.currentState.validate()
                ? {
                    controller.setFilterData(),
                    controller.addTag(),
                    Get.back(closeOverlays: true),
                    controller.getUsersAccounts()
                  }
                : () {};
          },
          onResetPressed: () {
            _resetTECsAndValidations();
            controller.setFilterData();
            controller.getUsersAccounts();
            Get.back(closeOverlays: true);
          },
        );
      },
    );
  }

  Column _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUsersNameDropDown(),
        const VerticalSpacing(16),
        _buildEmailTextField(),
        const VerticalSpacing(16),
        _buildUserStatusDropDown(),
      ],
    );
  }

  Form _buildUsersNameDropDown() {
    return Form(
      key: _userNameFormKey,
      child: MultiSelectionDropDownTextFormField(
        onSubmitTap: () {
          controller.setSelectedUsersNames();
        },
        selectedValues: controller.selectedUsersNamesList,
        value: controller.userName,
        values: controller.userFullNames,
        controller: controller.userNamesTEC,
        labelText: 'Noms des utilisateurs',
        onDropValueChanged: (String value) {
          if (true) {}
        },
      ),
    );
  }

  Form _buildEmailTextField() {
    return Form(
      key: _emailFormKey,
      child: InputTextField(
        controller: controller.emailTEC,
        focusNode: controller.emailFocusNode,
        //nextFocusNode: controller.passwordFocusNode,
        labelText: 'Email',
        keyboardType: TextInputType.emailAddress,
        validator: UsefullMethods.validEmailFormat,
      ),
    );
  }

  Form _buildUserStatusDropDown() {
    return Form(
      key: _userStatusFormKey,
      child: MultiSelectionDropDownTextFormField(
        onSubmitTap: () {
          controller.setSelectedUserStatus();
        },
        selectedValues: controller.selectedUserStatusList,
        value: controller.userStatus,
        values: controller.userStatusList,
        controller: controller.userStatusTEC,
        labelText: "Statut",
        onDropValueChanged: (String value) {
          controller.userStatusTEC?.text = value;
          controller.userStatusText = controller.userStatusTEC.text;
          controller.userStatusSelected = true;
          _userStatusFormKey.currentState.validate();
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
