import 'package:e_loan_mobile/Helpers/usefull_metods.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/app/core/request_creation/request_creation_controller.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';

class InformationsTabView extends StatefulWidget {
  const InformationsTabView({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<InformationsTabView> {
  final RequestCreationController controller = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await 0.3.delay();
      controller.validateForms();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppConstants.mediumPadding,
      child: Column(
        children: [
          _buildStepping(),
          const VerticalSpacing(10),
          Expanded(
            child: Stack(
              children: [
                Scaffold(
                  body: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 20,
                    ),
                    child: _buildContent(),
                  ),
                ),
                _buildIndicatorAndButtons(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column _buildStepping() {
    return Column(
      children: const <Widget>[
        ProgressiveStepper(
          activeStep: true,
          stepNumber: 1,
          stepLabel: 'Bien à financer',
        ),
        ProgressiveStepper(
          stepNumber: 2,
          stepLabel: 'Jointure des documents',
        ),
        ProgressiveStepper(
          stepNumber: 3,
          stepLabel: 'Envoyer la demande !',
          isLastStep: true,
        ),
      ],
    );
  }

  Column _buildContent() {
    final bool _oldCar = controller.selectedFundingType == FundingTypes.oldCar;
    final bool _newCar = controller.selectedFundingType == FundingTypes.newCar;
    final bool _materialOrEquipement = controller.selectedFundingType == FundingTypes.materialOrEquipement;
    final bool _landOrLocals = controller.selectedFundingType == FundingTypes.landOrLocals;

    final bool _allButOldCar = _newCar || _materialOrEquipement || _landOrLocals;

    final bool _commonField = _oldCar || _newCar || _materialOrEquipement || _landOrLocals;

    const double _betweenTextFieldsSpacing = 11;

    final bool _invalidCarAge =
        _oldCar && controller.carAgeTEC.text.isNotEmpty && int.tryParse(controller.carAgeTEC.text) > 47;

    return Column(
      children: <Widget>[
        Form(
          key: controller.fundingTypeFormKey,
          child: DropDownTextFormField(
            value: controller.fundingType,
            values: controller.fundingTypes,
            controller: controller.fundingTypeTEC,
            labelText: 'Type de bien*',
            onDropValueChanged: onDropValueChanged,
          ),
        ),
        const VerticalSpacing(7),
        _buildRadioCarTypeSelection(),
        Form(
          key: controller.informationsFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VerticalSpacing(_oldCar ? _betweenTextFieldsSpacing : 0),
              Focus(
                onFocusChange: (_) {
                  controller.update();
                },
                child: InputTextField(
                  visible: _oldCar,
                  labelText: 'Age du véhicule (En mois)*',
                  controller: controller.carAgeTEC,
                  focusNode: controller.carAgeFocusNode,
                  nextFocusNode: controller.objectFocusNode,
                  validator: UsefullMethods.validateNumberOfMonths,
                  maxLength: 3,
                  maxLines: 2,
                  inputType: InputType.numeric,
                  keyboardType: TextInputType.phone,
                ),
              ),
              if (_invalidCarAge) const VerticalSpacing(4),
              if (_invalidCarAge)
                Row(
                  children: [
                    const HorizontalSpacing(18),
                    Flexible(
                      child: Text(
                        "Veuillez noter que la limite d'âge pour les véhicules d'occasion est de 48 mois",
                        style: AppStyles.regularDarkGrey12.copyWith(
                          fontSize: 12,
                          color: AppColors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              const VerticalSpacing(_betweenTextFieldsSpacing),
              InputTextField(
                visible: _commonField,
                labelText: 'Objet*',
                controller: controller.objectTEC,
                focusNode: controller.objectFocusNode,
                nextFocusNode: _oldCar
                    ? controller.totalPriceFocusNode
                    : _newCar
                        ? controller.htPriceFocusNode
                        : _materialOrEquipement
                            ? controller.providerFocusNode
                            : controller.sellerFocusNode,
                validator: UsefullMethods.validateNotNullOrEmpty,
                inputType: InputType.alphaNumeric,
                maxLength: 100,
              ),
              VerticalSpacing(_materialOrEquipement ? _betweenTextFieldsSpacing : 0),
              InputTextField(
                visible: _materialOrEquipement,
                labelText: 'Fournisseur',
                controller: controller.providerTEC,
                focusNode: controller.providerFocusNode,
                nextFocusNode: controller.htPriceFocusNode,
                inputType: InputType.alphaNumeric,
              ),
              VerticalSpacing(_landOrLocals ? _betweenTextFieldsSpacing : 0),
              InputTextField(
                visible: _landOrLocals,
                labelText: 'Vendeur',
                controller: controller.sellerTEC,
                focusNode: controller.sellerFocusNode,
                nextFocusNode: controller.htPriceFocusNode,
                inputType: InputType.alphaNumeric,
              ),
              VerticalSpacing(_landOrLocals ? _betweenTextFieldsSpacing : 0),
              _buildRadioPropertyTitleSelection(),
              VerticalSpacing(_oldCar ? _betweenTextFieldsSpacing : 0),
              MonetaryTextField(
                visible: _oldCar,
                labelText: 'Prix total (DT)*',
                controller: controller.totalPriceTEC,
                focusNode: controller.totalPriceFocusNode,
                nextFocusNode: controller.selfFinancingFocusNode,
                validator: UsefullMethods.validateNonNullPrice,
                maxLength: 11,
                inputType: InputType.numeric,
                keyboardType: TextInputType.phone,
                onChanged: (String value) {
                  //!  update %
                  final int totalPrice = UsefullMethods.toSafeInteger(value);
                  final int selfF = UsefullMethods.toSafeInteger(controller.selfFinancingTEC.text);
                  controller.percentageTEC.text = UsefullMethods.calculatePercentage(selfF, totalPrice);
                },
              ),
              VerticalSpacing(_allButOldCar ? _betweenTextFieldsSpacing : 0),
              MonetaryTextField(
                visible: _allButOldCar,
                labelText: 'Prix HT (DT)*',
                controller: controller.htPriceTEC,
                focusNode: controller.htPriceFocusNode,
                nextFocusNode: controller.tvaFocusNode,
                validator: UsefullMethods.validateNonNullPrice,
                maxLength: 11,
                inputType: InputType.numeric,
                keyboardType: TextInputType.phone,
                onChanged: (String value) {
                  //?  HT+ TVA
                  final int tva = UsefullMethods.toSafeInteger(controller.tvaTEC.text);
                  final int htPrice = UsefullMethods.toSafeInteger(value);
                  final int ttcPrice = htPrice + tva;
                  controller.ttcPriceTEC.text = UsefullMethods.formatIntegerWithSpaceEach3Characters(ttcPrice);

                  //!  update %
                  final int totalPrice = UsefullMethods.toSafeInteger(controller.ttcPriceTEC.text);
                  final int selfF = UsefullMethods.toSafeInteger(controller.selfFinancingTEC.text);
                  controller.percentageTEC.text = UsefullMethods.calculatePercentage(selfF, totalPrice);
                },
              ),
              VerticalSpacing(_allButOldCar ? _betweenTextFieldsSpacing : 0),
              MonetaryTextField(
                visible: _allButOldCar,
                labelText: 'TVA (DT)*',
                controller: controller.tvaTEC,
                focusNode: controller.tvaFocusNode,
                nextFocusNode: controller.selfFinancingFocusNode,
                validator: UsefullMethods.validatePrice,
                maxLength: 11,
                inputType: InputType.numeric,
                keyboardType: TextInputType.phone,
                onChanged: (String value) {
                  //?  HT+ TVA
                  final int htPrice = UsefullMethods.toSafeInteger(controller.htPriceTEC.text);
                  final int tva = UsefullMethods.toSafeInteger(value);
                  final int ttcPrice = htPrice + tva;
                  controller.ttcPriceTEC.text = UsefullMethods.formatIntegerWithSpaceEach3Characters(ttcPrice);

                  //!  update %
                  final int totalPrice = UsefullMethods.toSafeInteger(controller.ttcPriceTEC.text);
                  final int selfF = UsefullMethods.toSafeInteger(controller.selfFinancingTEC.text);
                  controller.percentageTEC.text = UsefullMethods.calculatePercentage(selfF, totalPrice);
                },
              ),
              VerticalSpacing(_allButOldCar ? _betweenTextFieldsSpacing : 0),
              InputTextField(
                enabled: false,
                fillColor: AppColors.lightestGrey,
                visible: _allButOldCar,
                labelText: 'Prix T.T.C (DT)*',
                controller: controller.ttcPriceTEC,
                focusNode: controller.ttcPriceFocusNode,
                nextFocusNode: controller.percentageFocusNode,
                maxLength: 13,
                inputType: InputType.numeric,
                keyboardType: TextInputType.phone,
              ),
              const VerticalSpacing(_betweenTextFieldsSpacing),
              MonetaryTextField(
                visible: _commonField,
                labelText: 'Autofinancement T.T.C (DT)*',
                controller: controller.selfFinancingTEC,
                focusNode: controller.selfFinancingFocusNode,
                nextFocusNode: controller.durationFocusNode,
                maxLength: 11,
                inputType: InputType.numeric,
                keyboardType: TextInputType.phone,
                validator: (String value) {
                  return _oldCar
                      ? UsefullMethods.validateSelfFunding(
                          oldCar: true,
                          value: value,
                          maximum: controller.totalPriceTEC.text,
                        )
                      : UsefullMethods.validateSelfFunding(
                          oldCar: false,
                          value: value,
                          maximum: controller.ttcPriceTEC.text,
                        );
                },
                onChanged: (String value) {
                  //!  update %
                  final int selfF = UsefullMethods.toSafeInteger(value);

                  final int target = controller.selectedFundingType == FundingTypes.oldCar
                      ? UsefullMethods.toSafeInteger(controller.totalPriceTEC.text)
                      : UsefullMethods.toSafeInteger(controller.ttcPriceTEC.text);

                  controller.percentageTEC.text = UsefullMethods.calculatePercentage(selfF, target);
                },
              ),
              const VerticalSpacing(_betweenTextFieldsSpacing),
              InputTextField(
                enabled: false,
                fillColor: AppColors.lightestGrey,
                visible: _commonField,
                labelText: 'Autofinancement en % *',
                controller: controller.percentageTEC,
                focusNode: controller.percentageFocusNode,
                nextFocusNode: controller.durationFocusNode,
                maxLength: 2,
                inputType: InputType.numeric,
                keyboardType: TextInputType.phone,
              ),
              const VerticalSpacing(_betweenTextFieldsSpacing),
              InputTextField(
                visible: _commonField,
                labelText: 'Durée (En mois)*',
                controller: controller.durationTEC,
                focusNode: controller.durationFocusNode,
                validator: UsefullMethods.validateNumberOfMonths,
                maxLength: 3,
                inputType: InputType.numeric,
                keyboardType: TextInputType.phone,
              ),
              const VerticalSpacing(20),
              if (controller.fundingTypeSelected) const RequiredFieldsIndicator(),
              KeyboardVisibilityBuilder(builder: (context, bool keyboardIsVisible) {
                return (keyboardIsVisible)
                    ? SizedBox(height: 80, child: _buildIndicatorAndButtons())
                    : const VerticalSpacing(60);
              })
            ],
          ),
        ),
      ],
    );
  }

  Visibility _buildRadioCarTypeSelection() {
    return Visibility(
      visible: controller.selectedFundingType == FundingTypes.car ||
          controller.selectedFundingType == FundingTypes.newCar ||
          controller.selectedFundingType == FundingTypes.oldCar,
      child: Row(
        children: <Widget>[
          const Text(
            'Neuf',
            style: AppStyles.mediumBlue14,
            textAlign: TextAlign.left,
          ),
          const HorizontalSpacing(25),
          SizedBox(
            width: 20,
            child: Radio(
              value: CarStates.newCar,
              groupValue: controller.carState,
              onChanged: (CarStates value) {
                controller.carState = value;
                controller.selectedFundingType = FundingTypes.newCar;
                _resetTECsAndValidations();
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
              value: CarStates.oldCar,
              groupValue: controller.carState,
              onChanged: (CarStates value) {
                controller.carState = value;
                controller.selectedFundingType = FundingTypes.oldCar;
                _resetTECsAndValidations();
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
      ),
    );
  }

  Visibility _buildRadioPropertyTitleSelection() {
    return Visibility(
      visible: controller.selectedFundingType == FundingTypes.landOrLocals,
      child: Row(
        children: <Widget>[
          const Text(
            'Titre de propriété*',
            style: AppStyles.mediumBlue14,
            textAlign: TextAlign.left,
          ),
          const HorizontalSpacing(25),
          SizedBox(
            width: 20,
            child: Radio(
              value: Answers.yes,
              groupValue: controller.propertyTitle,
              onChanged: (Answers value) {
                controller.propertyTitle = value;
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
              groupValue: controller.propertyTitle,
              onChanged: (Answers value) {
                controller.propertyTitle = value;

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
      ),
    );
  }

  void onDropValueChanged(String value) {
    if (controller.fundingType != value) {
      controller.fundingType = value;
      controller.fundingTypeTEC?.text = value;
      controller.fundingTypeSelected = true;

      if (value == controller.fundingTypes[0]) {
        controller.selectedFundingType = FundingTypes.newCar;
        controller.carState = CarStates.newCar;
      } else if (value == controller.fundingTypes[1]) {
        controller.selectedFundingType = FundingTypes.materialOrEquipement;
      } else {
        controller.selectedFundingType = FundingTypes.landOrLocals;
      }
      _resetTECsAndValidations();
      controller.fundingTypeFormKey.currentState.validate();
      controller.update();
      controller.getDocumentsforType();
    }
  }

  void _resetTECsAndValidations() {
    UsefullMethods.unfocus(context);
    controller.informationsFormKey.currentState.reset();
    controller.reinitialiseTECs();
  }

  Column _buildIndicatorAndButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: CommonButton(
                title: 'Annuler',
                titleColor: AppColors.darkestBlue,
                enabledColor: AppColors.lightBlue,
                onPressed: () {
                  showCommonModal(
                    modalType: ModalTypes.alert,
                    message: Get.find<RequestCreationController>().creationMode
                        ? 'Êtes-vous sûr de vouloir annuler la création de votre demande ?'
                        : 'Êtes-vous sûr de vouloir annuler la modification de votre demande ?',
                    buttonTitle: 'Confirmer',
                    onPressed: () {
                      Get.back(closeOverlays: true);
                      Get.offAllNamed(AppRoutes.requestsList);
                    },
                    withCancelButton: true,
                  );
                },
              ),
            ),
            const HorizontalSpacing(6),
            Expanded(
              child: CommonButton(
                title: 'Suivant',
                iconOnTheLeft: false,
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 17,
                ),
                onPressed: () {
                  controller.tabController.animateTo(1);
                  controller.firstTabIsValid = controller.fundingTypeFormKey.currentState.validate() &&
                      controller.informationsFormKey.currentState.validate();
                },
              ),
            ),
          ],
        ),
        const VerticalSpacing(12),
      ],
    );
  }
}
