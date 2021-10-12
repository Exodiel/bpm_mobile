import 'package:bpm_mobile/models/notification.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import 'package:bpm_mobile/util/utilities.dart';

class NotificationsService extends ChangeNotifier {
  final String _baseUrl = '$url/api/v1';
  final storage = const FlutterSecureStorage();
  bool isLoading = true;

  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  Future<List<NotificationModel>> getNotifications() async {
    List<NotificationModel> notifications = [];
    final userEncoded = await storage.read(key: 'user');
    final userDecoded = jsonDecode(userEncoded!);
    final token = userDecoded['token'];

    final url = Uri.parse(_baseUrl + '/notification/all?limit=0&offset=0');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    });

    final decoded = json.decode(response.body);

    decoded['data'].forEach((notification) {
      final tempNoti = NotificationModel.fromJson(notification);
      notifications.add(tempNoti);
    });

    return notifications;
  }

  static showSnackbar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );

    messengerKey.currentState!.showSnackBar(snackBar);
  }
}
