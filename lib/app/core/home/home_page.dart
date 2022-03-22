import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/app/pages.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/widgets/common_appbar.dart';
import 'package:e_loan_mobile/widgets/menu.dart';
import 'package:e_loan_mobile/widgets/vertical_spacing.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<HomePage> {
  final HomeController controller = Get.find();
  final MenuController menuController = Get.find();

  @override
  void initState() {
    menuController.selectedIndex.value = -1;

    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<NotificationsController>()?.getNotifications(fromBeginnig: true);
      controller.getCookiesName();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeAreaManager(
      child: Scaffold(
        appBar: const CommonAppBar(),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              VerticalSpacing(context.isTablet ? 40 : 16),
              const CommonTitle(title: 'Nos financements', padding: 25),
              VerticalSpacing(context.isTablet ? 30 : 5),
              _buildCarouselForFundingRequests(),
              VerticalSpacing(context.isTablet ? 20 : 5),
              _buildPageControl(),
              VerticalSpacing(context.isTablet ? 50 : 12),
              const CommonTitle(title: 'Mes raccourcis', padding: 25),
              VerticalSpacing(context.isTablet ? 30 : 20),
              _buildShortcuts(),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildShortcuts() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: Get.context.isTablet ? 6 : 3),
        itemCount: controller.quickAccessRoutes.length,
        itemBuilder: (_, int index) => GestureDetector(
          onTap: () {
            menuController.selectedIndex.value =
                controller.quickAccessRoutes[index].index;
            menuController.update();
            Get.offAllNamed(controller.quickAccessRoutes[index].route);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: Get.context.width / 3 - 20,
                child: GetBuilder<HomeController>(
                  builder: (_) {
                    return MaterialButton(
                      onPressed: () {
                        if (controller.quickAccessRoutes[index].route == null)
                          return;
                        if (index == 0) {
                          controller.agencyIsSelected =
                              !controller.agencyIsSelected;
                          controller.update();
                        }

                        Get.put(AgencyController());
                        menuController.selectedIndex.value =
                            controller.quickAccessRoutes[index].index;
                        controller.quickAccessRoutes[index].isDialog
                            ? presentDialog(
                                () => AgencyDialog(),
                                barrierDismissible: true,
                                barrierColor: Colors.black12,
                              ).then((_) {
                                controller.agencyIsSelected = false;
                                controller.update();
                              })
                            : Get.offAllNamed(
                                controller.quickAccessRoutes[index].route,
                                arguments: controller
                                    .quickAccessRoutes[index].arguments,
                              );
                      },
                      color: index == 0
                          ? controller.agencyIsSelected
                              ? Colors.white
                              : AppColors.orange
                          : AppColors.orange,
                      child: Image.asset(
                        controller.quickAccessRoutes[index].image,
                        fit: BoxFit.fill,
                        height: 35,
                        color: index == 0
                            ? controller.agencyIsSelected
                                ? Colors.orange
                                : Colors.white
                            : Colors.white,
                      ),
                      padding: EdgeInsets.all(10),
                      shape: CircleBorder(),
                    );
                  },
                ),
              ),
              const VerticalSpacing(12),
              Text(
                controller.quickAccessRoutes[index].name,
                style: AppStyles.boldBlue13.copyWith(
                  color: AppColors.blue,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  GetBuilder<HomeController> _buildPageControl() {
    return GetBuilder<HomeController>(
      builder: (_) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [0, 1, 2].map((int index) {
            return CommonPageControl(
                currentCondition: controller.currentPage == index);
          }).toList(),
        );
      },
    );
  }

  CarouselSlider _buildCarouselForFundingRequests() {
    return CarouselSlider(
      options: CarouselOptions(
        height: context.height * (context.isTablet ? 0.3 : 0.42),
        aspectRatio: 16 / 9,
        viewportFraction: context.isTablet ? 0.65 : 0.8,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(seconds: 1),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        onPageChanged: (int page, CarouselPageChangedReason reason) {
          controller.currentPage = page;
          controller.update();
        },
        scrollDirection: Axis.horizontal,
      ),
      items: [0, 1, 2].map((int index) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () {
                launch(
                  controller.segments[index].link,
                  forceSafariVC: true,
                );
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  FittedBox(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Column(
                          children: [
                            Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Column(
                                  children: [
                                    Text(
                                      controller.segments[index].name,
                                      style: AppStyles.boldBlack13
                                          .copyWith(fontSize: 18),
                                    ),
                                    const VerticalSpacing(10),
                                    SizedBox(
                                      height: Get.context.height / 2.4,
                                      child: Image.asset(
                                        controller.segments[index].image,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const VerticalSpacing(25),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: CommonButton(
                      width: 225,
                      title: 'Demander un financement',
                      onPressed: () {
                        menuController.selectedIndex.value =
                            controller.segments[index].index;

                        Get.offAllNamed(
                          AppRoutes.requestCreation,
                          arguments: <String, dynamic>{
                            'creationMode': true,
                            'shouldLoadWS': false,
                            'data': null,
                            'onFirstTab': true,
                            'selectedFundingType': index,
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
