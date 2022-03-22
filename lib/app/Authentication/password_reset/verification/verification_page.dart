import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/Helpers/usefull_metods.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<VerificationPage> {
  final VerificationController controller = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final String email = Get.arguments as String;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerificationController>(
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
                        const CommonTitle(title: 'Changer le mot de passe'),
                        const VerticalSpacing(30),
                        _buildStepping(),
                        const VerticalSpacing(100),
                        _buildPinCode(),
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

  Center _buildPinCode() {
    return Center(
      child: SizedBox(
        width: 300,
        child: PinCodeTextField(
          appContext: context,
          pastedTextStyle: TextStyle(
            color: Colors.green.shade600,
            fontWeight: FontWeight.bold,
          ),
          textStyle: AppStyles.mediumBlue14.copyWith(
            color: Colors.white,
            fontSize: 18,
          ),
          length: 6,
          animationType: AnimationType.fade,
          pinTheme: PinTheme(
            shape: PinCodeFieldShape.box,
            borderRadius: AppConstants.regularBorderRadius,
            fieldHeight: 50,
            fieldWidth: 40,
            activeFillColor: AppColors.blue.withOpacity(0.8),
            inactiveColor: Colors.grey,
            inactiveFillColor: AppColors.lightestGrey,
            borderWidth: .6,
            selectedFillColor: AppColors.lightBlue,
            disabledColor: Colors.red,
          ),
          cursorColor: Colors.blueAccent,
          animationDuration: const Duration(milliseconds: 300),
          enableActiveFill: true,
          keyboardType: TextInputType.number,
          boxShadows: const <BoxShadow>[
            BoxShadow(
              offset: Offset(0, 1),
              color: Colors.black12,
              blurRadius: 3,
            )
          ],
          onChanged: (String value) {
            controller.resetCode = value;
          },
          beforeTextPaste: (text) {
            return false;
          },
          errorTextSpace: 40,
          autovalidateMode: AutovalidateMode.disabled,
        ),
      ),
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
          done: true,
          stepNumber: 1,
          stepLabel: 'Saisissez votre email',
        ),
        ProgressiveStepper(
          activeStep: true,
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

  CommonButton _buildCreateAccountButton(BuildContext context) {
    return CommonButton(
      title: 'Confirmer',
      onPressed: () {
        if (_formKey.currentState.validate()) {
          UsefullMethods.unfocus(context);
          AppConstants.halfSecond.then((_) {
            controller.checkResetCode();
          });
        }
      },
    );
  }
}
