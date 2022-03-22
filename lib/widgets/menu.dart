import 'package:e_loan_mobile/api/services/services.dart';
import 'package:e_loan_mobile/app/core/notifications/notifications_controller.dart';
import 'package:e_loan_mobile/app/core/quotation_details/quotation_details_page.dart';
import 'package:e_loan_mobile/app/core/rdvs_list/rdvs_list_page.dart';
import 'package:e_loan_mobile/app/core/request_details/request_details_page.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/static/statics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'horizontal_spacing.dart';
import 'vertical_spacing.dart';

class MenuController extends GetxController {
  RxInt selectedIndex = (-1).obs;
  RxString firstname = ''.obs;
  RxString lastname = ''.obs;
}

class Menu extends StatefulWidget {
  const Menu({Key key, this.navigator, this.child}) : super(key: key);

  final GlobalKey<NavigatorState> navigator;
  final Widget child;

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<DrawerControllerState> _drawerKey =
      GlobalKey<DrawerControllerState>();

  final MenuController controller = Get.put(MenuController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      drawerEdgeDragWidth: 0,
      drawer: Container(
        margin: EdgeInsets.only(
          top: AppConstants.defaultAppBarHeight +
              MediaQuery.of(context).viewPadding.top,
        ),
        width: 280,
        child: ClipRRect(
          borderRadius: const BorderRadius.horizontal(
            right: AppConstants.regularRadius,
          ),
          child: Drawer(
            key: _drawerKey,
            child: Container(
              color: AppColors.blue,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalSpacing(30),
                  _buildUserName(),
                  const VerticalSpacing(20),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Obx(
                        () => Column(
                          children: [
                            _homeSection(),
                            _profileSection(),
                            _requestsSection(),
                            if (Statics.isAdmin || fakeData) _usersSection(),
                            if (Statics.loggedUser?.tier?.isClient)
                              _accountTrackingSection(),
                            _agenciesSection(),
                            _generalConditionsSection(),
                            _editPasswordSection(),
                            _logoutSection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpacing(6),
                  _buildAppLogo(),
                  const VerticalSpacing(10),
                ],
              ),
            ),
          ),
        ),
      ),
      body: widget.child,
    );
  }

