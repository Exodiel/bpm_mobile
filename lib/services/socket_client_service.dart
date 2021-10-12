import 'dart:async';

import 'package:bpm_mobile/models/notification.dart';
import 'package:bpm_mobile/models/order.dart';

class StreamSocket {
  final _socketResponseNotification = StreamController<NotificationModel>();
  final _socketResponseOrder = StreamController<Order>();

  void Function(NotificationModel) get addResponse =>
      _socketResponseNotification.sink.add;

  Stream<NotificationModel> get getResponse =>
      _socketResponseNotification.stream;

  void Function(Order) get addResponseOrder => _socketResponseOrder.sink.add;

  Stream<Order> get getResponseOrder => _socketResponseOrder.stream;

  void dispose() {
    _socketResponseNotification.close();
    _socketResponseOrder.close();
  }
}
