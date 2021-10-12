import 'package:bpm_mobile/models/order.dart';

class NotificationModel {
  int id;
  String topic;
  String title;
  String body;
  String imageUrl;
  String data;
  String createdAt;
  String updatedAt;
  Order order;

  NotificationModel({
    required this.id,
    required this.topic,
    required this.title,
    required this.body,
    required this.imageUrl,
    required this.data,
    required this.createdAt,
    required this.updatedAt,
    required this.order,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        id: json['id'],
        topic: json['topic'],
        title: json['title'],
        body: json['body'],
        imageUrl: json['imageUrl'],
        data: json['data'],
        createdAt: json['created_at'],
        updatedAt: json['updated_at'],
        order: Order.fromJson(json['order']),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['topic'] = topic;
    json['title'] = title;
    json['body'] = body;
    json['imageUrl'] = imageUrl;
    json['data'] = data;
    json['created_at'] = createdAt;
    json['updated_at'] = updatedAt;
    json['order'] = order;
    return json;
  }
}
