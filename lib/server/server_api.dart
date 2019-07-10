import 'dart:io';

import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/activities_list_response.dart';
import 'package:gigtrack/server/models/activities_response.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/band_list_response.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/instrument.dart';
import 'package:gigtrack/server/models/login_response.dart';
import 'package:gigtrack/server/models/note_todo_response.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/server/models/register_response.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/utils/network_utils.dart';

import 'models/add_instrument_response.dart';
import 'models/instruments_list_response.dart';
import 'models/notes_todo_list_response.dart';
import 'models/notification_list_response.dart';

class ServerAPI {
  static final ServerAPI _serverApi = new ServerAPI._internal();
  factory ServerAPI() {
    return _serverApi;
  }

  String userId;
  String token;
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
    userId = userId;
    token = token;
  }

  Future<dynamic> register(User user, File file) async {
    try {
      final res =
          // file != null
          //     ? await _netUtil.upload(_baseUrl + "auth/register", "profile_image",
          //         file, user.toStringMap(), _headers, "POST")
          //     :
          await _netUtil.post(_baseUrl + "auth/register",
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

  Future<dynamic> getBandDetails(String id) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "bands/single",
        headers: _headers,
        body: {
          "id": id,
        },
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

  Future<dynamic> addInstrument(Instrument instrument) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "equipments/add",
        body: instrument.toMap(),
        headers: _headers,
      );
      return AddInstrumentResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getInstruments() async {
    try {
      final res = await _netUtil.get(
        _baseUrl + "equipments",
        headers: _headers,
      );
      return InstrumentListResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getInstrumentDetails(String id) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "equipments/single",
        headers: _headers,
        body: {
          "id": id,
        },
      );
      return InstrumentListResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getNotifications() async {
    try {
      final res = await _netUtil.get(
        _baseUrl + "notifications",
        headers: _headers,
      );
      return NotificationListResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getActivitieDetails(String id) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "activities/single",
        headers: _headers,
        body: {
          "id": id,
        },
      );
      return GetActivitiesListResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getActivities() async {
    try {
      final res = await _netUtil.get(
        _baseUrl + "activities/get_activities",
        headers: _headers,
      );
      return GetActivitiesListResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getSchedules() async {
    try {
      final res = await _netUtil.get(
        _baseUrl + "activities/get_schedules",
        headers: _headers,
      );
      return GetActivitiesListResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getNotes() async {
    try {
      final res = await _netUtil.get(
        _baseUrl + "notes/get_notes",
        headers: _headers,
      );
      return GetNotesTodoListResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getNoteDetails(String id) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "notes/single",
        headers: _headers,
        body: {
          "id": id,
        },
      );
      return GetNotesTodoListResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getTodos() async {
    try {
      final res = await _netUtil.get(
        _baseUrl + "notes/get_todo",
        headers: _headers,
      );
      return GetNotesTodoListResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }
}
