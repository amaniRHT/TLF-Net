import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/Helpers/keys_storage.dart';
import 'package:e_loan_mobile/api/models/enums.dart';
import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/main.dart';
import 'package:e_loan_mobile/routes/routing.dart';
import 'package:e_loan_mobile/static/statics.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<LoginPage> with TickerProviderStateMixin {
  final LoginController controller = Get.find();
  TabController _tabController;

  final GlobalKey<FormState> _textFieldsformKey = GlobalKey<FormState>();

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);

    _tabController.addListener(() {
      controller.emailTEC.text = '';
      controller.passwordTEC.text = '';
      controller.isEmployee = Answers.no;
      controller.isConfirmedEmployee = false;
      controller.selectedTab = _tabController.index;
      controller.update();
    });
    super.initState();

    NotificationManager.initialize();

    NotificationManager.getToken().then((value) {
      print('FCM token => $value');
      Statics.fcmToken = value;
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Stack(
          fit: StackFit.expand,
          children: [
            _buildBackgroundImage(),
            _buildBlueOpactiyView(),
            _buildCenterView(),
          ],
        ),
      ),
    );
  }

  Opacity _buildBlueOpactiyView() {
    return Opacity(
      opacity: 0.87,
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF00315C),
        ),
      ),
    );
  }

  SizedBox _buildBackgroundImage() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Image.asset(
        AppImages.loginBackgorund,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCenterView() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: context.isTablet ? 450 : Get.context.width * 0.87,
          padding: const EdgeInsets.symmetric(vertical: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogos(),
              const VerticalSpacing(40),
              GetBuilder<LoginController>(
                builder: (_) {
                  return Stack(
                    children: [
                      DefaultTabController(
                        key: GlobalKey(),
                        length: 2,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                              child: TabBar(
                                controller: _tabController,
                                labelColor: AppColors.blue,
                                unselectedLabelColor: AppColors.blue.withOpacity(.4),
                                labelStyle: AppStyles.boldBlue13,
                                unselectedLabelStyle: AppStyles.inactiveMediumBlue13,
                                indicatorColor: AppColors.orange,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: UnderlineTabIndicator(
                                  borderSide: const BorderSide(
                                    width: 2.0,
                                    color: AppColors.orange,
                                  ),
                                  insets: Get.context.isPhone
                                      ? EdgeInsets.only(
                                          left: Get.context.width * 0.06,
                                          right: Get.context.width * 0.28,
                                        )
                                      : EdgeInsets.only(
                                          left: Get.context.width * 0.07,
                                          right: Get.context.width * 0.15,
                                        ),
                                ),
                                tabs: _buildTabs(),
                              ),
                            ),
                            Wrap(
                              children: [
                                SizedBox(
                                  height: 310,
                                  child: TabBarView(
                                    controller: _tabController,
                                    children: <Widget>[
                                      _buildConnexionTabView(),
                                      _buildSignupTabView(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      _buildTabsGreySeparator(),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildLogos() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              print(controller.numberOfTaps);
              if (controller.numberOfTaps > 4) {
                controller.numberOfTaps = 0;
                return;
              } else if (controller.numberOfTaps < 4 && controller.numberOfTaps >= 0) {
                controller.numberOfTaps++;
              } else if (controller.numberOfTaps == 4) {
                controller.numberOfTaps = 10;
                fakeData ? disableDataFacking() : enableDataFacking();
                runApp(AppWidget(key: UniqueKey()));

                showCustomToast(
                  toastType: ToastTypes.push,
                  padding: 12,
                  contentText:
                      fakeData ? ' 🤑🤑 Bienvenue au mode test 🤑🤑' : 'Le mode normal a été rétablit avec succès.',
                  blurEffectEnabled: false,
                  onTheTop: false,
                  duration: 3,
                ).then((_) {});
              }
            },
            child: Container(
              width: 150,
              height: 50,
              child: Image.asset(
                AppImages.logo,
                width: 150,
              ),
            ),
          ),
          const Spacer(),
          Image.asset(
            AppImages.secondLogo,
            height: 24,
          )
        ],
      ),
    );
  }

  Padding _buildTabsGreySeparator() {
    return Padding(
      padding: EdgeInsets.only(
        left: context.isTablet ? 450 / 2 : Get.context.width * 0.87 / 2,
        top: 5,
      ),
      child: Container(
        width: 1.2,
        height: 20,
        color: AppColors.grey,
      ),
    );
  }

  List<Widget> _buildTabs() {
    return const <Tab>[
      Tab(
        child: Text(
          'Connectez-Vous',
          maxLines: 1,
        ),
      ),
      Tab(
        child: Text(
          'Créez un compte',
          maxLines: 1,
        ),
      ),
    ];
  }

  Widget _buildConnexionTabView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        key: _textFieldsformKey,
        child: Column(
          children: [
            const VerticalSpacing(40),
            _buildEmailTextField(),
            const Spacer(),
            _buildPasswordTextField(),
            const Spacer(),
            _buildPasswordRecoveryButton(),
            const Spacer(),
            _buildConnexionButton(),
            const VerticalSpacing(4),
          ],
        ),
      ),
    );
  }

  CommonButton _buildConnexionButton() {
    return CommonButton(
      title: 'Se connecter',
      onPressed: () {
        if (TLFEnvrionnments.debugModeEnabled) {
          DioRequestsInterceptor.showLoader();
          _login();
        } else {
          DioRequestsInterceptor.showLoader();
          final bool validInputs = _textFieldsformKey.currentState.validate();
          if (validInputs)
            _login();
          else
            DioRequestsInterceptor.hideLoader();
        }
      },
    );
  }

  void _login() {
    UsefullMethods.unfocus(context);
    AppConstants.halfSecond.then((_) {
      controller.signIn();
      DioRequestsInterceptor.hideLoader();
    });
  }

  InputTextField _buildEmailTextField() {
    return InputTextField(
      key: KeysStorage.textFieldKey1,
      controller: controller.emailTEC,
      focusNode: controller.emailFocusNode,
      nextFocusNode: controller.passwordFocusNode,
      labelText: 'Email ou login',
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
              color: AppColors.darkGrey,
            )
          ],
        ),
      ),
      keyboardType: TextInputType.emailAddress,
      validator: UsefullMethods.validEmail,
    );
  }

  InputTextField _buildPasswordTextField() {
    return InputTextField(
      key: KeysStorage.textFieldKey2,
      controller: controller.passwordTEC,
      focusNode: controller.passwordFocusNode,
      obscureText: controller.passwordIsHidden,
      labelText: 'Mot de passe',
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const HorizontalSpacing(4),
            Image.asset(
              AppImages.key,
              height: 27,
            ),
            const HorizontalSpacing(12),
            Container(
              width: 1,
              height: 26,
              color: AppColors.darkGrey,
            )
          ],
        ),
      ),
      suffixIcon: PasswordVisiblityToggler(
        visibilityCondition: controller.passwordIsHidden,
        onPressed: () {
          controller.passwordIsHidden = !controller.passwordIsHidden;
          controller.update();
        },
      ),
      keyboardType: TextInputType.emailAddress,
      validator: (String password) {
        if (password == null || password.isEmpty) {
          return AppConstants.REQUIRED_FIELD;
        }
        if (password.length < 8) {
          return 'Mot de passe invalide';
        }
        return null;
      },
    );
  }

  Row _buildPasswordRecoveryButton() {
    return Row(
      children: [
        const Spacer(),
        TextButton(
          onPressed: () {
            Get.toNamed(AppRoutes.passwordReset);
          },
          child: Text(
            'Mot de passe oublié?',
            style: AppStyles.boldBlue11.copyWith(
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupTabView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(),
          Row(
            children: [
              const Text(
                'Salarié ?',
                style: AppStyles.boldBlue14,
                textAlign: TextAlign.left,
              ),
              Radio(
                value: Answers.yes,
                groupValue: controller.isEmployee,
                onChanged: (Answers value) {
                  controller.isEmployee = value;
                  controller.isConfirmedEmployee = true;
                  controller.update();
                },
              ),
              const Text(
                'Oui',
                style: AppStyles.mediumBlue14,
              ),
              Radio(
                value: Answers.no,
                groupValue: controller.isEmployee,
                onChanged: (Answers value) {
                  controller.isEmployee = value;
                  controller.isConfirmedEmployee = false;
                  controller.update();
                },
              ),
              const Text(
                'Non',
                style: AppStyles.mediumBlue14,
              ),
            ],
          ),
          const VerticalSpacing(10),
          if (controller.isConfirmedEmployee)
            const Text(
              "Nous vous informons que nos services sont destinés à des professionnels (non-salariés) détenteurs de documents officiels pour l'exercice de leurs activités : (Patente, Carte professionnelles, etc ...) \n\nMerci pour votre confiance.",
              style: AppStyles.regularBlue12,
            ),
          const Spacer(),
          CommonButton(
            title: !controller.isConfirmedEmployee ? 'Créer un compte' : 'Retour',
            onPressed: () {
              controller.isConfirmedEmployee ? _swipeToAuhenticationTab() : _goToSignupPage();
            },
          ),
          const VerticalSpacing(4),
        ],
      ),
    );
  }

  void _swipeToAuhenticationTab() {
    _tabController.animateTo(0);
  }

  void _goToSignupPage() {
    controller.emailTEC.text = '';
    controller.passwordTEC.text = '';
    Get.toNamed(AppRoutes.signup).then((_) {
      _swipeToAuhenticationTab();
    });
  }
}
