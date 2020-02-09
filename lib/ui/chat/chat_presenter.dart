import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/chat.dart';

class ChatPresenter extends BasePresenter {
  ChatPresenter(BaseContract view) : super(view);

  Stream<List<Chat>> getLastChat(String chatId) {
    return serverAPI.chatDB.child(chatId).onValue.asyncMap((a) async {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      Map<String, Chat> acc = {};
      for (var d in mp.values) {
        Chat chat = Chat.fromJSON(d);
        String id = chat.senderId == serverAPI.currentUserId
            ? chat.receiverId
            : chat.senderId;
        if (acc.containsKey(id)) {
          Chat chat1 = acc[id];
          if (chat.created > chat1.created) {
            if (id == chat.senderId)
              chat.sender = await serverAPI.getSingleUserById(chat.senderId);
            else
              chat.receiver =
                  await serverAPI.getSingleUserById(chat.receiverId);
            acc[id] = chat;
          }
        } else {
          if (id == chat.senderId)
            chat.sender = await serverAPI.getSingleUserById(chat.senderId);
          else
            chat.receiver = await serverAPI.getSingleUserById(chat.receiverId);
          acc[id] = chat;
        }
      }
      List<Chat> chatList = List.from(acc.values);
      chatList.sort((a, b) {
        return a.created.compareTo(b.created);
      });
      return chatList;
    });
  }

  Stream<List<Chat>> getChat(String chatId) {
    return serverAPI.chatDB.child(chatId).onValue.map((a) {
      Map mp = a.snapshot.value;
      if (mp == null) return null;
      List<Chat> acc = [];
      for (var d in mp.values) {
        Chat chat = Chat.fromJSON(d);
        acc.add(chat);
      }
      acc.sort((a, b) {
        return a.created.compareTo(b.created);
      });
      return acc;
    });
  }
}
