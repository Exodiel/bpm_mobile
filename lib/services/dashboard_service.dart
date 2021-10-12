import 'package:bpm_mobile/models/report_by_months.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import 'package:bpm_mobile/util/utilities.dart';

class DashboardService extends ChangeNotifier {
  final String _baseUrl = '$url/api/v1';
  final storage = const FlutterSecureStorage();

  Future<int> getTotalOrders() async {
    final userEncoded = await storage.read(key: 'user');
    final userDecoded = jsonDecode(userEncoded!);
    final token = userDecoded['token'];

    final url = Uri.parse(_baseUrl + '/order/all?limit=1&offset=0');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    });

    final decoded = json.decode(response.body);

    int counter = decoded['total'];

    return counter;
  }

  Future<int> getTotalCustomers() async {
    final userEncoded = await storage.read(key: 'user');
    final userDecoded = jsonDecode(userEncoded!);
    final token = userDecoded['token'];

    final url = Uri.parse(_baseUrl + '/user/all?offset=0&limit=1&type=client');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    });

    final decoded = json.decode(response.body);

    int counter = decoded['total'];

    return counter;
  }

  Future<int> getTotalSuppliers() async {
    final userEncoded = await storage.read(key: 'user');
    final userDecoded = jsonDecode(userEncoded!);
    final token = userDecoded['token'];

    final url =
        Uri.parse(_baseUrl + '/user/all?offset=0&limit=1&type=supplier');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    });

    final decoded = json.decode(response.body);

    int counter = decoded['total'];

    return counter;
  }

  Future<List<ReportByMonth>> getTotalsByMonth() async {
    List<ReportByMonth> data = [];
    final userEncoded = await storage.read(key: 'user');
    final userDecoded = jsonDecode(userEncoded!);
    final token = userDecoded['token'];

    final url = Uri.parse(_baseUrl + '/order/find-totals-by-month/Venta/devuelto');
    final response = await http.get(url, headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + token
    });

    final decoded = json.decode(response.body);
    decoded['data'].forEach((report) {
      final tempReport = ReportByMonth.fromJson(report);
      data.add(tempReport);
    });

    return data;
  }
}
