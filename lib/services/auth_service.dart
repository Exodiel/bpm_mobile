import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:http/http.dart' as http;

import 'package:bpm_mobile/util/utilities.dart';

class AuthService extends ChangeNotifier {
  final String _baseUrl = '$url/api/v1';
  final String _firebaseToken = 'AIzaSyBcytoCbDUARrX8eHpcR-Bdrdq0yUmSjf8';

  final storage = const FlutterSecureStorage();

  // Si retornamos algo, es un error, si no, todo bien!
  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      // Token hay que guardarlo en un lugar seguro
      await storage.write(key: 'token', value: decodedResp['idToken']);
      // decodedResp['idToken'];
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    final url = Uri.parse(_baseUrl + '/auth/login');
    final resp = await http.post(
      url,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    if (decodedResp.containsKey('accessToken')) {
      // Token hay que guardarlo en un lugar seguro
      // decodedResp['idToken'];
      await storage.write(
          key: 'user',
          value: json.encode({
            'token': decodedResp['accessToken'],
            'id': decodedResp['user']['id'],
            'rol': decodedResp['user']['rol']
          }));
      return null;
    } else {
      return decodedResp['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'user');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'user') ?? '';
  }
}
