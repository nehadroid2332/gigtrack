import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:mailer/mailer.dart' as mailer;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gigtrack/server/models/activities.dart';
import 'package:gigtrack/server/models/band.dart';
import 'package:gigtrack/server/models/bulletinboard.dart';
import 'package:gigtrack/server/models/contacts.dart';
import 'package:gigtrack/server/models/error_response.dart';
import 'package:gigtrack/server/models/notestodo.dart';
import 'package:gigtrack/server/models/notifications.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/server/models/user_playing_style.dart';
import 'package:gigtrack/utils/network_utils.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:path/path.dart';
import 'models/band_member_add_response.dart';
import 'models/notification_list_response.dart';
import 'models/update_activity_bandmember_status.dart';
import 'models/user_instrument.dart';

class ServerAPI {
  static final ServerAPI _serverApi = new ServerAPI._internal();

  StorageReference equipmentRef;

  StorageReference contactsRef;

  StorageReference playingstyleRef;

  DatabaseReference notesDB, bulletinDB;

  SmtpServer smtpServer;

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
  DatabaseReference activitiesDB,
      bandDB,
      equipmentsDB,
      contactDB,
      playingStyleDB,
      notificationDB;
  String currentUserId, currentUserEmail;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  ServerAPI._internal() {
    _auth = FirebaseAuth.instance;
    StorageReference storageRef = FirebaseStorage.instance.ref();
    equipmentRef = storageRef.child("Equipments");
    contactsRef = storageRef.child("Contacts");
    playingstyleRef = storageRef.child("PlayingStyle");
    DatabaseReference _mainFirebaseDatabase =
        FirebaseDatabase.instance.reference().child("Gigtrack");
    userDB = _mainFirebaseDatabase.child("users");
    activitiesDB = _mainFirebaseDatabase.child("activities");
    bandDB = _mainFirebaseDatabase.child("bands");
    equipmentsDB = _mainFirebaseDatabase.child("equipments");
    contactDB = _mainFirebaseDatabase.child("contacts");
    notesDB = _mainFirebaseDatabase.child("notes");
    bulletinDB = _mainFirebaseDatabase.child("bulletIn");
    playingStyleDB = _mainFirebaseDatabase.child("playingStyle");
    notificationDB = _mainFirebaseDatabase.child("notifications");
    getCurrentUser();
    firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      // onBackgroundMessage: myBackgroundMessageHandler,
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
  }

