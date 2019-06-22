import 'dart:io';

import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/activities_response.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/band_list_response.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/login_response.dart';
import 'package:gigtrack/server/models/note_todo_response.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/server/models/register_response.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/utils/network_utils.dart';

class ServerAPI {
  static final ServerAPI _serverApi = new ServerAPI._internal();
  factory ServerAPI() {
    return _serverApi;
  }

  NetworkUtil _netUtil = new NetworkUtil();

  static final _baseUrl = "http://www.accountechs.online/gigtrack/api/";
  final _headers = {"Auth-Key": "gigtrackkey"};
  ServerAPI._internal();

  Future<dynamic> login(String email, String password) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "auth/login",
        body: {"email": email, "password": password},
        headers: _headers,
      );
      final lRes = LoginResponse.fromJSON(res);
      return lRes;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  void setUpHeaderAfterLogin(String userId, String token) {
    _headers['User-ID'] = userId;
    _headers['Authorization'] = token;
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

  Future<dynamic> getBands() async {
    try {
      final res = await _netUtil.get(
        _baseUrl + "bands",
        headers: _headers,
      );
      return BandListResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addNotes(NotesTodo notesTodo) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "notes/add",
        body: notesTodo.toMap(),
        headers: _headers,
      );
      return NoteTodoResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addActivities(Activites activities) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "activities/add",
        body: activities.toMap(),
        headers: _headers,
      );
      return ActivitiesResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getActivities({int bandId}) async {
    try {
      Map<String, dynamic> data = {
        "type": 0,
        "band_id": bandId,
      };
      final res = await _netUtil.post(
        _baseUrl + "activities/get_activities",
        headers: _headers,
        body: data,
      );
      return ActivitiesResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getSchedules({int bandId}) async {
    try {
      Map<String, dynamic> data = {
        "type": 1,
        "band_id": bandId,
      };
      final res = await _netUtil.post(
        _baseUrl + "activities/get_schedules",
        headers: _headers,
        body: data,
      );
      return ActivitiesResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }
}