  Obx _buildUserName() {
    return Obx(
      () => Padding(
          padding: const EdgeInsets.only(left: 18.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bienvenue', style: AppStyles.mediumWhite13),
              const VerticalSpacing(8),
              Text(
                (controller.firstname.value.isNotEmpty
                        ? controller.firstname.value
                        : 'Cher') +
                    ' ' +
                    (controller.lastname.value.isNotEmpty
                        ? controller.lastname.value
                        : 'Testeur 🤑'),
                style: AppStyles.boldWhite14.copyWith(fontSize: 16),
              ),
            ],
          )),
    );
  }

  GestureDetector _homeSection() {
    return _buildSimpleSection(
      index: -1,
      image: AppImages.home,
      title: 'Accueil',
      onTap: () {
        controller.selectedIndex.value = -1;
        if (Get.currentRoute != AppRoutes.home) Get.offAllNamed(AppRoutes.home);
      },
    );
  }

  GestureDetector _profileSection() {
    return _buildSimpleSection(
      index: 0,
      image: AppImages.profile,
      title: 'Mon profil',
      onTap: () {
        controller.selectedIndex.value = 0;
        if (![AppRoutes.profilePage, AppRoutes.profile]
            .contains(Get.currentRoute)) Get.offAllNamed(AppRoutes.profile);
      },
    );
  }

  ExpansionTile _requestsSection() {
    return ExpansionTile(
      initiallyExpanded: controller.selectedIndex.value == 11 ||
          controller.selectedIndex.value == 12 ||
          controller.selectedIndex.value == 13,
      title: Row(
        children: [
          Image.asset(
            AppImages.folder,
            color: controller.selectedIndex.value == 11 ||
                    controller.selectedIndex.value == 12
                ? AppColors.orange
                : Colors.white,
            height: 20,
          ),
          const HorizontalSpacing(16),
          Flexible(
            child: Text(
              'Mes demandes',
              style: AppStyles.regularWhite14.copyWith(
                color: controller.selectedIndex.value == 11 ||
                        controller.selectedIndex.value == 12
                    ? AppColors.orange
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
      tilePadding: const EdgeInsets.symmetric(horizontal: 20),
      childrenPadding: EdgeInsets.zero,
      children: <Widget>[
        _buildSectionChild(
          index: 11,
          title: 'Financements',
          onTap: () {
            controller.selectedIndex.value = 11;
            if (Get.currentRoute == AppRoutes.requestDetails &&
                !comingFromNotificationsScreenToFundingRequestDetailsPage)
              Get.back();
            else if (Get.currentRoute != AppRoutes.requestsList)
              Get.offAllNamed(AppRoutes.requestsList);
          },
        ),
        _buildSectionChild(
          index: 12,
          title: 'Cotations',
          onTap: () {
            controller.selectedIndex.value = 12;
            if (Get.currentRoute == AppRoutes.quotationRequestDetails &&
                !comingFromNotificationsScreenToQuotationRequestDetailsPage)
              Get.back();
            if (Get.currentRoute != AppRoutes.quotationRequestsList)
              Get.offAllNamed(AppRoutes.quotationRequestsList);
          },
        ),
        _buildSectionChild(
          index: 13,
          title: 'Rendez-vous',
          onTap: () {
            controller.selectedIndex.value = 13;
            comingFromNotificationsScreenToRDVsListPage = false;
            if (Get.currentRoute == AppRoutes.rdvCreation) Get.back();
            if (Get.currentRoute != AppRoutes.rdvsList)
              Get.offAllNamed(AppRoutes.rdvsList);
          },
        ),
      ],
    );
  }

  GestureDetector _usersSection() {
    return _buildSimpleSection(
      index: 2,
      image: AppImages.userSettings,
      title: 'Gestion des utilisateurs',
      onTap: () {
        controller.selectedIndex.value = 2;
        if (Get.currentRoute != AppRoutes.usersList)
          Get.offAllNamed(AppRoutes.usersList);
      },
    );
  }

  GestureDetector _accountTrackingSection() {
    return _buildSimpleSection(
      index: 3,
      image: AppImages.accountTracking,
      title: 'Suivi du compte',
      onTap: () {
        controller.selectedIndex.value = 3;
        if (AppRoutes.accountTrackingChildRoutes.contains(Get.currentRoute) &&
            Get.previousRoute == AppRoutes.accountTracking)
          Get.back();
        else if (Get.currentRoute != AppRoutes.accountTracking)
          Get.offAllNamed(AppRoutes.accountTracking);
      },
    );
  }

  GestureDetector _agenciesSection() {
    return _buildSimpleSection(
      index: 4,
      image: AppImages.agencies,
      title: 'Agences TLF',
      onTap: () {
        launch(
          AppConstants.AGENCIES_URL,
          forceSafariVC: true,
        );
      },
    );
  }

  GestureDetector _generalConditionsSection() {
    return _buildSimpleSection(
      index: 5,
      image: AppImages.policy,
      title: "Conditions générales d'utilisation",
      onTap: () {
        launch(
          AppConstants.GENERAL_CONDITION_URL,
          forceSafariVC: true,
        );
      },
    );
  }

  GestureDetector _editPasswordSection() {
    return _buildSimpleSection(
      index: 6,
      image: AppImages.key,
      title: 'Modifier le mot de passe',
      onTap: () {
        controller.selectedIndex.value = 6;
        if (AppRoutes.passwordEditing != Get.currentRoute)
          Get.offAllNamed(AppRoutes.passwordEditing);
      },
    );
  }

  GestureDetector _logoutSection() {
    return _buildSimpleSection(
      index: 10,
      image: null,
      title: 'Se déconnecter',
      onTap: _logout,
    );
  }

  Padding _buildAppLogo() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Center(
        child: Row(
          children: [
            Card(
              elevation: 10,
              shadowColor: Colors.white,
              child: Image.asset(
                AppImages.logoMinimized,
                height: 50,
              ),
            ),
            const HorizontalSpacing(8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Copyright © 2021\nTunisie Leasing & Factoring',
                    style: AppStyles.regularWhite14.copyWith(fontSize: 12),
                  ),
                  const VerticalSpacing(2),
                  Text(
                    'version 1.0',
                    style: AppStyles.mediumWhite13.copyWith(fontSize: 12),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildSimpleSection({
    @required final String image,
    @required final String title,
    @required Function onTap,
    @required int index,
  }) {
    final bool isActive = index == controller.selectedIndex.value;
    final Color color = isActive ? AppColors.orange : Colors.white;
    return GestureDetector(
      onTap: () {
        if (_scaffoldKey.currentState.isDrawerOpen) {
          _scaffoldKey.currentState.openEndDrawer();
        }
        AppConstants.halfSecond.then((_) {
          onTap();
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          height: 46,
          child: Row(
            children: [
              if (image != null)
                Image.asset(
                  image,
                  color: color,
                  height: 20,
                  width: 20,
                )
              else
                Icon(
                  Icons.login_outlined,
                  size: 20,
                  color: color,
                ),
              const HorizontalSpacing(16),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.fade,
                  maxLines: 1,
                  softWrap: false,
                  style: AppStyles.regularWhite14.copyWith(color: color),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildSectionChild({
    @required String title,
    @required Function onTap,
    @required int index,
    double titlePadding = 22,
  }) {
    final bool isActive = index == controller.selectedIndex.value;
    final Color color = isActive ? AppColors.orange : AppColors.blue;
    return Container(
      color: AppColors.lighterBlue,
      height: 45,
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 40),
        dense: true,
        title: Padding(
          padding: EdgeInsets.only(left: titlePadding),
          child: Text(
            title,
            style: AppStyles.semiBoldBlue13.copyWith(color: color),
          ),
        ),
        onTap: () {
          if (_scaffoldKey.currentState.isDrawerOpen) {
            _scaffoldKey.currentState.openEndDrawer();
          }
          AppConstants.halfSecond.then((_) {
            onTap();
          });
        },
      ),
    );
  }

  void _logout() {
    Statics.eraseLoggedUserInformations();
    controller.selectedIndex.value = 0;
    Get.find<NotificationsController>()?.totalUnreaded++;
    Get.offAllNamed(AppRoutes.login);
  }
}

class RootDrawer {
  static DrawerControllerState of(BuildContext context) {
    final DrawerControllerState drawerControllerState =
        context.findRootAncestorStateOfType<DrawerControllerState>();
    return drawerControllerState;
  }
}

class RootScaffold {
  static void openDrawer(BuildContext context) {
    final ScaffoldState scaffoldState =
        context.findRootAncestorStateOfType<ScaffoldState>();

    scaffoldState.openDrawer();
  }

  static void closeDrawer(BuildContext context) {
    final ScaffoldState scaffoldState =
        context.findRootAncestorStateOfType<ScaffoldState>();

    scaffoldState.openEndDrawer();
  }

  static ScaffoldState of(BuildContext context) {
    final ScaffoldState scaffoldState =
        context.findRootAncestorStateOfType<ScaffoldState>();
    return scaffoldState;
  }
}
