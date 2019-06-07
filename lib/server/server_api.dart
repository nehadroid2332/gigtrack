import 'dart:io';

import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/login_response.dart';
import 'package:gigtrack/server/models/register_response.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/utils/network_utils.dart';

class ServerAPI {
  static final ServerAPI _serverApi = new ServerAPI._internal();
  factory ServerAPI() {
    return _serverApi;
  }

  NetworkUtil _netUtil = new NetworkUtil();

  static final _baseUrl = "http://wptactic.com/gigtrack/api/";
  final _headers = {"Auth-Key": "gigtrackkey"};
  ServerAPI._internal();

  Future<dynamic> login(String email, String password) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "auth/login",
        body: {"email": email, "password": password},
        headers: _headers,
      );
      return LoginResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> register(User user, File file) async {
    try {
      final res = file != null
          ? await _netUtil.upload(_baseUrl + "auth/register", "profile_image",
              file, user.toStringMap(), _headers, "POST")
          : await _netUtil.post(_baseUrl,
              body: user.toMap(), headers: _headers);
      return RegisterResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addBand(Band band) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "bands/add",
        body: band.toMap(),
        headers: _headers,
      );
      return RegisterResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }
}
