import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/app/core/password_editing/password_editing_controller.dart';
import 'package:e_loan_mobile/config/colors/app_colors.dart';
import 'package:e_loan_mobile/config/constants/app_constants.dart';
import 'package:e_loan_mobile/config/styles/app_styles.dart';
import 'package:e_loan_mobile/widgets/common_appbar.dart';
import 'package:e_loan_mobile/widgets/safe_area_manager.dart';
import 'package:e_loan_mobile/widgets/vertical_spacing.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class PasswordEditingPage extends StatefulWidget {
  const PasswordEditingPage({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<PasswordEditingPage> {
  final PasswordEditingController controller = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordEditingController>(
      builder: (_) {
        return KeyboardDismissOnTap(
          child: SafeAreaManager(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: const CommonAppBar(),
              body: _buildContent(),
            ),
          ),
        );
      },
    );
  }

  Padding _buildContent() {
    return Padding(
      padding: AppConstants.smallPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalSpacing(27),
          const CommonTitle(title: 'Modifier le mot de passe'),
          _buildEditPasswordForm()
        ],
      ),
    );
  }

  Padding _buildEditPasswordForm() => Padding(
        padding: const EdgeInsets.only(left: 0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: AppConstants.mediumPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const VerticalSpacing(50),
                  _buildInputsAndButton(),
                  _buildSuccessIndicator(),
                ],
              ),
            ),
          ),
        ),
      );

  Visibility _buildInputsAndButton() {
    return Visibility(
      visible: !controller.passwordSettledSuccessfully,
      child: Column(
        children: [
          _buildOldPasswordInput(),
          const VerticalSpacing(11),
          _buildPasswordInput(),
          const VerticalSpacing(11),
          _buildPasswordConfirmationInput(),
          const VerticalSpacing(30),
          _buildIndicationWidget(),
          const VerticalSpacing(55),
          _buildEditPasswordButton(context),
          const VerticalSpacing(30),
        ],
      ),
    );
  }

  Visibility _buildSuccessIndicator() {
    return Visibility(
      visible: controller.passwordSettledSuccessfully,
      child: Column(
        children: [
          const VerticalSpacing(100),
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.darkestBlue.withOpacity(.5),
                    blurRadius: 10,
                    spreadRadius: 10,
                  )
                ],
              ),
              child: const Icon(
                Icons.check,
                size: 120,
                color: AppColors.green,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildOldPasswordInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InputTextField(
          controller: controller.oldPasswordTEC,
          focusNode: controller.oldPasswordFocusNode,
          nextFocusNode: controller.passwordFocusNode,
          obscureText: controller.oldPasswordIsHidden,
          labelText: 'Mot de passe actuel',
          suffixIcon: PasswordVisiblityToggler(
            visibilityCondition: controller.oldPasswordIsHidden,
            onPressed: () {
              controller.oldPasswordIsHidden = !controller.oldPasswordIsHidden;
              controller.update();
            },
          ),
          keyboardType: TextInputType.emailAddress,
          validator: UsefullMethods.isLegalPassword,
        ),
      ],
    );
  }

  InputTextField _buildPasswordInput() {
    return InputTextField(
      controller: controller.passwordTEC,
      focusNode: controller.passwordFocusNode,
      nextFocusNode: controller.confirmationFocusNode,
      obscureText: controller.passwordIsHidden,
      labelText: 'Nouveau mot de passe',
      suffixIcon: PasswordVisiblityToggler(
        visibilityCondition: controller.passwordIsHidden,
        onPressed: () {
          controller.passwordIsHidden = !controller.passwordIsHidden;
          controller.update();
        },
      ),
      keyboardType: TextInputType.emailAddress,
      validator: UsefullMethods.isLegalPassword,
    );
  }

  InputTextField _buildPasswordConfirmationInput() {
    return InputTextField(
      controller: controller.confirmationTEC,
      focusNode: controller.confirmationFocusNode,
      obscureText: controller.confimationIsHidden,
      labelText: 'Confirmation du mot de passe',
      suffixIcon: PasswordVisiblityToggler(
        visibilityCondition: controller.confimationIsHidden,
        onPressed: () {
          controller.confimationIsHidden = !controller.confimationIsHidden;
          controller.update();
        },
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String password) {
        if (password == null || password.isEmpty) {
          return AppConstants.REQUIRED_FIELD;
        }
        if (password != controller.passwordTEC.text) {
          return 'Les deux mots de passe ne correspondent pas !';
        }
        return null;
      },
    );
  }

  Widget _buildIndicationWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const <Widget>[
        HorizontalSpacing(9),
        Icon(
          Icons.info,
          color: AppColors.darkestBlue,
          size: 20,
        ),
        HorizontalSpacing(9),
        Flexible(
          child: Text(
            'Le mot de passe doit comporter au minimum 8 caractères, et doit contenir au moins :\n • 1 lettre majuscule\n • 1 lettre minuscule\n • 1 chiffre\n • 1 caractère spécial : @ # ! _ - /',
            style: AppStyles.mediumGreyBlue12,
          ),
        ),
        HorizontalSpacing(10),
      ],
    );
  }

  CommonButton _buildEditPasswordButton(BuildContext context) {
    return CommonButton(
      title: 'Modifier',
      onPressed: () {
        if (_formKey.currentState.validate()) {
          UsefullMethods.unfocus(context);
          AppConstants.halfSecond.then((_) {
            controller.setPassword();
          });
        }
      },
    );
  }
}
