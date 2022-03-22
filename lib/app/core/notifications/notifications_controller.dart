import 'package:e_loan_mobile/Helpers/base_controller.dart';
import 'package:e_loan_mobile/Helpers/requests_interceptor.dart';
import 'package:e_loan_mobile/api/models/models.dart';
import 'package:e_loan_mobile/api/services/notifications_service.dart';
import 'package:e_loan_mobile/config/constants/app_constants.dart';
import 'package:e_loan_mobile/routes/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class NotificationsController extends BaseController {
  final NotificationsService _notificationsService = NotificationsService();
  final ScrollController scrollController = ScrollController();

  List<NotificationModel> notificationsList = <NotificationModel>[];
  int totalUnreaded = 0;
  bool initialState = true;
  bool isLoading = false;
  bool noMorePages = false;
  int page = 1;

  void reinitialize() {
    noMorePages = false;
    isLoading = false;
    page = 1;

    getNotifications(fromBeginnig: true);

    if (initialState) {
      initialState = false;
      scrollController?.addListener(() {
        if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
          getNotifications();
        }
      });
    }
  }

  Future<void> getNotifications({bool fromBeginnig = false}) {
    if (isLoading) return null;
    if (noMorePages && !fromBeginnig) return null;
    isLoading = true;
    // update();
    page = fromBeginnig ? 1 : page + 1;
    if (fromBeginnig)
      notificationsList.clear();
    else
      DioRequestsInterceptor.disableLoader();
    print(page);

    return _notificationsService.getNotifications(pageNumber: page).then((NotificationsResponse notificationsResponse) {
      if (notificationsResponse != null && notificationsResponse.notifications != null) {
        totalUnreaded = notificationsResponse.totalUnreaded;
        noMorePages = notificationsResponse.notifications.length < AppConstants.MAX_ITEMS_PER_PAGE;
        notificationsList.addAll(notificationsResponse.notifications);
      }
      if (notificationsList.isEmpty) totalUnreaded = 0;
      isLoading = false;
      update();
      if (Get.context.isTablet && notificationsList.length == 10 && Get.currentRoute == AppRoutes.notificationsPage)
        AppConstants.halfSecond.then(
          (value) => getNotifications(),
        );
      return;
    }).onError((dynamic error, StackTrace stackTrace) {
      page = fromBeginnig ? 1 : page - 1;
      isLoading = false;
      DioRequestsInterceptor.enableLoader();
    }).whenComplete(() {
      DioRequestsInterceptor.enableLoader();
      isLoading = false;
    });
  }

  void readNotification(int id) {
    if (notificationsList.where((NotificationModel notification) => notification.id == id).first.readed) return;
    _notificationsService.readNotification(id).then((bool success) {
      if (!success) return;
      notificationsList.where((NotificationModel notification) => notification.id == id).first.readed = true;
      totalUnreaded--;
      update();
    });
  }
}
