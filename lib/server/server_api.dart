import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gigtrack/server/models/band_member.dart';
import 'package:gigtrack/server/models/feedback.dart';
import 'package:gigtrack/server/models/payment.dart';
import 'package:gigtrack/server/models/setlist.dart';
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
import 'package:path/path.dart';
import 'models/band_comm.dart';
import 'models/band_member_add_response.dart';
import 'models/chat.dart';
import 'models/notification_list_response.dart';
import 'models/update_activity_bandmember_status.dart';
import 'models/user_instrument.dart';
import 'package:http/http.dart' as http;

class ServerAPI {
  static final ServerAPI _serverApi = new ServerAPI._internal();

  StorageReference equipmentRef;
  StorageReference receiptRef;
  StorageReference bulletionRef;

  StorageReference contactsRef;

  StorageReference playingstyleRef;
  StorageReference bandref;

  DatabaseReference notesDB,
      bulletinDB,
      setListDB,
      feedDB,
      paymentDB,
      bandCommDB,
      chatDB;

  String adminEmail = "f7oNvNfTqPTuLQAVq6ZaeqllEBx1";

  DatabaseReference _mainFirebaseDatabase;

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
      helpDB,
      notificationDB;
  String currentUserId, currentUserEmail;

  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();

  ServerAPI._internal() {
    _auth = FirebaseAuth.instance;
    StorageReference storageRef = FirebaseStorage.instance.ref();
    equipmentRef = storageRef.child("Equipments");
    receiptRef = storageRef.child("Receipt");
    contactsRef = storageRef.child("Contacts");
    playingstyleRef = storageRef.child("PlayingStyle");
    bandref = storageRef.child("Bands");
    bulletionRef = storageRef.child("Bulletinboard");
    _mainFirebaseDatabase =
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
    helpDB = _mainFirebaseDatabase.child("Helps");
    setListDB = _mainFirebaseDatabase.child("SetList");
    feedDB = _mainFirebaseDatabase.child("Feebacks");
    paymentDB = _mainFirebaseDatabase.child("Payments");
    bandCommDB = _mainFirebaseDatabase.child("BandComm");
    chatDB = _mainFirebaseDatabase.child("Chats");
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
    print("SD-> $message");
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
              if (bandMember.userId == null || bandMember.userId.isEmpty) {
                bandMember.userId = user.id;
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

  Future<dynamic> updateUserProfile(User user) async {
    File file1 = File(user.profilePic);
    if (await file1.exists()) {
      String basename = extension(file1.path);
      File newFile =
          File(file1.parent.path + "/temp-${await file1.length()}" + basename);
      File file = await compressFileAndGetFile(file1, newFile.path);
      final StorageUploadTask uploadTask = contactsRef
          .child("${DateTime.now().toString()}$basename")
          .putFile(file);
      StorageTaskSnapshot snapshot = await uploadTask.onComplete;
      String url = await snapshot.ref.getDownloadURL();
      user.profilePic = url;
    }
    await userDB.child(user.id).set(user.toMap());
    return user;
  }

  String getChatId(String userId1, String userId2) {
    if (userId1.compareTo(userId2) > 0) {
      return "$userId1$userId2";
    }
    return "$userId2$userId1";
  }

  Future<dynamic> addChat(Chat chat) async {
    String id = getChatId(chat.senderId, chat.receiverId);
    String key = helpDB.child(id).push().key;
    chat.id = key;
    await helpDB.child(id).child(key).set(chat.toJSON());
    return "Success";
  }

  Future<dynamic> addBand(Band band) async {
    try {
      for (var i = 0; i < band.files?.length ?? 0; i++) {
        File file1 = File(band.files[i]);
        if (await file1.exists()) {
          String basename = extension(file1.path);
          File newFile = File(
              file1.parent.path + "/temp-${await file1.length()}" + basename);
          File file = await compressFileAndGetFile(file1, newFile.path);
          final StorageUploadTask uploadTask = bandref
              .child("${DateTime.now().toString()}$basename")
              .putFile(file);
          StorageTaskSnapshot snapshot = await uploadTask.onComplete;
          String url = await snapshot.ref.getDownloadURL();
          band.files[i] = url;
        }
      }
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
          contacts.files[i] = url;
        }
      }
      bool isUpdate = true;
      if (contacts.id == null || contacts.id.isEmpty) {
        String id = equipmentsDB.push().key;
        contacts.id = id;
        isUpdate = false;
      }

      if (contacts.bandId != null && contacts.bandId.isNotEmpty) {
        final detail = await getBandDetails(contacts.bandId);
        if (detail is Band) {
          for (var mem in detail.bandmates.keys) {
            BandMember member = detail.bandmates[mem];
            if (member.userId != null && member.userId.isNotEmpty) {
              final res = await addNotification(AppNotification(
                bandId: contacts.bandId,
                created: DateTime.now().millisecondsSinceEpoch,
                notiId: contacts.id,
                text: "A new Contact created in the band.",
                type: AppNotification.TYPE_CONTACT,
                userId: member.userId,
                senderId: currentUserId,
              ));
              if (res is AppNotification) {
                sendPushNotification(res);
              }
            }
          }
          if (detail.userId != null && detail.userId.isNotEmpty) {
            final res = await addNotification(AppNotification(
              bandId: contacts.bandId,
              created: DateTime.now().millisecondsSinceEpoch,
              notiId: contacts.id,
              text: "A new Contact created in the band.",
              type: AppNotification.TYPE_CONTACT,
              userId: detail.userId,
              senderId: currentUserId,
            ));
            if (res is AppNotification) {
              sendPushNotification(res);
            }
          }
        }
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

  Future<dynamic> addNotification(AppNotification notification) async {
    try {
      bool isUpdate = true;
      if (notification.id == null || notification.id.isEmpty) {
        String id = notificationDB.push().key;
        notification.id = id;
        isUpdate = false;
      }
      await notificationDB.child(notification.id).set(notification.toMap());
      return notification;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addPayment(Payment payment) async {
    try {
      bool isUpdate = true;
      if (payment.id == null || payment.id.isEmpty) {
        String id = paymentDB.push().key;
        payment.id = id;
        isUpdate = false;
      }

      if (payment.image != null) {
        File file1 = File(payment.image);
        if (await file1.exists()) {
          String basename = extension(file1.path);
          File newFile = File(
              file1.parent.path + "/temp-${await file1.length()}" + basename);
          File file = await compressFileAndGetFile(file1, newFile.path);
          final StorageUploadTask uploadTask = equipmentRef
              .child("${DateTime.now().toString()}$basename")
              .putFile(file ?? file1);
          StorageTaskSnapshot snapshot = await uploadTask.onComplete;
          String url = await snapshot.ref.getDownloadURL();
          payment.image = url;
        }
      }

      await paymentDB.child(payment.id).set(payment.toMap());
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

  Future<dynamic> getSetListItemDetails(String id) async {
    try {
      DataSnapshot dataSnapshot = await setListDB.child(id).once();
      SetList userPlayingStyle = SetList.fromJSON(dataSnapshot.value);
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

      if (notesTodo.bandId != null && notesTodo.bandId.isNotEmpty) {
        final detail = await getBandDetails(notesTodo.bandId);
        if (detail is Band) {
          for (var mem in detail.bandmates.keys) {
            BandMember member = detail.bandmates[mem];
            if (member.userId != null && member.userId.isNotEmpty) {
              final res = await addNotification(AppNotification(
                bandId: notesTodo.bandId,
                created: DateTime.now().millisecondsSinceEpoch,
                notiId: notesTodo.id,
                text: "A new Note/Todo created in the band.",
                type: AppNotification.TYPE_NOTES,
                userId: member.userId,
                senderId: currentUserId,
              ));
              if (res is AppNotification) {
                sendPushNotification(res);
              }
            }
          }
          if (detail.userId != null && detail.userId.isNotEmpty) {
            final res = await addNotification(AppNotification(
              bandId: notesTodo.bandId,
              created: DateTime.now().millisecondsSinceEpoch,
              notiId: notesTodo.id,
              text: "A new Note/Todo created in the band.",
              type: AppNotification.TYPE_NOTES,
              userId: detail.userId,
              senderId: currentUserId,
            ));
            if (res is AppNotification) {
              sendPushNotification(res);
            }
          }
        }
      }

      await notesDB.child(notesTodo.id).set(notesTodo.toMap());
      return isUpdate;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addBulletInBoard(BulletInBoard bulletinboard) async {
    try {
      if (bulletinboard.uploadedFiles.length > 0) {
        for (var i = 0; i < bulletinboard.uploadedFiles.length; i++) {
          File file1 = File(bulletinboard.uploadedFiles[i]);

          if (await file1.exists()) {
            String basename = extension(file1.path);
            File newFile = File(
                file1.parent.path + "/temp-${await file1.length()}" + basename);
            File file = await compressFileAndGetFile(file1, newFile.path);
            final StorageUploadTask uploadTask = bulletionRef
                .child("${DateTime.now().toString()}$basename")
                .putFile(file);
            StorageTaskSnapshot snapshot = await uploadTask.onComplete;
            String url = await snapshot.ref.getDownloadURL();
            bulletinboard.uploadedFiles[i] = url;
          }
        }
      }
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

  Future<dynamic> addBandComm(BandCommunication bandComm) async {
    try {
      bool isUpdate = true;
      if (bandComm.id == null || bandComm.id.isEmpty) {
        String id = bandCommDB.push().key;
        bandComm.id = id;
        isUpdate = false;
      }
      if (bandComm.bandId != null && bandComm.bandId.isNotEmpty) {
        final detail = await getBandDetails(bandComm.bandId);
        if (detail is Band) {
          for (var mem in detail.bandmates.keys) {
            BandMember member = detail.bandmates[mem];
            if (member.userId != null && member.userId.isNotEmpty) {
              final res = await addNotification(AppNotification(
                bandId: bandComm.bandId,
                created: DateTime.now().millisecondsSinceEpoch,
                notiId: bandComm.id,
                text:
                    "A new Band Communication was created in the band.",
                type: AppNotification.TYPE_BAND_COMM,
                userId: member.userId,
                senderId: currentUserId,
              ));
              if (res is AppNotification) {
                sendPushNotification(res);
              }
            }
          }
          if (detail.userId != null && detail.userId.isNotEmpty) {
            final res = await addNotification(AppNotification(
              bandId: bandComm.bandId,
              created: DateTime.now().millisecondsSinceEpoch,
              notiId: bandComm.id,
              text:
                  "A new Band Communication created in the band.",
              type: AppNotification.TYPE_BAND_COMM,
              userId: detail.userId,
              senderId: currentUserId,
            ));
            if (res is AppNotification) {
              sendPushNotification(res);
            }
          }
        }
      }
      await bandCommDB.child(bandComm.id).set(bandComm.toMap());
      return isUpdate;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addSetList(SetList setlist) async {
    try {
      bool isUpdate = true;
      if (setlist.id == null || setlist.id.isEmpty) {
        String id = setListDB.push().key;
        setlist.id = id;
        isUpdate = false;
      }
      await setListDB.child(setlist.id).set(setlist.toMap());

      if (setlist.bandId != null && setlist.bandId.isNotEmpty) {
        final detail = await getBandDetails(setlist.bandId);
        if (detail is Band) {
          for (var mem in detail.bandmates.keys) {
            BandMember member = detail.bandmates[mem];
            if (member.userId != null && member.userId.isNotEmpty) {
              final res = await addNotification(AppNotification(
                bandId: setlist.bandId,
                created: DateTime.now().millisecondsSinceEpoch,
                notiId: setlist.id,
                text: "A new Set-List added to band.",
                type: AppNotification.TYPE_SET_LIST,
                userId: member.userId,
                senderId: currentUserId,
              ));
              if (res is AppNotification) {
                sendPushNotification(res);
              }
            }
          }
        }
      }

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
      if (activities.bandId != null &&
          activities.bandId.isNotEmpty &&
          !isUpdate) {
        final detail = await getBandDetails(activities.bandId);
        if (detail is Band) {
          for (var mem in detail.bandmates.keys) {
            BandMember member = detail.bandmates[mem];
            if (member.userId != null && member.userId.isNotEmpty) {
              final res = await addNotification(AppNotification(
                bandId: activities.bandId,
                created: DateTime.now().millisecondsSinceEpoch,
                notiId: activities.id,
                text:
                    "A new ${activities.type == Activites.TYPE_ACTIVITY ? 'Activity' : activities.type == Activites.TYPE_BAND_TASK ? 'Band Task' : activities.type == Activites.TYPE_PERFORMANCE_SCHEDULE ? 'Performance Schedule' : activities.type == Activites.TYPE_PRACTICE_SCHEDULE ? 'Practice Schedule' : activities.type == Activites.TYPE_TASK ? 'Task' : ''} was created in the band.",
                type: AppNotification.TYPE_ACTIVITY,
                userId: member.userId,
                senderId: currentUserId,
              ));
              if (res is AppNotification) {
                sendPushNotification(res);
              }
            }
          }
          if (detail.userId != null && detail.userId.isNotEmpty) {
            final res = await addNotification(AppNotification(
              bandId: activities.bandId,
              created: DateTime.now().millisecondsSinceEpoch,
              notiId: activities.id,
              text:
                  "A new ${activities.type == Activites.TYPE_ACTIVITY ? 'Activity' : activities.type == Activites.TYPE_BAND_TASK ? 'Band Task' : activities.type == Activites.TYPE_PERFORMANCE_SCHEDULE ? 'Performance Schedule' : activities.type == Activites.TYPE_PRACTICE_SCHEDULE ? 'Practice Schedule' : activities.type == Activites.TYPE_TASK ? 'Task' : ''} created in the band.",
              type: AppNotification.TYPE_ACTIVITY,
              userId: detail.userId,
              senderId: currentUserId,
            ));
            if (res is AppNotification) {
              sendPushNotification(res);
            }
          }
        }
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
      if (instrument.receiptFiles.length > 0) {
        for (var i = 0; i < instrument.receiptFiles.length; i++) {
          File file1 = File(instrument.receiptFiles[i]);

          if (await file1.exists()) {
            String basename = extension(file1.path);
            File newFile = File(
                file1.parent.path + "/temp-${await file1.length()}" + basename);
            File file = await compressFileAndGetFile(file1, newFile.path);
            final StorageUploadTask uploadTask = receiptRef
                .child("${DateTime.now().toString()}$basename")
                .putFile(file);
            StorageTaskSnapshot snapshot = await uploadTask.onComplete;
            String url = await snapshot.ref.getDownloadURL();
            instrument.receiptFiles[i] = url;
          }
        }
      }
      bool isUpdate = true;
      if (instrument.id == null || instrument.id.isEmpty) {
        String id = equipmentsDB.push().key;
        instrument.id = id;
        isUpdate = false;
      }

      if (instrument.bandId != null && instrument.bandId.isNotEmpty) {
        final detail = await getBandDetails(instrument.bandId);
        if (detail is Band) {
          for (var mem in detail.bandmates.keys) {
            BandMember member = detail.bandmates[mem];
            if (member.userId != null && member.userId.isNotEmpty) {
              final res = await addNotification(AppNotification(
                bandId: instrument.bandId,
                created: DateTime.now().millisecondsSinceEpoch,
                notiId: instrument.id,
                text: "A new Instrument created in the band.",
                type: AppNotification.TYPE_INSTRUMENT,
                userId: member.userId,
                senderId: currentUserId,
              ));
              if (res is AppNotification) {
                sendPushNotification(res);
              }
            }
          }
          if (detail.userId != null && detail.userId.isNotEmpty) {
            final res = await addNotification(AppNotification(
              bandId: instrument.bandId,
              created: DateTime.now().millisecondsSinceEpoch,
              notiId: instrument.id,
              text: "A new Instrument created in the band.",
              type: AppNotification.TYPE_INSTRUMENT,
              userId: detail.userId,
              senderId: currentUserId,
            ));
            if (res is AppNotification) {
              sendPushNotification(res);
            }
          }
        }
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

  Future<dynamic> getBandCommDetails(String id) async {
    try {
      DataSnapshot dataSnapshot = await bandCommDB.child(id).once();
      return BandCommunication.fromJSON(dataSnapshot.value);
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

  Future<dynamic> getPaymentDetails(String id) async {
    try {
      DataSnapshot dataSnapshot = await paymentDB.child(id).once();
      return Payment.fromJSON(dataSnapshot.value);
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

  Future<dynamic> searchUserByEmail(String email) async {
    try {
      final res = await userDB.once();
      Map mp = res.value;
      List<User> acc = [];
      if (mp == null) return acc;
      for (var d in mp.values) {
        User user = User.fromJSON(d);
        if (user.email.contains(email)) {
          return user;
        }
      }
      return ErrorResponse.fromJSON("No User Found");
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> sendEmail(
      String bandName, String bandAdminName, String emailReciptant) async {
    try {
//      SmtpServer smtpServer = gmail("gigtrack2@gmail.com", "12345Six**");
//
//      final message = new mailer.Message()
//        ..from =
//            new mailer.Address('nehadroid23@gmail.com', 'Irrigation Mangement')
//        ..recipients.add("$emailReciptant")
//        ..subject = 'Band Invitation'
//        ..text =
//            'You have been invited to be the member of the band($bandName) by $bandAdminName';
//
//      final sendReports = await mailer.send(message, smtpServer);
//      print("SD-> " + sendReports.toString());
//      return "Success";
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
          userPlayingStyle.files[i] = url;
        }
      }
      bool isUpdate = true;
      if (userPlayingStyle.id == null || userPlayingStyle.id.isEmpty) {
        String id = playingStyleDB.push().key;
        userPlayingStyle.id = id;
        isUpdate = false;
      }

      if (userPlayingStyle.bandId != null &&
          userPlayingStyle.bandId.isNotEmpty) {
        final detail = await getBandDetails(userPlayingStyle.bandId);
        if (detail is Band) {
          for (var mem in detail.bandmates.keys) {
            BandMember member = detail.bandmates[mem];
            if (member.userId != null && member.userId.isNotEmpty) {
              final res = await addNotification(AppNotification(
                bandId: userPlayingStyle.bandId,
                created: DateTime.now().millisecondsSinceEpoch,
                notiId: userPlayingStyle.id,
                text: "A new EPK created in the band.",
                type: AppNotification.TYPE_EPK,
                userId: member.userId,
                senderId: currentUserId,
              ));
              if (res is AppNotification) {
                sendPushNotification(res);
              }
            }
          }
          if (detail.userId != null && detail.userId.isNotEmpty) {
            final res = await addNotification(AppNotification(
              bandId: userPlayingStyle.bandId,
              created: DateTime.now().millisecondsSinceEpoch,
              notiId: userPlayingStyle.id,
              text: "A new EPK created in the band.",
              type: AppNotification.TYPE_EPK,
              userId: detail.userId,
              senderId: currentUserId,
            ));
            if (res is AppNotification) {
              sendPushNotification(res);
            }
          }
        }
      }

      await playingStyleDB
          .child(userPlayingStyle.id)
          .set(userPlayingStyle.toMap());
      return isUpdate;
    } catch (e) {
      return ErrorResponse.fromJSON(e);
    }
  }

  Map<String, User> usersMap = {};

  Future<dynamic> getSingleUserById(String id) async {
    try {
      if (usersMap.containsKey(id)) {
        return usersMap[id];
      }
      DataSnapshot dataSnapshot = await userDB.child(id).once();
      final user = User.fromJSON(dataSnapshot.value);
      usersMap[id] = user;
      return user;
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
    currentUserId = null;
    currentUserEmail = null;
  }

  Future<dynamic> getWelcome() async {
    DataSnapshot dataSnapshot =
        await _mainFirebaseDatabase.child('welcome').once();
    return dataSnapshot.value as bool;
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

  void deleteBandComm(String id) async {
    await bandCommDB.child(id).remove();
  }

  void deletePayment(String id) async {
    await paymentDB.child(id).remove();
  }

  void deleteActivity(String id) async {
    await activitiesDB.child(id).remove();
  }

  void deletePlayingStyle(String id) async {
    await playingStyleDB.child(id).remove();
  }

  void deleteSetList(String id) async {
    await setListDB.child(id).remove();
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

  void sendPushNotification(AppNotification notification) async {
    Map<String, String> header = {
      HttpHeaders.contentTypeHeader: "application/json",
      "Authorization":
          "key=AAAAb5VdN_k:APA91bEYcKIabKkmhDwfUb2QxCCTfDlT7AHfKWCbL2uUfm4GZaP7Rj3UikHyLcj5sM0A2dFQTLxENfbe8yT6JNOccE25TgtQLj1SJwYFFPUqGcL9FAdEiVwJPoYGZb5KW4Ev5zRcDEa9"
    };
    final body = jsonEncode({
      "notification": {"body": notification.text, "title": "GigTrack"},
      "priority": "high",
      "data": {
        "click_action": "FLUTTER_NOTIFICATION_CLICK",
        "id": "1",
        "status": "done",
        "app_data": notification.toMap(),
      },
      "to": "/topics/${notification.userId}"
    });
    final res = await http.post(
      'https://fcm.googleapis.com/fcm/send',
      headers: header,
      body: body,
    );
    print("RES-> $res");
  }

  deleteBandMember(String bandId, String id) async {
    await bandDB.child(bandId).child('bandmates').child(id).remove();
  }

  Future<dynamic> addFeedback(UserFeedback feedback) async {
    try {
      bool isUpdate = true;
      if (feedback.id == null || feedback.id.isEmpty) {
        String id = feedDB.push().key;
        feedback.id = id;
        isUpdate = false;
      }
      await feedDB.child(feedback.id).set(feedback.toMap());
      return isUpdate;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }

  Future<dynamic> addChat2(String chatId, Chat chat) async {
    try {
      bool isUpdate = true;
      if (chat.id == null || chat.id.isEmpty) {
        String id = chatDB.child(chatId).push().key;
        chat.id = id;
        isUpdate = false;
      }
      await chatDB.child(chatId).child(chat.id).set(chat.toJSON());
      sendPushNotification(AppNotification(
        created: DateTime.now().millisecondsSinceEpoch,
        senderId: currentUserId,
        notiId: chatId,
        text: "A new message is send in BulletIn Board",
        type: AppNotification.TYPE_BULLETIN_BOARD_MSG,
        userId: chat.receiverId,
      ));
      return isUpdate;
    } catch (e) {
      return ErrorResponse.fromJSON(e.message);
    }
  }
}
