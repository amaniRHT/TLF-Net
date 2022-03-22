import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/Helpers/usefull_metods.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class PasswordSettingPage extends StatefulWidget {
  const PasswordSettingPage({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<PasswordSettingPage> {
  final PasswordSettingController controller = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final String resetCode = Get.arguments as String;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordSettingController>(
      builder: (_) {
        return KeyboardDismissOnTap(
          child: SafeAreaManager(
            child: Scaffold(
              appBar: const CommonAppBar(),
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: AppConstants.mediumPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const VerticalSpacing(50),
                        _buildTitle(),
                        const VerticalSpacing(30),
                        _buildStepping(),
                        const VerticalSpacing(50),
                        _buildInputsAndButton(),
                        _buildSuccessIndicator(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Visibility _buildInputsAndButton() {
    return Visibility(
      visible: !controller.passwordSettledSuccessfully,
      child: Column(
        children: [
          _buildPasswordInput(),
          const VerticalSpacing(11),
          _buildPasswordConfirmationInput(),
          const VerticalSpacing(30),
          _buildIndicationWidget(),
          const VerticalSpacing(55),
          _buildCreateAccountButton(context),
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

  Padding _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            resetCode != null ? 'Changement du mot de passe' : 'Définition du mot de passe',
            style: AppStyles.boldBlue14,
          ),
          const VerticalSpacing(5),
          Container(
            width: 40,
            height: 2,
            color: AppColors.orange,
          )
        ],
      ),
    );
  }

  Column _buildStepping() {
    return resetCode == null
        ? Column(
            children: [
              const ProgressiveStepper(
                done: true,
                stepNumber: 1,
                stepLabel: 'Détails société',
              ),
              ProgressiveStepper(
                done: controller.passwordSettledSuccessfully,
                activeStep: true,
                stepNumber: 2,
                stepLabel: 'Mot de passe',
              ),
              ProgressiveStepper(
                done: controller.passwordSettledSuccessfully,
                activeStep: controller.passwordSettledSuccessfully,
                stepNumber: 3,
                stepLabel: 'Compte validé',
                isLastStep: true,
              ),
            ],
          )
        : Column(
            children: const <ProgressiveStepper>[
              ProgressiveStepper(
                done: true,
                stepNumber: 1,
                stepLabel: 'Saisissez votre email',
              ),
              ProgressiveStepper(
                done: true,
                stepNumber: 2,
                stepLabel: 'Insérez le code reçu',
              ),
              ProgressiveStepper(
                activeStep: true,
                stepNumber: 3,
                stepLabel: 'Réinitialisez votre mot de passe',
                isLastStep: true,
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

  CommonButton _buildCreateAccountButton(BuildContext context) {
    return CommonButton(
      title: 'Valider',
      onPressed: () {
        if (_formKey.currentState.validate()) {
          UsefullMethods.unfocus(context);
          AppConstants.halfSecond.then((_) {
            resetCode == null ? controller.setPassword() : controller.resetPassword(resetCode: resetCode);
          });
        }
      },
    );
  }
}
