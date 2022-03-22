import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/Helpers/usefull_metods.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/config/constants/app_constants.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/date_picker_textfield.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<SignupPage> {
  final SignupController controller = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _legalFromFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _activityAreaFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _typeFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _functionFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _datePickerFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _contractCodeFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _clientCodeFormKey = GlobalKey<FormState>();

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SignupController>(
      builder: (_) {
        const double _betweenSectionsSpacing = 22;

        return KeyboardDismissOnTap(
          child: SafeAreaManager(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: const CommonAppBar(),
              body: Padding(
                padding: AppConstants.mediumPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const VerticalSpacing(25),
                    _buildTitle(),
                    const VerticalSpacing(_betweenSectionsSpacing),
                    _buildStepping(),
                    const VerticalSpacing(_betweenSectionsSpacing),
                    Expanded(
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          Scaffold(
                            body: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              controller: _scrollController,
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    _buildLegalFormDropdownWithRequiredInputs(),
                                    _buildIdentityComponents(),
                                    const VerticalSpacing(11),
                                    _buildActivityAreaDropdown(),
                                    const VerticalSpacing(11),
                                    _buildDatePicker(context),
                                    const VerticalSpacing(
                                        _betweenSectionsSpacing),
                                    const Text(
                                      'Êtes-vous ou avez vous été un client Tunisie Leasing & Factoring ?',
                                      style: AppStyles.mediumBlue14,
                                    ),
                                    _buildClientParametersSelection(),
                                    const VerticalSpacing(
                                        _betweenSectionsSpacing),
                                    _sectionTitle(
                                        'Adresse professionnelle ou du siége'),
                                    _buildLocalitySection(),
                                    const VerticalSpacing(
                                        _betweenSectionsSpacing),
                                    _sectionTitle(
                                        'Informations du détenteur du compte TLF-net'),
                                    _buildRadioGenderSelection(),
                                    _buildUserInformationsInputs(),
                                    const VerticalSpacing(12),
                                    const RequiredFieldsIndicator(),
                                    const VerticalSpacing(12),
                                    _buildCheckBoxGeneralConditions(),
                                    KeyboardVisibilityBuilder(builder:
                                        (context, bool keyboardIsVisible) {
                                      return keyboardIsVisible
                                          ? SizedBox(
                                              height: 80,
                                              child: _buildButtons())
                                          : const VerticalSpacing(80);
                                    }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: _buildButtons(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Visibility _buildIdentityComponents() {
    final bool _isPerson = controller.legalFormSelected && controller.isPerson;

    return Visibility(
      visible: _isPerson,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VerticalSpacing(22),
          const Text(
            "Nature de l'identité *",
            style: AppStyles.mediumBlue14,
          ),
          _buildIdentityTypeSelection(),
          _buildIdentityNatureInputs(),
          const VerticalSpacing(11),
        ],
      ),
    );
  }

  Column _buildActivityAreaDropdown() {
    return Column(
      children: [
        Form(
          key: _activityAreaFormKey,
          child: DropDownTextFormField(
            value: controller.activityArea,
            values: [],
            controller: controller.activityAreaTEC,
            focusNode: controller.activityAreaFocusNode,
            isActivityAreaDropDown: true,
            activityAreaValues: AppConstants.activityAreasFullList,
            labelText: "Secteur d'activité*",
            onDropValueChanged: (String value) {
              //  controller.otherActivity =
              value == AppConstants.activityAreasFullList.last.activity;
              controller.activityAreaTEC?.text = value;
              _activityAreaFormKey.currentState.validate();
              controller.update();
            },
          ),
        ),
        // VerticalSpacing(controller.otherActivity ? 11 : 0),
        // InputTextField(
        //   visible: controller.otherActivity,
        //   labelText: 'Activité*',
        //   controller: controller.activityTEC,
        //   focusNode: controller.activityFocusNode,
        //   validator: UsefullMethods.validateNotNullOrEmpty,
        //   inputType: InputType.alphaNumeric,
        // ),
      ],
    );
  }

  Text _sectionTitle(String title) => Text(title, style: AppStyles.boldBlue13);

  Column _buildStepping() {
    return Column(
      children: const <ProgressiveStepper>[
        ProgressiveStepper(
          activeStep: true,
          stepNumber: 1,
          stepLabel: 'Détails société',
        ),
        ProgressiveStepper(
          stepNumber: 2,
          stepLabel: 'Mot de passe',
        ),
        ProgressiveStepper(
          stepNumber: 3,
          stepLabel: 'Compte activé',
          isLastStep: true,
        ),
      ],
    );
  }

  Column _buildClientParametersSelection() {
    final bool _isClient = controller.isClient == Answers.yes;

    final double _betweenTextFieldsSpacing = _isClient ? 11 : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _buildRadioClientSelection(),
        VerticalSpacing(_betweenTextFieldsSpacing),
        Form(
          key: _clientCodeFormKey,
          child: InputTextField(
            visible: _isClient,
            labelText: 'Code client',
            controller: controller.clientCodeTEC,
            focusNode: controller.clientCodeFocusNode,
            nextFocusNode: controller.clientContractFocusNode,
            maxLength: 6,
            inputType: InputType.numeric,
            keyboardType: TextInputType.phone,
            validator: (String value) => UsefullMethods.validateCode(
                value, controller.contractCodeTEC.text),
            showErrorText: false,
            onChanged: (String value) {
              if ((value == null || value.isEmpty) &&
                  (controller.contractCodeTEC.text == null ||
                      controller.contractCodeTEC.text.isEmpty)) {
                controller.isCodeError = true;
                _contractCodeFormKey.currentState.validate();
              } else {
                controller.isCodeError = false;
                _contractCodeFormKey.currentState.validate();
              }
              controller.update();
            },
          ),
        ),
        VerticalSpacing(_betweenTextFieldsSpacing),
        Visibility(
          visible: _isClient,
          child: const Padding(
            padding: EdgeInsets.only(left: 8),
            child: Text(
              'Ou',
              style: AppStyles.mediumBlue14,
            ),
          ),
        ),
        VerticalSpacing(_betweenTextFieldsSpacing),
        Form(
          key: _contractCodeFormKey,
          child: InputTextField(
            visible: _isClient,
            labelText: 'Code contrat',
            controller: controller.contractCodeTEC,
            focusNode: controller.clientContractFocusNode,
            nextFocusNode: controller.streetFocusNode,
            maxLength: 6,
            inputType: InputType.numeric,
            keyboardType: TextInputType.phone,
            validator: (String value) => UsefullMethods.validateCode(
                value, controller.clientCodeTEC.text),
            showErrorText: false,
            onChanged: (String value) {
              if ((value == null || value.isEmpty) &&
                  (controller.clientCodeTEC.text == null ||
                      controller.clientCodeTEC.text.isEmpty)) {
                _clientCodeFormKey.currentState.validate();
                controller.isCodeError = true;
              } else {
                controller.isCodeError = false;
                _clientCodeFormKey.currentState.validate();
              }
              controller.update();
            },
          ),
        ),
        Visibility(
            visible: _isClient,
            child: _buildAmountErrorText(
                padding: const EdgeInsets.only(top: 10, left: 20),
                errorText:
                    'Veuillez renseigner votre code client ou bien code contrat !',
                isError: controller.isCodeError))
      ],
    );
  }

  Visibility _buildAmountErrorText(
      {EdgeInsetsGeometry padding, String errorText, bool isError}) {
    return Visibility(
      visible: isError,
      child: Padding(
        padding: padding,
        child: Text(
          errorText,
          style: AppStyles.errorStyle,
        ),
      ),
    );
  }

  Column _buildLegalFormDropdownWithRequiredInputs() {
    final bool _isPerson = controller.legalFormSelected && controller.isPerson;
    final bool _isSociety =
        controller.legalFormSelected && controller.isSociety;

    final bool _cin = controller.legalFormSelected &&
        controller.isPerson &&
        controller.identityNatue == Identity.cin;

    final double _betweenTextFieldsSpacing = _isPerson ? 11 : 0;
    return Column(
      children: <Widget>[
        const VerticalSpacing(2),
        Form(
          key: _legalFromFormKey,
          child: DropDownTextFormField(
            value: controller.legalForm,
            values: controller.legalForms,
            controller: controller.legalFormTEC,
            labelText: 'Forme juridique*',
            onDropValueChanged: (String value) {
              controller.legalFormTEC?.text = value;
              controller.isPerson = controller.legalForms.first == value;
              controller.isSociety = controller.legalForms.last == value;
              if (controller.isPerson) {
                controller.socialReasonTEC.text = '';
                controller.typeTEC.text = '';
                controller.rneTEC.text = '';
              } else {
                controller.leaglFirstnameTEC.text = '';
                controller.legalLastnameTEC.text = '';
                controller.tradeNameTEC.text = '';
                controller.cinTEC.text = '';
              }
              controller.legalFormSelected = true;
              _legalFromFormKey.currentState.validate();
              controller.update();
            },
          ),
        ),
        VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          capitalize: true,
          visible: _isPerson,
          labelText: 'Prénom*',
          controller: controller.leaglFirstnameTEC,
          focusNode: controller.leaglFirstnameFocusNode,
          nextFocusNode: controller.legalLastnameFocusNode,
          validator: UsefullMethods.validateNotNullOrEmpty,
          inputType: InputType.alphabetic,
        ),
        VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          capitalize: true,
          visible: _isPerson,
          labelText: 'Nom*',
          controller: controller.legalLastnameTEC,
          focusNode: controller.legalLastnameFocusNode,
          nextFocusNode: controller.tradeNameFocusNode,
          validator: UsefullMethods.validateNotNullOrEmpty,
          inputType: InputType.alphabetic,
        ),
        VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          capitalize: true,
          visible: _isPerson,
          labelText: 'Nom commercial',
          controller: controller.tradeNameTEC,
          focusNode: controller.tradeNameFocusNode,
          nextFocusNode: _cin
              ? controller.cinFocusNode
              : controller.residencePermitFocusNode,
          inputType: InputType.alphaNumeric,
        ),
        VerticalSpacing(_isSociety ? 11 : 0),
        Visibility(
          visible: _isSociety,
          child: Form(
            key: _typeFormKey,
            child: DropDownTextFormField(
              value: controller.type,
              values: controller.types,
              controller: controller.typeTEC,
              focusNode: controller.typeFocusNode,
              labelText: 'Type*',
              onDropValueChanged: (String value) {
                controller.typeTEC?.text = value;
                _typeFormKey.currentState.validate();
                controller.update();
              },
            ),
          ),
        ),
        VerticalSpacing(_isSociety ? 11 : 0),
        InputTextField(
          capitalize: true,
          visible: _isSociety,
          labelText: 'Raison sociale*',
          controller: controller.socialReasonTEC,
          focusNode: controller.socialReasonFocusNode,
          nextFocusNode: controller.rneFocusNode,
          validator: UsefullMethods.validateNotNullOrEmpty,
          inputType: InputType.alphaNumeric,
        ),
        VerticalSpacing(_isSociety ? 11 : 0),
        InputTextField(
          visible: _isSociety,
          labelText: 'Identifiant unique (RNE)*',
          controller: controller.rneTEC,
          focusNode: controller.rneFocusNode,
          validator: UsefullMethods.valideRNE,
          maxLength: 8,
          inputType: InputType.alphaNumeric,
        ),
      ],
    );
  }

  Column _buildIdentityNatureInputs() {
    final bool _cin = controller.legalFormSelected &&
        controller.isPerson &&
        controller.identityNatue == Identity.cin;
    final bool _residentPErmit = controller.legalFormSelected &&
        controller.isPerson &&
        controller.identityNatue == Identity.residencePermit;
    return Column(
      children: [
        InputTextField(
          visible: _cin,
          labelText: 'CIN*',
          controller: controller.cinTEC,
          focusNode: controller.cinFocusNode,
          validator: UsefullMethods.validCIN,
          maxLength: 8,
          inputType: InputType.numeric,
          keyboardType: TextInputType.phone,
        ),
        InputTextField(
          visible: _residentPErmit,
          labelText: 'Carte séjour*',
          controller: controller.residencePermitTEC,
          focusNode: controller.residencePermitFocusNode,
          validator: UsefullMethods.validateNotNullOrEmpty,
          inputType: InputType.alphaNumeric,
        ),
      ],
    );
  }

  Column _buildLocalitySection() {
    const double _betweenTextFieldsSpacing = 11;
    return Column(
      children: <Widget>[
        const VerticalSpacing(18),
        InputTextField(
          labelText: 'Rue*',
          controller: controller.streetTEC,
          focusNode: controller.streetFocusNode,
          nextFocusNode: controller.postalCodeFocusNode,
          validator: UsefullMethods.validateNotNullOrEmpty,
          inputType: InputType.alphaNumeric,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          labelText: 'Code postal*',
          controller: controller.postalCodeTEC,
          focusNode: controller.postalCodeFocusNode,
          nextFocusNode: controller.firstnameFocusNode,
          onChanged: (String postalCode) {
            if (postalCode.length == 4) {
              controller.localityTEC.text =
                  getCityByPostalCode(postalCode) ?? '';
              controller.governorateTEC.text =
                  getGovernorateByPostalCode(postalCode) ?? '';
            } else {
              controller.localityTEC.text = '';
              controller.governorateTEC.text = '';
            }
          },
          maxLength: 4,
          inputType: InputType.numeric,
          keyboardType: TextInputType.phone,
          validator: UsefullMethods.validPostalCode,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          enabled: false,
          labelText: 'Localité*',
          controller: controller.localityTEC,
          fillColor: AppColors.lightestGrey,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          enabled: false,
          labelText: 'Gouvernorat*',
          controller: controller.governorateTEC,
          fillColor: AppColors.lightestGrey,
        ),
      ],
    );
  }

  Column _buildUserInformationsInputs() {
    const double _betweenTextFieldsSpacing = 11;
    return Column(
      children: <Widget>[
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          capitalize: true,
          labelText: 'Votre prénom*',
          controller: controller.firstnameTEC,
          focusNode: controller.firstnameFocusNode,
          nextFocusNode: controller.lastnameFocusNode,
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
          ),
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        // PhoneInputTextField(
        //   getXcontroller: controller,
        //   labelText: 'Téléphone*',
        //   controller: controller.phoneTEC,
        //   focusNode: controller.phoneFocusNode,
        //   nextFocusNode: controller.mobileFocusNode,
        //   validator: UsefullMethods.validatePhone,
        //   keyboardType: TextInputType.phone,
        //   onInputValidated: (bool isValid) {
        //     UsefullMethods.phoneNumberIsValid = isValid;
        //   },
        //   onChanged: (PhoneNumber value) {
        //     controller.isoCode = value.isoCode;
        //     controller.update();
        //   },
        // ),
        // const VerticalSpacing(_betweenTextFieldsSpacing),
        // PhoneInputTextField(
        //   getXcontroller: controller,
        //   labelText: 'Mobile',
        //   controller: controller.mobileTEC,
        //   focusNode: controller.mobileFocusNode,
        //   nextFocusNode: controller.emailFocusNode,
        //   validator: UsefullMethods.validateMobilePhone,
        //   keyboardType: TextInputType.phone,
        //   onInputValidated: (bool isValid) {
        //     UsefullMethods.phoneNumberIsValid = isValid;
        //   },
        //   onChanged: (PhoneNumber value) {
        //     controller.isoCode = value.isoCode;
        //     controller.update();
        //   },
        // ),
        InputTextField(
          labelText: 'Téléphone*',
          controller: controller.phoneTEC,
          focusNode: controller.phoneFocusNode,
          nextFocusNode: controller.mobileFocusNode,
          validator: UsefullMethods.validPhoneNumber,
          maxLength: 11,
          keyboardType: TextInputType.phone,
        ),
        const VerticalSpacing(_betweenTextFieldsSpacing),
        InputTextField(
          labelText: 'Mobile',
          controller: controller.mobileTEC,
          focusNode: controller.mobileFocusNode,
          nextFocusNode: controller.emailFocusNode,
          validator: UsefullMethods.validMobileNumber,
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

  Form _buildDatePicker(BuildContext context) {
    return Form(
      key: _datePickerFormKey,
      child: DatePickerTextField(
        controller: controller.entryDateTEC,
        focusNode: controller.entryDateFocusNode,
        labelText: "Date d'entrée en activité*",
        onTap: () async {
          final DateTime _pickedDate = await showDatePicker(
            context: context,
            locale: const Locale('fr', 'FR'),
            initialDate: DateTime.now(),
            firstDate: DateTime.utc(1950),
            lastDate: DateTime.now(),
          );
          UsefullMethods.unfocus(context);
          if (_pickedDate != null) {
            controller.iso8601EntryDate = _pickedDate.toIso8601String();
            controller.entryDateTEC.text =
                UsefullMethods.toAbbreviatedDate(_pickedDate, 'fr-FR');
            _datePickerFormKey.currentState.validate();
          }
        },
      ),
    );
  }

  Row _buildRadioClientSelection() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 20,
          child: Radio(
            value: Answers.yes,
            groupValue: controller.isClient,
            onChanged: (Answers value) {
              controller.isClient = value;
              controller.isCodeError = false;

              controller.update();
            },
          ),
        ),
        const HorizontalSpacing(6),
        const Text(
          'Oui',
          style: AppStyles.mediumBlue14,
        ),
        const HorizontalSpacing(16),
        SizedBox(
          width: 20,
          child: Radio(
            value: Answers.no,
            groupValue: controller.isClient,
            onChanged: (Answers value) {
              controller.isClient = value;
              controller.clientCodeTEC.text = '';
              controller.contractCodeTEC.text = '';
              controller.update();
            },
          ),
        ),
        const HorizontalSpacing(6),
        const Text(
          'Non',
          style: AppStyles.mediumBlue14,
        ),
      ],
    );
  }

  Row _buildIdentityTypeSelection() {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 20,
          child: Radio(
            value: Identity.cin,
            groupValue: controller.identityNatue,
            onChanged: (Identity value) {
              controller.identityNatue = value;
              controller.residencePermitTEC.text = '';
              controller.update();
            },
          ),
        ),
        const HorizontalSpacing(6),
        const Text(
          'CIN',
          style: AppStyles.mediumBlue14,
        ),
        const HorizontalSpacing(16),
        SizedBox(
          width: 20,
          child: Radio(
            value: Identity.residencePermit,
            groupValue: controller.identityNatue,
            onChanged: (Identity value) {
              controller.identityNatue = value;
              controller.cinTEC.text = '';
              controller.update();
            },
          ),
        ),
        const HorizontalSpacing(6),
        const Text(
          'Carte séjour',
          style: AppStyles.mediumBlue14,
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
        const HorizontalSpacing(16),
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
      ],
    );
  }

  Padding _buildTitle() {
    return Padding(
      padding: const EdgeInsets.only(left: 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Création de compte', style: AppStyles.boldBlue14),
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

  Row _buildButtons() {
    return Row(
      children: [
        _buildHaveAccountButton(),
        const HorizontalSpacing(6),
        _buildCreateAccountButton(),
      ],
    );
  }

  Column _buildCheckBoxGeneralConditions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Theme(
                data: ThemeData(
                  unselectedWidgetColor: controller.isErrorGeneralConditions
                      ? AppColors.red
                      : AppColors.grey,
                  toggleableActiveColor: AppColors.orange,
                ),
                child: Checkbox(
                  checkColor: Colors.white,
                  value: controller.generalConditionsAccepted,
                  onChanged: (bool value) {
                    controller.generalConditionsAccepted = value;
                    controller.update();
                  },
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: GestureDetector(
                  onTap: () => launch(
                    AppConstants.GENERAL_CONDITION_URL,
                    forceSafariVC: true,
                  ),
                  child: Text(
                    "j'ai lu et j'accepte les conditions générales d'utilisation",
                    style: AppStyles.mediumBlue13,
                    textAlign: TextAlign.left,
                  ),
                ),
              ),
            ),
          ],
        ),
        controller.isErrorGeneralConditions
            ? Padding(
                padding: EdgeInsets.fromLTRB(20, 5, 0, 0),
                child: Text(
                  AppConstants.REQUIRED_FIELD,
                  style: AppStyles.errorStyle,
                ),
              )
            : Text(""),
      ],
    );
  }

  Expanded _buildHaveAccountButton() {
    return Expanded(
      child: CommonButton(
        title: "J'ai un compte",
        enabledColor: AppColors.lightBlue,
        titleColor: AppColors.darkestBlue,
        onPressed: () async {
          UsefullMethods.unfocus(context);
          await 0.5.delay();
          Get.back();
        },
      ),
    );
  }

  Expanded _buildCreateAccountButton() {
    return Expanded(
      child: CommonButton(
        title: 'Créer',
        onPressed: () {
          if (fakeData) {
            Get.offAllNamed(AppRoutes.passwordSetting);
            return;
          }
          final bool _validlegalFrom =
              _legalFromFormKey.currentState.validate();
          final bool _validActivityArea =
              _activityAreaFormKey.currentState.validate();
          final bool _type = _typeFormKey?.currentState?.validate() ?? true;
          final bool validEntryDate =
              _datePickerFormKey.currentState.validate();
          final bool _validFunction = _functionFormKey.currentState.validate();
          final bool _validClientCode =
              _clientCodeFormKey.currentState.validate();
          final bool _validContractCode =
              _contractCodeFormKey.currentState.validate();
          final bool _validInputs = _formKey.currentState.validate();

          if (_validInputs &&
              _validlegalFrom &&
              _type &&
              _validActivityArea &&
              _validFunction &&
              validEntryDate &&
              (_validClientCode || _validContractCode) &&
              controller.generalConditionsAccepted) {
            controller.isCodeError = false;
            controller.isErrorGeneralConditions = false;
            controller.update();
            UsefullMethods.unfocus(context);
            AppConstants.halfSecond.then((_) {
              controller.createAccout();
            });
          } else {
            if (!_validClientCode ||
                !_validContractCode ||
                !controller.generalConditionsAccepted) {
              controller.isCodeError = true;
              controller.isErrorGeneralConditions = true;
              controller.update();
            }

            _scrollController.animateTo(
              0,
              duration: const Duration(milliseconds: 1000),
              curve: Curves.ease,
            );
          }
        },
      ),
    );
  }
}