  Future<dynamic> myBackgroundMessageHandler(
      Map<String, dynamic> message) async {
    print("SD-> ${message}");
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

    // Or do other work.
    return "";
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _auth.currentUser();
    currentUserId = user?.uid;
    currentUserEmail = user?.email;
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
      await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      AuthResult authResult1 = await _auth.signInWithEmailAndPassword(
          email: user.email, password: user.password);
      user.id = authResult1.user.uid;
      await userDB.child(user.id).set(user.toMap());
      final snapshot = await bandDB.once();

      Map mp = snapshot.value;
      for (var d in mp.values) {
        final band = Band.fromJSON(d);
        if (band != null) {
          for (var mem in band.bandmates.keys) {
            BandMember bandMember = band.bandmates[mem];
            if (bandMember.email == user.email) {
              if (bandMember.user_id == null || bandMember.user_id.isEmpty) {
                bandMember.user_id = user.id;
              }
            }
          }
        }
        await addBand(band);
      }
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
      for (var i = 0; i < contacts.files?.length ?? 0; i++) {
        File file1 = File(contacts.files[i]);
        if (await file1.exists()) {
          String basename = extension(file1.path);
          File newFile = File(
              file1.parent.path + "/temp-${await file1.length()}" + basename);
          File file = await compressFileAndGetFile(file1, newFile.path);
          final StorageUploadTask uploadTask = contactsRef
              .child("${DateTime.now().toString()}$basename")
              .putFile(file);
          StorageTaskSnapshot snapshot = await uploadTask.onComplete;
          String url = await snapshot.ref.getDownloadURL();
          print("SD-> $url");
          contacts.files[i] = url;
        }
      }
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
      return band;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addNotification(Notification notification) async {
    try {
      bool isUpdate = true;
      if (notification.id == null || notification.id.isEmpty) {
        String id = notesDB.push().key;
        notification.id = id;
        isUpdate = false;
      }
      await notificationDB.child(notification.id).set(notification.toMap());
      return isUpdate;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> getPlayingStyleDetails(String id) async {
    try {
      DataSnapshot dataSnapshot = await playingStyleDB.child(id).once();
      UserPlayingStyle userPlayingStyle =
          UserPlayingStyle.fromJSON(dataSnapshot.value);
      return userPlayingStyle;
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

  Future<dynamic> addBulletInBoard(BulletInBoard bulletinboard) async {
    try {
      bool isUpdate = true;
      if (bulletinboard.id == null || bulletinboard.id.isEmpty) {
        String id = bulletinDB.push().key;
        bulletinboard.id = id;
        isUpdate = false;
      }
      await bulletinDB.child(bulletinboard.id).set(bulletinboard.toMap());
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

  Future<dynamic> addInstrument(UserInstrument instrument) async {
    try {
      if (instrument.uploadedFiles.length > 0) {
        for (var i = 0; i < instrument.uploadedFiles.length; i++) {
          File file1 = File(instrument.uploadedFiles[i]);

          if (await file1.exists()) {
            String basename = extension(file1.path);
            File newFile = File(
                file1.parent.path + "/temp-${await file1.length()}" + basename);
            File file = await compressFileAndGetFile(file1, newFile.path);
            final StorageUploadTask uploadTask = equipmentRef
                .child("${DateTime.now().toString()}$basename")
                .putFile(file);
            StorageTaskSnapshot snapshot = await uploadTask.onComplete;
            String url = await snapshot.ref.getDownloadURL();
            instrument.uploadedFiles[i] = url;
          }
        }
      }
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

  Future<File> compressFileAndGetFile(File file, String targetPath) async {
    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 40,
    );
    return result;
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
      return UserInstrument.fromJSON(dataSnapshot.value);
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

  Future<dynamic> getBulletInBoardDetails(String id) async {
    try {
      DataSnapshot dataSnapshot = await bulletinDB.child(id).once();
      return BulletInBoard.fromJSON(dataSnapshot.value);
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> searchUser(String name) async {
    try {
      final res =
          await contactDB.orderByChild("user_id").equalTo(currentUserId).once();
      Map mp = res.value;
      List<Contacts> acc = [];
      if (mp == null) return acc;
      for (var d in mp.values) {
        Contacts user = Contacts.fromJSON(d);
        if (user.name.toLowerCase().contains(name.toLowerCase())) {
          acc.add(user);
        }
      }
      return acc;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> sendEmail(
      String bandName, String bandAdminName, String emailReciptant) async {
    try {
      SmtpServer smtpServer =
          gmail("honeyverma.india@gmail.com", "SHIVAMverma1992");

      final message = new mailer.Message()
        ..from =
            new mailer.Address('nehadroid23@gmail.com', 'Irrigation Mangement')
        ..recipients.add("$emailReciptant")
        ..subject = 'Band Invitation'
        ..text =
            'You have been invited to be the member of the band($bandName) by $bandAdminName';

      final sendReports = await mailer.send(message, smtpServer);
      print("SD-> " + sendReports.toString());
      return "Success";
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

  Future<dynamic> addUserPlayingStyle(UserPlayingStyle userPlayingStyle) async {
    try {
      for (var i = 0; i < userPlayingStyle.files?.length ?? 0; i++) {
        File file1 = File(userPlayingStyle.files[i]);
        if (await file1.exists()) {
          String basename = extension(file1.path);
          File newFile = File(
              file1.parent.path + "/temp-${await file1.length()}" + basename);
          File file = await compressFileAndGetFile(file1, newFile.path);
          final StorageUploadTask uploadTask = playingstyleRef
              .child("${DateTime.now().toString()}$basename")
              .putFile(file);
          StorageTaskSnapshot snapshot = await uploadTask.onComplete;
          String url = await snapshot.ref.getDownloadURL();
          print("SD-> $url");
          userPlayingStyle.files[i] = url;
        }
      }
      bool isUpdate = true;
      if (userPlayingStyle.id == null || userPlayingStyle.id.isEmpty) {
        String id = playingStyleDB.push().key;
        userPlayingStyle.id = id;
        isUpdate = false;
      }
      await playingStyleDB
          .child(userPlayingStyle.id)
          .set(userPlayingStyle.toMap());
      return isUpdate;
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
      var res = await _auth.sendPasswordResetEmail(email: email);
      return res;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  void logout() async {
    await _auth.signOut();
  }

  void deleteContact(String id) async {
    await contactDB.child(id).remove();
  }

  void deleteInstrument(String id) async {
    await equipmentsDB.child(id).remove();
  }

  void deleteNotes(String id) async {
    await notesDB.child(id).remove();
  }

  void deleteBulletInboard(String id) async {
    await bulletinDB.child(id).remove();
  }

  void deleteActivity(String id) async {
    await activitiesDB.child(id).remove();
  }

  void deletePlayingStyle(String id) async {
    await playingStyleDB.child(id).remove();
  }

  Future<dynamic> internalRegister(User user) async {
    try {
      AuthResult authResult = await _auth.createUserWithEmailAndPassword(
          email: user.email, password: user.password);
      user.id = authResult.user.uid;
      await userDB.child(user.id).set(user.toMap());
      await forgotPassword(user.email);
      return user;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  void deleteBand(String id) async {
    await bandDB.child(id).remove();
  }
}
