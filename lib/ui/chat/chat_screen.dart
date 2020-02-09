import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/chat.dart';
import 'package:gigtrack/server/models/user.dart';
import 'package:gigtrack/ui/chat/chat_presenter.dart';
import 'package:gigtrack/utils/common_app_utils.dart';

class ChatScreen extends BaseScreen {
  final String userId;
  final String chatId;
  ChatScreen(AppListener appListener, {this.userId, this.chatId})
      : super(appListener, title: "Chat");

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends BaseScreenState<ChatScreen, ChatPresenter> {
  List<Chat> _chats = [];
  Stream<List<Chat>> _stream;
  final _txtController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.userId == presenter.serverAPI.currentUserId) {
      _stream = presenter.getLastChat(widget.chatId);
    } else {
      _stream = presenter.getChat(widget.chatId);
    }
  }

  @override
  Widget buildBody() {
    return StreamBuilder<List<Chat>>(
      stream: _stream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          _chats = snapshot.data;
        }
        return Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _chats.length,
                padding: EdgeInsets.all(10),
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  Chat chat = _chats[index];
                  if (widget.userId == presenter.serverAPI.currentUserId) {
                    User user = chat.sender ?? chat.receiver;
                    return ListTile(
                      onTap: () {
                        widget.appListener.router.navigateTo(
                            context,
                            Screens.CHAT.toString() +
                                "/${user.id}/${widget.chatId}");
                      },
                      title: Text("${user?.firstName} ${user?.lastName}"),
                      subtitle: Text("${chat.message}\n${formatDate(DateTime.fromMillisecondsSinceEpoch(chat.created),[hh, ':', nn, ' ', am])}"),
                    );
                  } else {
                    return Bubble(
                      delivered: false,
                      isMe: chat.senderId != presenter.serverAPI.currentUserId,
                      message: chat.message,
                      time: formatDate(
                          DateTime.fromMillisecondsSinceEpoch(chat.created),
                          [hh, ':', nn, ' ', am]),
                    );
                  }
                },
              ),
            ),
            widget.userId != presenter.serverAPI.currentUserId
                ? Padding(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            controller: _txtController,
                            decoration: InputDecoration.collapsed(
                                hintText: "Enter Chat here"),
                          ),
                        ),
                        FloatingActionButton(
                          child: Icon(Icons.send),
                          onPressed: () async {
                            if (_txtController.text.isNotEmpty) {
                              await presenter.serverAPI.addChat2(
                                widget.chatId,
                                Chat(
                                  created:
                                      DateTime.now().millisecondsSinceEpoch,
                                  message: _txtController.text,
                                  receiverId: widget.userId,
                                  senderId: presenter.serverAPI.currentUserId,
                                ),
                              );
                            }
                            _txtController.clear();
                            _scrollController.jumpTo(
                                _scrollController.position.maxScrollExtent);
                          },
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(5),
                  )
                : Container()
          ],
        );
      },
    );
  }

  @override
  ChatPresenter get presenter => ChatPresenter(this);
}
