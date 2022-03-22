import 'package:e_loan_mobile/app/core/notifications/notification_item.dart';
import 'package:e_loan_mobile/app/core/notifications/notifications_controller.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationsListPage extends StatefulWidget {
  const NotificationsListPage({Key key}) : super(key: key);

  @override
  _State createState() => _State();
}

class _State extends State<NotificationsListPage> {
  final NotificationsController controller = Get.find();

  @override
  void initState() {
    controller.reinitialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      builder: (_) {
        return SafeAreaManager(
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const CommonAppBar(),
            body: _buildContent(),
          ),
        );
      },
    );
  }

  Column _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const VerticalSpacing(27),
        Padding(
          padding: AppConstants.mediumPadding,
          child: const CommonTitle(title: 'Notifications'),
        ),
        const VerticalSpacing(14),
        GetBuilder<NotificationsController>(builder: (_) {
          return _notificationsList();
        }),
      ],
    );
  }

  Expanded _notificationsList() {
    return Expanded(
      child: RefreshIndicator(
        onRefresh: _refreshNotificationsList,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(
              parent: const AlwaysScrollableScrollPhysics()),
          padding: const EdgeInsets.only(top: 5, bottom: 30),
          itemCount: 2,
          controller: controller.scrollController,
          itemBuilder: (BuildContext _, int index) {
            return (index == 0)
                ? InteractiveLister(
                    placeholderCondition:
                        controller.notificationsList.isEmpty &&
                            !controller.isLoading,
                    placeholderText:
                        controller.isLoading ? '' : 'Aucune notification reçue',
                    placeholderRefreshFunction: _refreshNotificationsList,
                    dataSource: controller.notificationsList,
                    itemBuilder: (BuildContext _, int index) =>
                        NotificationItem(
                      notification: controller.notificationsList[index],
                    ),
                    childAspectRatioMultiplyer: 2.5,
                  )
                : PagingIndicator(
                    visiblityCondition: !controller.noMorePages &&
                        !controller.notificationsList.isEmpty,
                  );
          },
        ),
      ),
    );
  }

  Future<void> _refreshNotificationsList() async {
    controller.getNotifications(fromBeginnig: true);
  }
}
