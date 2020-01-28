import 'package:flutter/material.dart';
import 'package:gigtrack/base/base_screen.dart';
import 'package:gigtrack/main.dart';
import 'package:gigtrack/server/models/chat.dart';
import 'package:gigtrack/ui/help/help_presenter.dart';
import 'package:date_format/date_format.dart';

class HelpScreen extends BaseScreen {
  HelpScreen(AppListener appListener) : super(appListener, title: "Support");

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends BaseScreenState<HelpScreen, HelpPresenter> {
  List<Chat> chatList = [];
  String userId;
  Stream<List<Chat>> stream;
  final _txtController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    stream = presenter.chatStream(userId);
  }

  @override
  AppBar get appBar => AppBar(
    brightness: Brightness.light,
    backgroundColor: Color.fromRGBO(255, 215, 0, 1.0),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            if (userId != null)
              setState(() {
                userId = null;
                chatList.clear();
                stream = presenter.chatStream(userId);
              });
            else
              Navigator.of(context).pop();
          },
        ),
        title: Text("${widget.title}"),
      );

  @override
  Widget buildBody() {
    return Column(
      children: <Widget>[
        Expanded(
          child: StreamBuilder(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                chatList = snapshot.data;
              }
              if (presenter.serverAPI.currentUserId ==
                      "RsaG5sb6zWhvUV0EzK7HDXt7LP22" &&
                  userId == null) {
                return ListView.separated(
                  itemCount: chatList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Chat chat = chatList[index];
                    print("SD--> ${chat.senderId}  ${chat.receiverId}");
                    return ListTile(
                      title: Text(
                          chat.senderId != "RsaG5sb6zWhvUV0EzK7HDXt7LP22"
                              ? (chat.sender?.firstName ?? "No Name")
                              : (chat.receiver?.firstName ?? "No Name")),
                      subtitle: Text(chat.message),
                      onTap: () {
                        setState(() {
                          userId =
                              chat.senderId == "RsaG5sb6zWhvUV0EzK7HDXt7LP22"
                                  ? chat.receiverId
                                  : chat.senderId;
                          chatList.clear();
                          stream = presenter.chatStream(userId);
                        });
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider();
                  },
                );
              } else {
                return ListView.builder(
                  itemCount: chatList.length,
                  padding: EdgeInsets.all(8),
                  itemBuilder: (BuildContext context, int index) {
                    Chat chat = chatList[index];
                    return Bubble(
                      delivered: false,
                      isMe: chat.senderId != presenter.serverAPI.currentUserId,
                      message: chat.message,
                      time: formatDate(
                          DateTime.fromMillisecondsSinceEpoch(chat.created),
                          [hh, ':', nn, ' ', am]),
                    );
                  },
                );
              }
            },
          ),
        ),
        (presenter.serverAPI.currentUserId == "RsaG5sb6zWhvUV0EzK7HDXt7LP22" &&
                    userId != null) ||
                (presenter.serverAPI.currentUserId !=
                    "RsaG5sb6zWhvUV0EzK7HDXt7LP22")
            ? Padding(
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: _txtController,
                        decoration: InputDecoration.collapsed(
                            hintText: "Enter question here"),
                      ),
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.send),
                      onPressed: () async {
                        if (_txtController.text.isNotEmpty) {
                          await presenter.serverAPI.addChat(Chat(
                            created: DateTime.now().millisecondsSinceEpoch,
                            message: _txtController.text,
                            senderId: presenter.serverAPI.currentUserId,
                            receiverId: presenter.serverAPI.currentUserId ==
                                    "RsaG5sb6zWhvUV0EzK7HDXt7LP22"
                                ? userId
                                : "RsaG5sb6zWhvUV0EzK7HDXt7LP22",
                          ));
                        }
                        _txtController.clear();
                      },
                    )
                  ],
                ),
                padding: EdgeInsets.all(5),
              )
            : Container()
      ],
    );
  }

  @override
  HelpPresenter get presenter => HelpPresenter(this);
}

class Bubble extends StatelessWidget {
  Bubble({this.message, this.time, this.delivered = false, this.isMe});

  final String message, time;
  final delivered, isMe;

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? Colors.white : Colors.blueAccent.shade100;
    final align = isMe ? CrossAxisAlignment.start : CrossAxisAlignment.end;
    final icon = delivered ? Icons.done_all : Icons.done;
    final radius = isMe
        ? BorderRadius.only(
            topRight: Radius.circular(5.0),
            bottomLeft: Radius.circular(10.0),
            bottomRight: Radius.circular(5.0),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(5.0),
            bottomLeft: Radius.circular(5.0),
            bottomRight: Radius.circular(10.0),
          );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: bg,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: !isMe ? 65.0 : 55),
                child: Text(message),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text(time,
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 10.0,
                        )),
                    SizedBox(width: 3.0),
                    !isMe
                        ? Icon(
                            icon,
                            size: 12.0,
                            color: Colors.black38,
                          )
                        : Container()
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
