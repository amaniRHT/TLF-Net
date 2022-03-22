import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/app/core/quotation_creation/quotation_creation_controller.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/routes/routing.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class QuotationCreationPage extends StatefulWidget {
  const QuotationCreationPage({Key key}) : super(key: key);
  @override
  _State createState() => _State();
}

class _State extends State<QuotationCreationPage> {
  final QuotationCreationController controller = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, dynamic> arguments = Get.arguments as Map<String, dynamic>;

  @override
  void initState() {
    _setupControllerMode();
    super.initState();
    _validateFormAfterBuild();
  }

  void _validateFormAfterBuild() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await 0.3.delay();
      controller.validateForms();
    });
  }

  void _setupControllerMode() {
    controller.creationMode = arguments['creationMode'] as bool;
    if (!controller.creationMode) {
      controller.currentRequest = arguments['data'] as Request;

      if (arguments['shouldLoadWS'] as bool)
        controller.getRequestDetails(controller.currentRequest.id);
      else
        controller.fillFieldsWithRequestDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<QuotationCreationController>(
      builder: (_) {
        return KeyboardDismissOnTap(
          child: SafeAreaManager(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: const CommonAppBar(),
              body: Stack(
                children: [
                  Scaffold(
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const VerticalSpacing(27),
                        Padding(
                          padding: AppConstants.mediumPadding,
                          child: CommonTitle(
                            title: controller.creationMode
                                ? "Création d'une demande de cotation"
                                : "Modification d'une demande de cotation",
                          ),
                        ),
                        const VerticalSpacing(12),
                        _buildActionsWidget(),
                        const VerticalSpacing(20),
                        Expanded(
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                _buildContent(),
                                KeyboardVisibilityBuilder(
                                    builder: (context, bool keyboardIsVisible) {
                                  return (keyboardIsVisible)
                                      ? SizedBox(
                                          height: 80, child: _buildButtons())
                                      : const VerticalSpacing(60);
                                })
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Row _buildActionsWidget() {
    final bool deletableRequest =
        !controller.creationMode && controller.currentRequest.status == 0;
    return Row(
      children: [
        const Spacer(),
        Container(
            width: deletableRequest ? 100 : 50,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: AppConstants.largeBorderRadius,
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.darkestBlue.withOpacity(0.3),
                  blurRadius: 5,
                )
              ],
            ),
            child: controller.creationMode
                ? SaveWidget(
                    onTap: _onSavePressed,
                  )
                : deletableRequest
                    ? SaveOrDeleteWidget(
                        onSaveTapped: _onSavePressed,
                        onDeleteTapped: () {
                          _onDeleteTapped(
                            requestId: controller.currentRequest.id,
                            requestCode: controller.currentRequest.code,
                          );
                        },
                      )
                    : SaveWidget(
                        onTap: _onSavePressed,
                      )),
        const HorizontalSpacing(20)
      ],
    );
  }

  void _onSavePressed() async {
    UsefullMethods.unfocus(context);
    await 0.25.delay();
    if (controller.fundingTypeSelected)
      controller.creationMode
          ? controller.createRequest(withCreatedStatus: true)
          : controller.updateRequest(withCreatedStatus: true);
    else {
      controller.shouldValidateForms = true;
      controller.validateForms();
      showCustomToast(
        toastType: ToastTypes.error,
        contentText: 'Vous devez choisir le type du bien',
        onTheTop: false,
        blurEffectEnabled: false,
        padding: 65,
      );
    }
  }

  void _onDeleteTapped({int requestId, String requestCode}) async {
    UsefullMethods.unfocus(context);
    await 0.25.delay();
    showCommonModal(
      modalType: ModalTypes.alert,
      message: 'Êtes-vous sûr de vouloir supprimer cette demande ?',
      buttonTitle: 'Confirmer',
      onPressed: () {
        Get.back(closeOverlays: true);

        controller.deleteRequest(
          requestId: requestId,
          requestCode: requestCode,
          forQuotationPurpose: true,
        );
      },
      withCancelButton: true,
    );
  }

  Padding _buildContent() {
    final bool _oldCar = controller.selectedFundingType == FundingTypes.oldCar;
    final bool _newCar = controller.selectedFundingType == FundingTypes.newCar;
    final bool _materialOrEquipement =
        controller.selectedFundingType == FundingTypes.materialOrEquipement;
    final bool _landOrLocals =
        controller.selectedFundingType == FundingTypes.landOrLocals;

    final bool _allButOldCar =
        _newCar || _materialOrEquipement || _landOrLocals;

    final bool _commonField =
        _oldCar || _newCar || _materialOrEquipement || _landOrLocals;

    const double _betweenTextFieldsSpacing = 11;

    final bool _invalidCarAge = _oldCar &&
        controller.carAgeTEC.text.isNotEmpty &&
        int.tryParse(controller.carAgeTEC.text) > 47;

    return Padding(
      padding: AppConstants.mediumPadding,
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const VerticalSpacing(10),
            Form(
              key: controller.fundingTypeFormKey,
              child: Column(
                children: [
                  DropDownTextFormField(
                    value: controller.fundingType,
                    values: controller.fundingTypes,
                    controller: controller.fundingTypeTEC,
                    labelText: 'Type de bien*',
                    onDropValueChanged: onDropValueChanged,
                  ),
                  const VerticalSpacing(_betweenTextFieldsSpacing),
                ],
              ),
            ),
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
                  VerticalSpacing(
                      _materialOrEquipement ? _betweenTextFieldsSpacing : 0),
                  InputTextField(
                    visible: _materialOrEquipement,
                    labelText: 'Fournisseur',
                    controller: controller.providerTEC,
                    focusNode: controller.providerFocusNode,
                    nextFocusNode: controller.htPriceFocusNode,
                    inputType: InputType.alphaNumeric,
                  ),
                  VerticalSpacing(
                      _landOrLocals ? _betweenTextFieldsSpacing : 0),
                  InputTextField(
                    visible: _landOrLocals,
                    labelText: 'Vendeur',
                    controller: controller.sellerTEC,
                    focusNode: controller.sellerFocusNode,
                    nextFocusNode: controller.htPriceFocusNode,
                    inputType: InputType.alphaNumeric,
                  ),
                  VerticalSpacing(
                      _landOrLocals ? _betweenTextFieldsSpacing : 0),
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
                      final int totalPrice =
                          UsefullMethods.toSafeInteger(value);
                      final int selfF = UsefullMethods.toSafeInteger(
                          controller.selfFinancingTEC.text);
                      controller.percentageTEC.text =
                          UsefullMethods.calculatePercentage(selfF, totalPrice);
                    },
                  ),
                  VerticalSpacing(
                      _allButOldCar ? _betweenTextFieldsSpacing : 0),
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
                      final int tva =
                          UsefullMethods.toSafeInteger(controller.tvaTEC.text);
                      final int htPrice = UsefullMethods.toSafeInteger(value);
                      final int ttcPrice = htPrice + tva;
                      controller.ttcPriceTEC.text =
                          UsefullMethods.formatIntegerWithSpaceEach3Characters(
                              ttcPrice);

                      //!  update %
                      final int totalPrice = UsefullMethods.toSafeInteger(
                          controller.ttcPriceTEC.text);
                      final int selfF = UsefullMethods.toSafeInteger(
                          controller.selfFinancingTEC.text);
                      controller.percentageTEC.text =
                          UsefullMethods.calculatePercentage(selfF, totalPrice);
                    },
                  ),
                  VerticalSpacing(
                      _allButOldCar ? _betweenTextFieldsSpacing : 0),
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
                      final int htPrice = UsefullMethods.toSafeInteger(
                          controller.htPriceTEC.text);
                      final int tva = UsefullMethods.toSafeInteger(value);
                      final int ttcPrice = htPrice + tva;
                      controller.ttcPriceTEC.text =
                          UsefullMethods.formatIntegerWithSpaceEach3Characters(
                              ttcPrice);

                      //!  update %
                      final int totalPrice = UsefullMethods.toSafeInteger(
                          controller.ttcPriceTEC.text);
                      final int selfF = UsefullMethods.toSafeInteger(
                          controller.selfFinancingTEC.text);
                      controller.percentageTEC.text =
                          UsefullMethods.calculatePercentage(selfF, totalPrice);
                    },
                  ),
                  VerticalSpacing(
                      _allButOldCar ? _betweenTextFieldsSpacing : 0),
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

                      final int target =
                          controller.selectedFundingType == FundingTypes.oldCar
                              ? UsefullMethods.toSafeInteger(
                                  controller.totalPriceTEC.text)
                              : UsefullMethods.toSafeInteger(
                                  controller.ttcPriceTEC.text);

                      controller.percentageTEC.text =
                          UsefullMethods.calculatePercentage(selfF, target);
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
                    nextFocusNode: controller.turnoverIncomeFocusNode,
                    validator: UsefullMethods.validateNumberOfMonths,
                    maxLength: 3,
                    inputType: InputType.numeric,
                    keyboardType: TextInputType.phone,
                  ),
                  const VerticalSpacing(_betweenTextFieldsSpacing),
                  MonetaryTextField(
                    visible: controller.fundingTypeSelected,
                    labelText: 'Revenus/Chiffres d’affaires*',
                    controller: controller.turnoverIncomeTEC,
                    focusNode: controller.turnoverIncomeFocusNode,
                    nextFocusNode: controller.netIncomeFocusNode,
                    validator: UsefullMethods.validateNonNullPrice,
                    maxLength: 11,
                    inputType: InputType.numeric,
                    keyboardType: TextInputType.phone,
                    onChanged: (String value) {},
                  ),
                  const VerticalSpacing(_betweenTextFieldsSpacing),
                  MonetaryTextField(
                    visible: controller.fundingTypeSelected,
                    labelText: 'Revenus Nets/Bénéfice*',
                    controller: controller.netIncomeTEC,
                    focusNode: controller.netIncomeFocusNode,
                    validator: UsefullMethods.validateNonNullPrice,
                    maxLength: 11,
                    inputType: InputType.numeric,
                    keyboardType: TextInputType.phone,
                    onChanged: (String value) {},
                  ),
                  const VerticalSpacing(20),
                  if (controller.fundingTypeSelected)
                    const RequiredFieldsIndicator(),
                  KeyboardVisibilityBuilder(
                      builder: (context, bool keyboardIsVisible) {
                    return VerticalSpacing(keyboardIsVisible ? 10 : 40);
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onDropValueChanged(String value) async {
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
    }
  }

  Visibility _buildRadioCarTypeSelection() {
    return Visibility(
      visible: controller.selectedFundingType == FundingTypes.car ||
          controller.selectedFundingType == FundingTypes.newCar ||
          controller.selectedFundingType == FundingTypes.oldCar,
      child: Padding(
        padding: const EdgeInsets.only(top: 7),
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

  Align _buildButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: CommonButton(
                title: 'Annuler',
                titleColor: AppColors.darkestBlue,
                enabledColor: AppColors.lightBlue,
                onPressed: () {
                  showCommonModal(
                    modalType: ModalTypes.alert,
                    message: Get.find<QuotationCreationController>()
                            .creationMode
                        ? "Êtes-vous sûr de vouloir annuler la création de cette demande ?"
                        : "Êtes-vous sûr de vouloir annuler la modification de cette demande ?",
                    buttonTitle: 'Confirmer',
                    onPressed: () {
                      Get.back(closeOverlays: true);
                      Get.offAllNamed(AppRoutes.quotationRequestsList);
                    },
                    withCancelButton: true,
                  );
                },
              ),
            ),
            const HorizontalSpacing(6),
            Expanded(
              child: CommonButton(
                  title: 'Soumettre',
                  iconOnTheLeft: false,
                  onPressed: () {
                    bool validFundingType =
                        controller.fundingTypeFormKey.currentState.validate();
                    bool validInformations =
                        controller.informationsFormKey.currentState.validate();
                    bool validInputs = _formKey.currentState.validate();

                    if (validFundingType && validInformations && validInputs) {
                      controller.creationMode
                          ? controller.createRequest()
                          : controller.updateRequest();
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }

  void _resetTECsAndValidations() {
    UsefullMethods.unfocus(context);
    controller.informationsFormKey.currentState.reset();
    controller.reinitialiseTECs();
  }
}
