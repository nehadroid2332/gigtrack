import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/instrument.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/utils/network_utils.dart';
import 'package:path/path.dart';

import 'models/add_playing_style_response.dart';
import 'models/band_member_add_response.dart';
import 'models/forgot_password_response.dart';
import 'models/notification_list_response.dart';
import 'models/playing_style_response.dart';
import 'models/update_activity_bandmember_status.dart';

class ServerAPI {
  static final ServerAPI _serverApi = new ServerAPI._internal();

  StorageReference equipmentRef;

  StorageReference contactsRef;

  DatabaseReference notesDB;

  factory ServerAPI() {
    return _serverApi;
  }

  String userId;
  String token;
  NetworkUtil _netUtil = new NetworkUtil();

  static final _baseUrl = "https://www.accountechs.online/gigtrack/api/";
  final _headers = {"Auth-Key": "gigtrackkey"};

  FirebaseAuth _auth;
  DatabaseReference userDB;
  DatabaseReference activitiesDB, bandDB, equipmentsDB, contactDB;
  String currentUserId;

  ServerAPI._internal() {
    _auth = FirebaseAuth.instance;
    StorageReference storageRef = FirebaseStorage.instance.ref();
    equipmentRef = storageRef.child("Equipments");
    contactsRef = storageRef.child("Contacts");
    DatabaseReference _mainFirebaseDatabase =
        FirebaseDatabase.instance.reference().child("Gigtrack");
    userDB = _mainFirebaseDatabase.child("users");
    activitiesDB = _mainFirebaseDatabase.child("activities");
    bandDB = _mainFirebaseDatabase.child("bands");
    equipmentsDB = _mainFirebaseDatabase.child("equipments");
    contactDB = _mainFirebaseDatabase.child("contacts");
    notesDB = _mainFirebaseDatabase.child("notes");
    getCurrentUser();
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    currentUserId = user?.uid;
    return user;
  }

  Future<dynamic> login(String email, String password) async {
    try {
      final res = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      final lRes = res.user;
      await getCurrentUser();
      return lRes;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> register(User user, File file) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      AuthResult authResult1 = await _auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      user.id = authResult1.user.uid;
      final res = await userDB.child(user.id).set(user.toMap());
      await _auth.signOut();
      return "Success";
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addBand(Band band) async {
    try {
      bool isUpdate = true;
      if (band.id == null || band.id.isEmpty) {
        String id = bandDB.push().key;
        band.id = id;
        isUpdate = false;
      }
      await bandDB.child(band.id).set(band.toMap());
      return isUpdate;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addContact(Contacts contacts) async {
    try {
      for (File file in contacts.files) {
        String basename = extension(file.path);
        final StorageUploadTask uploadTask = contactsRef
            .child("${DateTime.now().toString()}$basename")
            .putFile(file);
        StorageTaskSnapshot snapshot = await uploadTask.onComplete;
        String url = await snapshot.ref.getDownloadURL();
        print("SD-> $url");
        contacts.uploadedFiles.add(url);
      }
      contacts.files = [];
      bool isUpdate = true;
      if (contacts.id == null || contacts.id.isEmpty) {
        String id = equipmentsDB.push().key;
        contacts.id = id;
        isUpdate = false;
      }
      await contactDB.child(contacts.id).set(contacts.toMap());
      return isUpdate;
    } catch (e) {
      print(e);
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getContactDetails(String id) async {
    try {
      DataSnapshot dataSnapshot = await contactDB.child(id).once();
      Contacts band = Contacts.fromJSON(dataSnapshot.value);
      return band;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getBandDetails(String id) async {
    try {
      DataSnapshot dataSnapshot = await bandDB.child(id).once();
      Band band = Band.fromJSON(dataSnapshot.value);
      for (String id in band.bandmates.keys) {
        User user = await getSingleUserById(id);
        band.bandmateUsers.add(user);
      }
      return band;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addNotes(NotesTodo notesTodo) async {
    try {
      bool isUpdate = true;
      if (notesTodo.id == null || notesTodo.id.isEmpty) {
        String id = notesDB.push().key;
        notesTodo.id = id;
        isUpdate = false;
      }
      await notesDB.child(notesTodo.id).set(notesTodo.toMap());
      return isUpdate;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addActivities(Activites activities) async {
    try {
      bool isUpdate = true;
      if (activities.id == null || activities.id.isEmpty) {
        String id = activitiesDB.push().key;
        activities.id = id;
        isUpdate = false;
      }
      await activitiesDB.child(activities.id).set(activities.toMap());
      return isUpdate;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addInstrument(Instrument instrument) async {
    try {
      for (File file in instrument.files) {
        String basename = extension(file.path);
        final StorageUploadTask uploadTask = equipmentRef
            .child("${DateTime.now().toString()}$basename")
            .putFile(file);
        StorageTaskSnapshot snapshot = await uploadTask.onComplete;
        String url = await snapshot.ref.getDownloadURL();
        instrument.uploadedFiles.add(url);
      }
      instrument.files = [];
      bool isUpdate = true;
      if (instrument.id == null || instrument.id.isEmpty) {
        String id = equipmentsDB.push().key;
        instrument.id = id;
        isUpdate = false;
      }

      await equipmentsDB.child(instrument.id).set(instrument.toMap());
      return isUpdate;
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

  Future<dynamic> getInstrumentDetails(String id) async {
    try {
      DataSnapshot dataSnapshot = await equipmentsDB.child(id).once();
      return Instrument.fromJSON(dataSnapshot.value);
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
      DataSnapshot dataSnapshot = await activitiesDB.child(id).once();
      return Activites.fromJSON(dataSnapshot.value);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getNoteDetails(String id) async {
    try {
      DataSnapshot dataSnapshot = await notesDB.child(id).once();
      return NotesTodo.fromJSON(dataSnapshot.value);
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
      final res = await userDB.once();
      Map mp = res.value;
      List<User> acc = [];
      for (var d in mp.values) {
        User user = User.fromJSON(d);
        if (user.firstName.toLowerCase().contains(name.toLowerCase()) ||
            user.lastName.toLowerCase().contains(name.toLowerCase()))
          acc.add(user);
      }
      return acc;
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

  Future<dynamic> getSingleUserById(String id) async {
    try {
      DataSnapshot dataSnapshot = await userDB.child(id).once();
      return User.fromJSON(dataSnapshot.value);
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

  void logout() async {
    await _auth.signOut();
  }
}
