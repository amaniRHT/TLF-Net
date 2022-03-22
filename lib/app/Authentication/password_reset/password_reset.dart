import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/Helpers/usefull_metods.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class PasswordResetPage extends StatefulWidget {
  const PasswordResetPage({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<PasswordResetPage> {
  final PasswordResetController controller = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PasswordResetController>(
      builder: (_) {
        return KeyboardDismissOnTap(
          child: SafeAreaManager(
            child: Scaffold(
              appBar: const CommonAppBar(),
              body: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: AppConstants.mediumPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const VerticalSpacing(50),
                        const CommonTitle(title: 'Changer le mot de passe'),
                        const VerticalSpacing(30),
                        _buildStepping(),
                        const VerticalSpacing(60),
                        _buildEmailInput(),
                        const VerticalSpacing(55),
                        _buildCreateAccountButton(context),
                        const VerticalSpacing(16),
                        _buildReturnButton(),
                        const VerticalSpacing(30),
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

  CommonButton _buildReturnButton() {
    return CommonButton(
      title: 'Retour',
      enabledColor: AppColors.lightBlue,
      titleColor: AppColors.darkestBlue,
      onPressed: () {
        Get.back();
      },
    );
  }

  Column _buildStepping() {
    return Column(
      children: const <ProgressiveStepper>[
        ProgressiveStepper(
          activeStep: true,
          stepNumber: 1,
          stepLabel: 'Saisissez votre email',
        ),
        ProgressiveStepper(
          stepNumber: 2,
          stepLabel: 'Insérez le code reçu',
        ),
        ProgressiveStepper(
          stepNumber: 3,
          stepLabel: 'Réinitialisez votre mot de passe',
          isLastStep: true,
        ),
      ],
    );
  }

  SizedBox _buildEmailInput() {
    return SizedBox(
      height: 80,
      child: InputTextField(
        controller: controller.emailTEC,
        labelText: 'Email',
        keyboardType: TextInputType.emailAddress,
        validator: UsefullMethods.validEmail,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const HorizontalSpacing(4),
              Image.asset(
                AppImages.person,
                height: 27,
              ),
              const HorizontalSpacing(12),
              Container(
                width: 1,
                height: 26,
                color: AppColors.grey,
              )
            ],
          ),
        ),
      ),
    );
  }

  CommonButton _buildCreateAccountButton(BuildContext context) {
    return CommonButton(
      title: 'Confirmer',
      onPressed: () {
        if (_formKey.currentState.validate()) {
          UsefullMethods.unfocus(context);
          AppConstants.halfSecond.then((_) {
            controller.forgotPassword();
          });
        }
      },
    );
  }
}
