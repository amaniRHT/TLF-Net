import 'package:e_loan_mobile/Helpers/usefull_metods.dart';
import 'package:e_loan_mobile/api/models/notification_model.dart';
import 'package:e_loan_mobile/api/services/notifications_service.dart';
import 'package:e_loan_mobile/app/controllers.dart';
import 'package:e_loan_mobile/app/core/notifications/notifications_list_page.dart';
import 'package:e_loan_mobile/config/config.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:e_loan_mobile/static/statics.dart';
import 'package:e_loan_mobile/widgets/custom_toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class NotificationManager {
  static Future<String> getToken() {
    return FirebaseMessaging.instance.getToken();
  }

  static void initialize() {
    // for ios and web only
    FirebaseMessaging.instance.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (!Statics.isLoggedIn) return;

      final PushNotificationModel notification = PushNotificationModel.fromJson(message.data);
      if (notification == null) return;
      final String _notificationMessage = UsefullMethods.constructNotificationText(notification);

      showCustomToast(
        toastType: ToastTypes.push,
        padding: 12,
        contentText: _notificationMessage,
        blurEffectEnabled: true,
        duration: 7,
      ).then((_) => AppConstants.halfSecond.then((_) {
            print('Type: ${notification.type}');
            getNotifications();
            switch (notification.type) {
              case 'financement':
                if (Get.currentRoute == AppRoutes.requestsList)
                  Get.find<FundingRequestsListController>()?.getRequests(fromBeginnig: true);
                else if (Get.currentRoute == AppRoutes.requestDetails &&
                    notification.id != null &&
                    notification.id.isNotEmpty)
                  Get.find<RequestDetailsController>()?.getRequestDetails(int.tryParse(notification.id));

                break;
              case 'cotation':
                if (Get.currentRoute == AppRoutes.quotationRequestsList)
                  Get.find<QuotationRequestsListController>()?.getRequests(fromBeginnig: true);
                else if (Get.currentRoute == AppRoutes.quotationRequestDetails &&
                    notification.id != null &&
                    notification.id.isNotEmpty)
                  Get.find<QuotationRequestDetailsController>()?.getRequestDetails(int.tryParse(notification.id));

                break;
              case 'rdv':
                if (Get.currentRoute == AppRoutes.rdvsList) {
                  Get.find<RDVsListController>()?.getRDVs();
                }
                break;

              default:
                return;
            }
          }));
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (!Statics.isLoggedIn) return;
      final PushNotificationModel notification = PushNotificationModel.fromJson(message.data);
      if (notification == null) return;
      final NotificationsController notificationsController = Get.find();
      notificationsController.getNotifications().then((_) {
        notificationsController.readNotification(int.tryParse(notification.id));
        UsefullMethods.redirectNotification(notification);
      }).onError((_, __) {
        Get.offAll(
          () => NotificationsListPage(),
          transition: Transition.upToDown,
        );
      });
    });

    FirebaseMessaging.onBackgroundMessage(
      NotificationManager.onBackgroundMessage,
    );

    FirebaseMessaging.instance.onTokenRefresh.listen((String newToken) {
      print('FCM token => $newToken');
      Statics.fcmToken = newToken;
      if (!Statics.isLoggedIn) return;
      final NotificationsService _notificationsService = NotificationsService();
      _notificationsService.sendNotificationsRegistrationRequirements();
    });
  }

  static Future<void> onBackgroundMessage(RemoteMessage message) async {
    if (!Statics.isLoggedIn) return;
    getNotifications();
  }

  static void getNotifications() async {
    if (!Statics.isLoggedIn) return;
    final NotificationsController notificationsController = Get.find();
    notificationsController?.totalUnreaded++;
    notificationsController?.update();
  }
}
