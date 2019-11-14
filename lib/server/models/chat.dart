import 'package:gigtrack/server/models/user.dart';

class Chat {
 String id;
  String senderId;
  String receiverId;
  int created;
  String message;

  User sender;
  User receiver;

  Chat({this.created, this.id, this.message, this.senderId, this.receiverId});

  Chat.fromJSON(dynamic data) {
    id = data['id'];
    senderId = data['senderId'];
    receiverId = data['receiverId'];
    created = data['created'];
    message = data['message'];
  }

  Map<String, dynamic> toJSON() {
    Map<String, dynamic> data = Map();
    data['id'] = id;
    data['senderId'] = senderId;
    data['receiverId'] = receiverId;
    data['created'] = created;
    data['message'] = message;
    return data;
  }
}
