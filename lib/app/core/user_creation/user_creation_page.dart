import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/routes/routing.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import '../../controllers.dart';

class UserCreationPage extends StatefulWidget {
  const UserCreationPage({Key key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<UserCreationPage> {
  final UserCreationController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _functionFormKey = GlobalKey<FormState>();

  final Map<String, dynamic> arguments = Get.arguments as Map<String, dynamic>;

  @override
  void initState() {
    _setupControllerMode();
    super.initState();
  }

  void _setupControllerMode() {
    controller.creationMode = arguments['creationMode'] as bool;
    if (!controller.creationMode) {
      // load User
      controller.currentUserAccount = arguments['data'] as Users;
      controller.getUserDetails(controller.currentUserAccount.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UserCreationController>(
      builder: (_) {
        return KeyboardDismissOnTap(
          child: SafeAreaManager(
            child: Scaffold(
              appBar: const CommonAppBar(),
              body: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpacing(27),
                    Padding(
                      padding: AppConstants.mediumPadding,
                      child: CommonTitle(
                        title: controller.creationMode ? "Création d'un utilisateur" : "Modification d'un utilisateur",
                      ),
                    ),
                    const VerticalSpacing(25),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          children: [
                            Padding(
                              padding: AppConstants.mediumPadding,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    _buildUserInformationsInputs(),
                                    const VerticalSpacing(12),
                                    const RequiredFieldsIndicator(),
                                    const VerticalSpacing(30),
                                    _buildButtons(),
                                    const VerticalSpacing(20),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Column _buildUserInformationsInputs() {
    const double _betweenTextFieldsSpacing = 11;
    String _lastPhoneValue = '';
    String _lastMobileValue = '';
    return Column(
      children: <Widget>[
        const VerticalSpacing(_betweenTextFieldsSpacing),
        _buildRadioGenderSelection(),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          capitalize: true,
          labelText: 'Votre prénom*',
          controller: controller.firstnameTEC,
          focusNode: controller.firstnameFocusNode,
          nextFocusNode: controller.lastnameFocusNode,
          onChanged: (String postalCode) {},
          validator: UsefullMethods.validateNotNullOrEmpty,
          inputType: InputType.alphabetic,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          capitalize: true,
          labelText: 'Votre nom*',
          controller: controller.lastnameTEC,
          focusNode: controller.lastnameFocusNode,
          validator: UsefullMethods.validateNotNullOrEmpty,
          inputType: InputType.alphabetic,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        Form(
          key: _functionFormKey,
          child: DropDownTextFormField(
            value: controller.function,
            values: controller.functions,
            controller: controller.functionTEC,
            labelText: 'Votre fonction*',
            focusNode: controller.functionFocusNode,
            nextFocusNode: controller.phoneFocusNode,
            onDropValueChanged: (value) {
              controller.functionSelected = true;
              controller.functionTEC?.text = value;
              controller.phoneFocusNode.requestFocus();
              _functionFormKey.currentState.validate();
            },
            validator: UsefullMethods.validateNotNullOrEmpty,
          ),
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          labelText: 'Téléphone*',
          controller: controller.phoneTEC,
          focusNode: controller.phoneFocusNode,
          nextFocusNode: controller.mobileFocusNode,
          onChanged: (String value) {
            if (!_lastPhoneValue.endsWith(' ')) {
              if (value.length == 2) {
                controller.phoneTEC.text = '${controller.phoneTEC.text} ';
              } else if (value.length == 5) {
                controller.phoneTEC.text = '${controller.phoneTEC.text} ';
              } else if (value.length == 8) {
                controller.phoneTEC.text = '${controller.phoneTEC.text} ';
              }
              controller.phoneTEC.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.phoneTEC.text.length),
              );
            }
          },
          validator: (String value) {
            _lastPhoneValue = value;
            return UsefullMethods.validPhoneNumber(value);
          },
          maxLength: 11,
          keyboardType: TextInputType.phone,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          labelText: 'Mobile',
          controller: controller.mobileTEC,
          focusNode: controller.mobileFocusNode,
          nextFocusNode: controller.emailFocusNode,
          onChanged: (String value) {
            if (!_lastMobileValue.endsWith(' ')) {
              if (value.length == 2) {
                controller.mobileTEC.text = '${controller.mobileTEC.text} ';
              } else if (value.length == 5) {
                controller.mobileTEC.text = '${controller.mobileTEC.text} ';
              } else if (value.length == 8) {
                controller.mobileTEC.text = '${controller.mobileTEC.text} ';
              }
              controller.mobileTEC.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.mobileTEC.text.length),
              );
            }
          },
          validator: (String value) {
            _lastMobileValue = value;
            return UsefullMethods.validMobileNumber(value);
          },
          maxLength: 11,
          keyboardType: TextInputType.phone,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          labelText: 'Email*',
          controller: controller.emailTEC,
          focusNode: controller.emailFocusNode,
          validator: UsefullMethods.validEmail,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Row _buildRadioGenderSelection() {
    return Row(
      children: <Widget>[
        const Text(
          'Civilité',
          style: AppStyles.mediumBlue14,
          textAlign: TextAlign.left,
        ),
        const HorizontalSpacing(25),
        SizedBox(
          width: 20,
          child: Radio(
            value: Gender.male,
            groupValue: controller.isMale,
            onChanged: (Gender value) {
              controller.isMale = value;
              controller.update();
            },
          ),
        ),
        const HorizontalSpacing(6),
        const Text(
          'Mr',
          style: AppStyles.mediumBlue14,
        ),
        const HorizontalSpacing(16),
        SizedBox(
          width: 20,
          child: Radio(
            value: Gender.female,
            groupValue: controller.isMale,
            onChanged: (Gender value) {
              controller.isMale = value;
              controller.update();
            },
          ),
        ),
        const HorizontalSpacing(6),
        const Text(
          'Mme',
          style: AppStyles.mediumBlue14,
        ),
      ],
    );
  }

  Row _buildButtons() {
    return Row(
      children: [
        Expanded(
          child: CommonButton(
            title: 'Annuler',
            titleColor: AppColors.darkestBlue,
            enabledColor: AppColors.lightBlue,
            onPressed: () {
              showCommonModal(
                modalType: ModalTypes.alert,
                message: Get.find<UserCreationController>().creationMode
                    ? "Êtes-vous sûr de vouloir annuler la création de cet utilisateur ?"
                    : "Êtes-vous sûr de vouloir annuler la modification de cet utilisateur ?",
                buttonTitle: 'Confirmer',
                onPressed: () {
                  Get.back(closeOverlays: true);
                  Get.offAllNamed(AppRoutes.usersList);
                },
                withCancelButton: true,
              );
            },
          ),
        ),
        const HorizontalSpacing(6),
        Expanded(
          child: CommonButton(
              title: controller.creationMode ? 'Créer' : 'Modifier',
              iconOnTheLeft: false,
              onPressed: () {
                bool validInputs = _formKey.currentState.validate();
                bool functionSelected = _functionFormKey.currentState.validate();
                if (validInputs && functionSelected)
                  controller.creationMode ? controller.createUserAccount() : controller.updateUserAccount();
              }),
        ),
      ],
    );
  }
}
