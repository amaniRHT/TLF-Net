import 'package:e_loan_mobile/Helpers/usefull_metods.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/app/core/notifications/notifications_controller.dart';
import 'package:e_loan_mobile/config/colors/app_colors.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationItem extends StatelessWidget {
  NotificationItem({
    Key key,
    @required this.notification,
  }) : super(key: key);

  final NotificationsController controller = Get.find();
  final NotificationModel notification;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NotificationsController>(
      builder: (_) {
        return MaterialButton(
          onPressed: () {
            controller.readNotification(notification.id);
            UsefullMethods.redirectNotification(notification);
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Column(
              children: [
                const VerticalSpacing(15),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      Image.asset(
                        _buildNotificationImage(notification),
                        color: notification.readed ? AppColors.darkGrey : AppColors.orange,
                        height: 40,
                        width: 60,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              UsefullMethods.constructNotificationText(notification),
                              style: AppStyles.mediumBlack13.copyWith(
                                color: notification.readed ? AppColors.darkGrey : AppColors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const HorizontalSpacing(12),
                      Icon(
                        Icons.circle,
                        size: 14,
                        color: notification.readed ? AppColors.darkGrey : AppColors.orange,
                      )
                    ],
                  ),
                ),
                Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      notification.date,
                      style: AppStyles.boldGrey12.copyWith(
                        color: notification.readed ? AppColors.darkGrey : AppColors.blue,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                const VerticalSpacing(10),
                Container(
                  height: 1,
                  margin: const EdgeInsets.only(left: 18),
                  color: AppColors.darkerBlue,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _buildNotificationImage(NotificationModel notification) {
    switch (notification.type) {
      case 'financement':
        return AppImages.fundingShortcut;
      case 'cotation':
        return AppImages.requestQuotation;
      case 'rdv':
        return AppImages.calendarEvent;
      case 'sav':
        return AppImages.homeSmile;
      default:
        return AppImages.homeSmile;
    }
  }
}
