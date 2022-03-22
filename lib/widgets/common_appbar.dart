import 'package:e_loan_mobile/Helpers/helpers.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/app/core/profile/profile_page.dart';
import 'package:e_loan_mobile/app/pages.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/routes/app_bindings.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/static/statics.dart';
import 'package:e_loan_mobile/widgets/menu.dart';
import 'package:e_loan_mobile/widgets/horizontal_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonAppBar extends StatefulWidget with PreferredSizeWidget {
  const CommonAppBar({Key key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(AppConstants.defaultAppBarHeight);

  @override
  _CommonAppBarState createState() => _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0.0,
      automaticallyImplyLeading: false,
      toolbarHeight: widget.preferredSize.height,
      elevation: 5,
      backgroundColor: AppColors.bgGrey,
      title: _buildContent(context),
      centerTitle: true,
    );
  }

  OrientationBuilder _buildContent(BuildContext context) {
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        return Row(
          children: [
            if (!Statics.isLoggedIn) const HorizontalSpacing(18),
            if (Statics.isLoggedIn)
              SizedBox(width: 60, child: _buildProfileShortcut())
            else
              SizedBox(width: Get.context.width / 3, child: _buildFirstLogo()),
            const Spacer(),
            SizedBox(width: Get.context.width / 3, child: _buildSecondLogo()),
            if (Statics.isLoggedIn)
              SizedBox(
                width: Get.context.width / 3,
                child: Row(
                  children: [
                    const Spacer(),
                    _buildNotificationButton(),
                    _buildActionsSeparator(),
                    _menuButton(),
                    const HorizontalSpacing(2),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }

  IconButton _buildProfileShortcut() {
    return IconButton(
        icon: Image.asset(
          AppImages.person,
          color: AppColors.blue,
        ),
        onPressed: () {
          if (![AppRoutes.profilePage, AppRoutes.profile].contains(Get.currentRoute)) {
            Get.find<MenuController>().selectedIndex.value = 0;
            Get.offAll(
              () => ProfilePage(),
              binding: ProfilePageBindings(),
              transition: Transition.upToDown,
            );
          }
        });
  }

  Image _buildFirstLogo() {
    return Image.asset(
      AppImages.logo,
      height: 35,
    );
  }

  Image _buildSecondLogo() {
    return Image.asset(
      AppImages.secondLogo,
      height: 30,
    );
  }

  IconButton _menuButton() {
    return IconButton(
      onPressed: () async {
        UsefullMethods.unfocus(context);
        0.delay().then((_) => RootScaffold.openDrawer(context));
      },
      icon: Padding(
        padding: const EdgeInsets.all(5),
        child: Image.asset(AppImages.menu),
      ),
    );
  }

  Stack _buildNotificationButton() {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () {
            if (![AppRoutes.notifications, AppRoutes.notificationsPage].contains(Get.currentRoute)) {
              Get.find<MenuController>().selectedIndex.value = -99;

              Get.offAll(
                () => NotificationsListPage(),
                transition: Transition.upToDown,
              );
            }
          },
          icon: Stack(
            alignment: Alignment.topLeft,
            children: [
              Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset(AppImages.notification),
              ),
              GetBuilder<NotificationsController>(
                builder: (NotificationsController notificationsController) {
                  return notificationsController.totalUnreaded != 0
                      ? Container(
                          height: 15,
                          width: 15,
                          decoration: BoxDecoration(
                            color: AppColors.orange,
                            borderRadius: AppConstants.smallestBorderRadius,
                          ),
                          child: Center(
                            child: Text(
                              notificationsController.totalUnreaded.toString() ?? '0',
                              style: AppStyles.boldBlue11.copyWith(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox();
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSeparator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Container(
        width: 1,
        height: 23,
        color: AppColors.lightGrey,
      ),
    );
  }
}
