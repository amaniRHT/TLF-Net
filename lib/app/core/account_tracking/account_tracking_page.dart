import 'dart:async';

import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/common_appbar.dart';
import 'package:e_loan_mobile/widgets/menu.dart';
import 'package:e_loan_mobile/widgets/vertical_spacing.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';

class AccountTrackingPage extends StatefulWidget {
  const AccountTrackingPage({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<AccountTrackingPage>
    with AutomaticKeepAliveClientMixin<AccountTrackingPage>, TickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  final MenuController menuController = Get.find();
  final AccountTrackingController controller = Get.find();
  final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  @override
  void initState() {
    super.initState();
    _configureTabbarController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    (controller.timer == null || !controller.timer.isActive) ? startTimer() : stopTimer();
  }

  void _configureTabbarController() {
    controller.tabController = TabController(vsync: this, length: 3);
    controller.tabController.addListener(() {
      controller.current.value = controller.tabController.index;
    });
  }

  @override
  void dispose() {
    stopTimer();
    controller.tabController?.dispose();
    controller?.dispose();
    super.dispose();
  }

  void startTimer() {
    controller.timer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer t) => scrollAnimated(),
    );
  }

  void stopTimer() {
    controller.timer?.cancel();
  }

  void scrollAnimated() {
    if (controller.tabController.animation == null) return;
    if ([0.0, 1.0, 2.0].contains(controller.tabController.animation.value))
      controller.tabController.animateTo(
        controller.tabController.index == 2 ? 0 : controller.tabController.index + 1,
      );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<AccountTrackingController>(
      builder: (_) {
        return KeyboardDismissOnTap(
          child: SafeAreaManager(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              appBar: const CommonAppBar(),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const VerticalSpacing(25),
                  const CommonTitle(title: 'Suivi du compte', padding: 24),
                  const VerticalSpacing(30),
                  _buildTabbarView(),
                  _buildPageControls(),
                  const VerticalSpacing(20),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Expanded _buildTabbarView() {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: DefaultTabController(
              key: GlobalKey(),
              length: 3,
              child: TabBarView(
                physics: const BouncingScrollPhysics(),
                controller: controller.tabController,
                children: <Widget>[
                  _buildTab(index: 0),
                  _buildTab(index: 1),
                  _buildTab(index: 2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Obx _buildPageControls() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [0, 1, 2].map((int index) {
          return CommonPageControl(
            currentCondition: controller.current.value == index,
            itemSize: 15,
          );
        }).toList(),
      ),
    );
  }

  ListView _buildTab({int index}) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: 2,
      itemBuilder: (BuildContext context, int i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  FittedBox(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: AppConstants.regularRadius,
                              topRight: AppConstants.regularRadius,
                            ),
                            child: SizedBox(
                              height: Get.context.height / 5,
                              width: Get.context.width,
                              child: Image.asset(
                                controller.quickAccessRoutes[index][i].image,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const VerticalSpacing(24),
                          Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: Text(
                              controller.quickAccessRoutes[index][i].name,
                              style: AppStyles.boldBlack13.copyWith(fontSize: 15),
                            ),
                          ),
                          const VerticalSpacing(50),
                        ],
                      ),
                    ),
                  ),
                  const VerticalSpacing(18),
                ],
              ),
              SizedBox(
                width: 200,
                child: CommonButton(
                  title: 'Consulter',
                  iconOnTheLeft: false,
                  icon: const Icon(
                    Icons.arrow_forward_ios,
                    size: 17,
                  ),
                  onPressed: () {
                    Get.toNamed(controller.quickAccessRoutes[index][i].route);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CommonPageControl extends StatelessWidget {
  const CommonPageControl({
    Key key,
    this.itemSize = 12,
    @required this.currentCondition,
  }) : super(key: key);

  final bool currentCondition;
  final double itemSize;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: itemSize,
      height: itemSize,
      margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: currentCondition ? AppColors.orange : AppColors.lightGrey,
      ),
    );
  }
}
