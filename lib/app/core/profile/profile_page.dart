import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/Helpers/usefull_metods.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

import 'profile_controller.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key key}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin<ProfilePage>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final ProfileController controller = Get.find();

  TabController _tabController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _legalFromFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _activityAreaFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _functionFormKey = GlobalKey<FormState>();

  final GlobalKey<FormState> _datePickerFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller.initialiseProfile();

    _tabController = TabController(vsync: this, length: 3);

    _tabController.addListener(() {
      controller.selectedTab = _tabController.index;
      controller.update();
    });
    super.initState();
  }

  @override
  void dispose() {
    //controller?.dispose();
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ProfileController>(
      builder: (_) {
        return KeyboardDismissOnTap(
          child: SafeAreaManager(
            child: DefaultTabController(
              key: GlobalKey(),
              length: 2,
              child: Scaffold(
                appBar: const CommonAppBar(),
                body: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const VerticalSpacing(25),
                        _buildTitle(),
                        const VerticalSpacing(25),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: TabBar(
                            controller: _tabController,
                            labelColor: AppColors.orange,
                            unselectedLabelColor: AppColors.darkestBlue,
                            unselectedLabelStyle: AppStyles.mediumGreyBlue10,
                            labelStyle: AppStyles.mediumOrange11,
                            indicatorColor: AppColors.orange,
                            indicatorSize: TabBarIndicatorSize.label,
                            indicatorPadding:
                                const EdgeInsets.symmetric(horizontal: -5),
                            tabs: _buildTabs(),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      // height: double.infinity,
                      child: TabBarView(
                        controller: _tabController,
                        children: <Widget>[
                          _buildPersonalInformationsTabView(),
                          _buildProfessionalInformationsTabView(),
                          _buildAddressTabView(),
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

  Padding _buildTitle() => Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Mon profil', style: AppStyles.boldBlue14),
            const VerticalSpacing(5),
            Container(
              width: 40,
              height: 2,
              color: AppColors.orange,
            )
          ],
        ),
      );

  List<Widget> _buildTabs() {
    return const <Tab>[
      Tab(
        child: Text(
          'Informations du détenteur du compte TLF-net',
          textAlign: TextAlign.center,
        ),
      ),
      Tab(
        child: Text(
          'Informations professionnelles',
          textAlign: TextAlign.center,
        ),
      ),
      Tab(
        child: Text(
          'Adresse professionnelle ou du siège',
          textAlign: TextAlign.center,
        ),
      ),
    ];
  }

  Widget _buildPersonalInformationsTabView() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: AppConstants.largeRadius,
                bottomRight: AppConstants.largeRadius,
              ),
            ),
            child: Padding(
              padding: AppConstants.mediumPadding,
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const VerticalSpacing(30),
                    _buildUserInformationsInputs(),
                    const VerticalSpacing(25),
                    _buildCreateAccountButton(),
                    const VerticalSpacing(25),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column _buildUserInformationsInputs() {
    const double _betweenTextFieldsSpacing = 11;
    String _lastPhoneValue = '';
    String _lastMobileValue = '';
    return Column(
      children: <Widget>[
        InputTextField(
          capitalize: true,
          enabled: controller.editionMode,
          fillColor:
              controller.editionMode ? Colors.white : AppColors.lightestGrey,
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
          enabled: controller.editionMode,
          fillColor:
              controller.editionMode ? Colors.white : AppColors.lightestGrey,
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
            enabled: controller.editionMode,
            fillColor:
                controller.editionMode ? Colors.white : AppColors.lightestGrey,
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
        InputTextField(
          enabled: controller.editionMode,
          fillColor:
              controller.editionMode ? Colors.white : AppColors.lightestGrey,
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
          enabled: controller.editionMode,
          labelText: 'Mobile',
          fillColor:
              controller.editionMode ? Colors.white : AppColors.lightestGrey,
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
          enabled: controller.editionMode,
          fillColor:
              controller.editionMode ? Colors.white : AppColors.lightestGrey,
          labelText: 'Email*',
          controller: controller.emailTEC,
          focusNode: controller.emailFocusNode,
          validator: UsefullMethods.validEmail,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildProfessionalInformationsTabView() {
    final bool _isPerson = controller.isPerson;
    final bool _isSociety = controller.isSociety;
    final bool _isClient = controller.isClientAlready;
    const double spacingValue = 11;
    final double _betweenTextFieldsSpacing = _isPerson ? spacingValue : 0;
    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: AppConstants.regularBorderRadius,
          color: Colors.white,
        ),
        child: Padding(
          padding: AppConstants.mediumPadding,
          child: Column(
            children: <Widget>[
              const VerticalSpacing(30),
              Form(
                key: _legalFromFormKey,
                child: DropDownTextFormField(
                  enabled: false,
                  fillColor: AppColors.lightestGrey,
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
                enabled: false,
                fillColor: AppColors.lightestGrey,
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
                enabled: false,
                fillColor: AppColors.lightestGrey,
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
                enabled: false,
                fillColor: AppColors.lightestGrey,
                visible: _isPerson,
                labelText: 'Nom commercial',
                controller: controller.tradeNameTEC,
                focusNode: controller.tradeNameFocusNode,
                nextFocusNode: controller.cinFocusNode,
                inputType: InputType.alphaNumeric,
              ),
              VerticalSpacing(_betweenTextFieldsSpacing),
              if (controller.identifiedByCIN)
                InputTextField(
                  enabled: false,
                  fillColor: AppColors.lightestGrey,
                  visible: _isPerson,
                  labelText: 'CIN*',
                  controller: controller.cinTEC,
                  focusNode: controller.cinFocusNode,
                  validator: UsefullMethods.validCIN,
                  maxLength: 8,
                  inputType: InputType.numeric,
                  keyboardType: TextInputType.phone,
                )
              else
                InputTextField(
                  enabled: false,
                  fillColor: AppColors.lightestGrey,
                  visible: _isPerson,
                  labelText: 'Carte séjour*',
                  controller: controller.residencePermitTEC,
                  focusNode: controller.residencePermitFocusNode,
                  validator: UsefullMethods.validateNotNullOrEmpty,
                ),
              VerticalSpacing(_isSociety ? 11 : 0),
              InputTextField(
                enabled: false,
                fillColor: AppColors.lightestGrey,
                visible: _isSociety,
                labelText: 'Type*',
                controller: controller.typeTEC,
                focusNode: controller.typeFocusNode,
                validator: UsefullMethods.valideRNE,
                maxLength: 8,
                inputType: InputType.alphaNumeric,
              ),
              VerticalSpacing(_isSociety ? 11 : 0),
              InputTextField(
                enabled: false,
                fillColor: AppColors.lightestGrey,
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
                enabled: false,
                fillColor: AppColors.lightestGrey,
                visible: _isSociety,
                labelText: 'Identifiant unique (RNE)*',
                controller: controller.rneTEC,
                focusNode: controller.rneFocusNode,
                validator: UsefullMethods.valideRNE,
                maxLength: 8,
                inputType: InputType.alphaNumeric,
              ),
              const VerticalSpacing(spacingValue),
              Form(
                key: _activityAreaFormKey,
                child: DropDownTextFormField(
                  enabled: false,
                  fillColor: AppColors.lightestGrey,
                  value: controller.activityArea,
                  values: [],
                  controller: controller.activityAreaTEC,
                  focusNode: controller.activityAreaFocusNode,
                  isActivityAreaDropDown: true,
                  activityAreaValues: AppConstants.activityAreasFullList,
                  labelText: "Secteur d'activité*",
                  onDropValueChanged: (String value) {
                    controller.activityAreaTEC?.text = value;
                    _functionFormKey.currentState.validate();
                  },
                ),
              ),
              const VerticalSpacing(spacingValue),
              Form(
                key: _datePickerFormKey,
                child: DatePickerTextField(
                  enabled: false,
                  fillColor: AppColors.lightestGrey,
                  controller: controller.entryDateTEC,
                  labelText: "Date d'entrée en activité*",
                ),
              ),
              const VerticalSpacing(spacingValue),
              if (controller.identifiedByCIN)
                InputTextField(
                  enabled: false,
                  fillColor: AppColors.lightestGrey,
                  visible: _isClient,
                  labelText: 'Code client*',
                  controller: controller.clientCodeTEC,
                  focusNode: controller.clientCodeFocusNode,
                  validator: (String value) => UsefullMethods.validateCode(
                      value, controller.contractCodeTEC.text),
                  maxLength: 8,
                  inputType: InputType.numeric,
                  keyboardType: TextInputType.phone,
                ),
              const VerticalSpacing(30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddressTabView() {
    const double _betweenTextFieldsSpacing = 11;

    return SingleChildScrollView(
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: AppConstants.regularBorderRadius,
          color: Colors.white,
        ),
        child: Padding(
          padding: AppConstants.mediumPadding,
          child: Column(
            children: <Widget>[
              const VerticalSpacing(30),
              InputTextField(
                enabled: false,
                fillColor: AppColors.lightestGrey,
                labelText: 'Rue*',
                controller: controller.streetTEC,
                focusNode: controller.streetFocusNode,
                nextFocusNode: controller.postalCodeFocusNode,
                validator: UsefullMethods.validateNotNullOrEmpty,
                inputType: InputType.alphaNumeric,
              ),
              const VerticalSpacing(_betweenTextFieldsSpacing),
              InputTextField(
                enabled: false,
                fillColor: AppColors.lightestGrey,
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
                fillColor: AppColors.lightestGrey,
                labelText: 'Localité*',
                controller: controller.localityTEC,
              ),
              const VerticalSpacing(_betweenTextFieldsSpacing),
              InputTextField(
                enabled: false,
                fillColor: AppColors.lightestGrey,
                labelText: 'Gouvernorat*',
                controller: controller.governorateTEC,
              ),
              const VerticalSpacing(30),
            ],
          ),
        ),
      ),
    );
  }

  CommonButton _buildCreateAccountButton() {
    return CommonButton(
      title:
          controller.editionMode ? 'Enregistrer' : 'Modifier mes informations',
      onPressed: () {
        if (controller.editionMode) {
          final bool _validInputs = _formKey.currentState.validate();
          final bool _validFunction = _functionFormKey.currentState.validate();
          if (_validInputs && _validFunction) {
            UsefullMethods.unfocus(context);
            AppConstants.halfSecond.then((_) {
              controller.updateProfile();
            });
          }
        } else {
          controller.editionMode = !controller.editionMode;
          controller.update();
        }
      },
    );
  }
}
