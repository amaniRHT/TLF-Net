import 'package:e_loan_mobile/Helpers/helpers.dart';

class NotificationsResponse {
  int totalUnreaded;
  List<NotificationModel> notifications;

  NotificationsResponse({this.totalUnreaded, this.notifications});

  NotificationsResponse.fromJson(Map<String, dynamic> json) {
    totalUnreaded = json['totalUnreaded'];
    if (json['notifications'] != null) {
      notifications = <NotificationModel>[];
      json['notifications'].forEach((v) {
        notifications.add(NotificationModel.fromJson(v));
      });
    }
  }
}

class NotificationModel {
  int id;
  int status;
  String type;
  String requestNumber;
  int requestId;
  String date;
  bool readed;

  NotificationModel({
    this.id,
    this.status,
    this.type,
    this.requestNumber,
    this.requestId,
    this.date,
    this.readed,
  });

  NotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    type = json['type'];
    requestNumber = json['demandeNumber'];
    if (json['demandeId'] != null) requestId = int.tryParse(json['demandeId']);
    if (json['date'] != null) date = UsefullMethods.toAbbreviatedDate(DateTime.parse(json['date']), 'fr');
    readed = json['readed'];
  }
}

class PushNotificationModel {
  String id;
  String status;
  String type;
  String requestNumber;
  String requestId;
  String date;

  PushNotificationModel({
    this.id,
    this.status,
    this.type,
    this.requestNumber,
    this.requestId,
    this.date,
  });

  PushNotificationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status = json['status'];
    type = json['type'];
    requestNumber = json['demandeNumber'];
    requestId = json['demandeId'];
    date = json['date'];
  }
}
