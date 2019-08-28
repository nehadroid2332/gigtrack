import 'dart:io';

import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/activities_list_response.dart';
import 'package:gigtrack/server/models/activities_response.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/band_list_response.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/get_contact_list_response.dart';
import 'package:gigtrack/server/models/instrument.dart';
import 'package:gigtrack/server/models/login_response.dart';
import 'package:gigtrack/server/models/note_todo_response.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/server/models/register_response.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/utils/network_utils.dart';

import 'models/add_band_response.dart';
import 'models/add_contact_response.dart';
import 'models/add_instrument_response.dart';
import 'models/add_playing_style_response.dart';
import 'models/band_details_response.dart';
import 'models/band_member_add_response.dart';
import 'models/forgot_password_response.dart';
import 'models/instruments_list_response.dart';
import 'models/notes_todo_list_response.dart';
import 'models/notification_list_response.dart';
import 'models/playing_style_response.dart';
import 'models/search_user_response.dart';
import 'models/update_activity_bandmember_status.dart';

class ServerAPI {
  static final ServerAPI _serverApi = new ServerAPI._internal();

  factory ServerAPI() {
    return _serverApi;
  }

  String userId;
  String token;
  NetworkUtil _netUtil = new NetworkUtil();

  static final _baseUrl = "https://www.accountechs.online/gigtrack/api/";
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
      return AddBandResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addContact(Contacts contacts) async {
    try {
      Map<String, File> files = new Map();
      for (var i = 0; i < contacts.files.length; i++) {
        File ff = contacts.files[i];
        files['media$i'] = ff;
      }
      final res = await _netUtil.upload(_baseUrl + "contact/add", files,
          contacts.toStringMap(), _headers, "POST");
      return AddContactResponse.fromJSON(res);
    } catch (e) {
      print(e);
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getContacts() async {
    try {
      final res = await _netUtil.get(
        _baseUrl + "contact/get_contacts",
        headers: _headers,
      );
      return GetContactListResponse.fromJSON(res);
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
      return BandDetailsResponse.fromJSON(res);
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
      final res = activities.id.isEmpty
          ? await _netUtil.post(
              _baseUrl + "activities/add",
              body: activities.toMap(),
              headers: _headers,
            )
          : await _netUtil.put(
              _baseUrl + "activities/edit/${activities.id}",
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
      Map<String, File> files = Map();
      if (instrument.files?.isNotEmpty ?? false) {
        files["equipment"] = instrument.files[0];
      }

      final res = instrument.id.isEmpty
          ? await _netUtil.upload(_baseUrl + "equipments/add", files,
              instrument.toStringMap(), _headers, "POST")
          : await _netUtil.post(
              _baseUrl + "equipments/edit/${instrument.id}",
              headers: _headers,
              body: instrument.toMap(),
            );
      return AddInstrumentResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> updateBandmateStatusForActivity(
      String activityId, int status) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "activities/activity_status",
        body: {
          "id": activityId,
          "status": status,
        },
        headers: _headers,
      );
      return UpdateAcivityBandMemberStatusResponse.fromJSON(res);
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

  Future<dynamic> getNotifications(String date) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "notifications",
        headers: _headers,
        body: {
          //  "date": date,
        },
      );
      return NotificationListResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getActivityDetails(String id) async {
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

  Future<dynamic> getPlayingStyleList() async {
    try {
      final res = await _netUtil.get(
        _baseUrl + "pstyle/",
        headers: _headers,
      );
      return PlayingStyleResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> searchUser(String name) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "auth/search",
        headers: _headers,
        body: {
          "name": name,
        },
      );
      return SearchUserResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addBandMember(String bandId, String memberId) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "bands/add_bandmate",
        headers: _headers,
        body: {
          "band_id": bandId,
          "bandmate_id": memberId,
        },
      );
      return BandMemberAddResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addUserPlayingStyle(String userId, String bandId,
      String playingStyleId, String instrumentId) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "pstyle/add",
        headers: _headers,
        body: {
          "user_id": userId,
          "band_id": bandId,
          "playing_styles_ids": playingStyleId,
          "instruments_ids": instrumentId,
        },
      );
      return AddPlayingStyleResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getSingleUserById(int id) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "auth/single",
        headers: _headers,
        body: {
          "user_id": id,
        },
      );
      User user;
      if (res['data'] != null) {
        for (var d in res['data']) {
          user = User.fromJSON(d);
        }
      }
      return user;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> forgotPassword(String email) async {
    try {
      final res = await _netUtil.post(
        _baseUrl + "auth/forget_password",
        headers: _headers,
        body: {
          "email": email,
        },
      );
      return ForgetPasswordResponse.fromJSON(res);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }
}
