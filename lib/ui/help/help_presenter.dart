import 'package:gigtrack/base/base_presenter.dart';
import 'package:gigtrack/server/models/chat.dart';

class HelpPresenter extends BasePresenter {
  HelpPresenter(BaseContract view) : super(view);

  String chatId;

  Stream<List<Chat>> chatStream(String userId) {
    if (serverAPI.currentUserId != "RsaG5sb6zWhvUV0EzK7HDXt7LP22")
      chatId = serverAPI.getChatId(
          serverAPI.currentUserId, "RsaG5sb6zWhvUV0EzK7HDXt7LP22");
    else if (userId != null)
      chatId = serverAPI.getChatId(userId, serverAPI.currentUserId);

    if (chatId != null)
      return serverAPI.helpDB.child(chatId).onValue.map((m) {
        Map mp = m.snapshot.value;
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
    else
      return serverAPI.helpDB.onValue.asyncMap((m) async {
        print("SD-> $m");
        Map mp = m.snapshot.value;
        if (mp == null) return null;
        List<Chat> acc = [];
        for (var item in mp.values) {
          Map map = item;
          int time;
          Chat lastChat;
          final chatList = <Chat>[];
          for (var item2 in map.values) {
            Chat chat = Chat.fromJSON(item2);
            chatList.add(chat);
          }
          chatList.sort((a, b) {
            return a.created.compareTo(b.created);
          });
          if (chatList.length > 0) lastChat = chatList[chatList.length - 1];
          if (lastChat != null) {
            lastChat.sender =
                await serverAPI.getSingleUserById(lastChat.senderId);
            lastChat.receiver =
                await serverAPI.getSingleUserById(lastChat.receiverId);
            acc.add(lastChat);
          }
        }
        return acc;
      });
  }
}
