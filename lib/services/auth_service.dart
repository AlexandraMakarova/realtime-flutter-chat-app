import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';
import '../models/login_response.dart';
import '../global/environment.dart';

class AuthService with ChangeNotifier {
  User user;
  bool _authenticationInProcess = false;

  final _storage = new FlutterSecureStorage();

  bool get authenticationInProcess => this._authenticationInProcess;
  set authenticationInProcess(bool value) {
    this._authenticationInProcess = value;
    notifyListeners();
  }

  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.authenticationInProcess = true;

    final data = {
      'email': email,
      'password': password,
    };

    final response = await http.post(
      '${Environment.apiUrl}/login',
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    this.authenticationInProcess = false;
    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);

      return true;
    } else {
      return false;
    }
  }

  Future signUp(String name, String email, String password) async {
    this.authenticationInProcess = true;

    final data = {
      'name': name,
      'email': email,
      'password': password,
    };

    final response = await http.post(
      '${Environment.apiUrl}/login/new',
      body: jsonEncode(data),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    this.authenticationInProcess = false;
    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(response.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLogged() async {
    var token = await this._storage.read(key: 'token');
    if (token == null) {
      token = '';
    }
    final response = await http.get(
      '${Environment.apiUrl}/login',
      headers: {
        'Content-Type': 'application/json',
        'x-token': token,
      },
    );

    if (response.statusCode == 200) {
      final loginResponse = loginResponseFromJson(response.body);
      this.user = loginResponse.user;
      await this._saveToken(loginResponse.token);
      return true;
    } else {
      this.logOut();
      return false;
    }
  }

  Future _saveToken(String token) async {
    return await _storage.write(key: 'token', value: token);
  }

  Future logOut() async {
    return await _storage.delete(key: 'token');
  }
}
