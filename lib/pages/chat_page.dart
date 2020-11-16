import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/messages_response.dart';

import '../services/auth_service.dart';
import '../services/chat_service.dart';
import '../services/socket_service.dart';

import '../widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  ChatService chatService;
  SocketService socketService;
  AuthService authService;

  List<ChatMessage> _messages = [];

  bool _userIsWriting = false;

  @override
  void initState() {
    super.initState();
    this.chatService = Provider.of<ChatService>(context, listen: false);
    this.socketService = Provider.of<SocketService>(context, listen: false);
    this.authService = Provider.of<AuthService>(context, listen: false);

    this.socketService.socket.on('privat-message', _listenToMessage);

    _loadHistory(this.chatService.addressee.userId);
  }

  void _loadHistory(String userId) async {
    List<Message> chat = await this.chatService.getChat(userId);

    final history = chat.map((m) => new ChatMessage(
          text: m.message,
          userId: m.from,
          animationController: new AnimationController(
            vsync: this,
            duration: Duration(milliseconds: 0),
          )..forward(),
        ));

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenToMessage(dynamic payload) {
    ChatMessage message = new ChatMessage(
      text: payload['message'],
      userId: payload['from'],
      animationController: AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final addressee = this.chatService.addressee;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).backgroundColor,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(
                addressee.name.substring(0, 2),
                style: TextStyle(fontSize: 12),
              ),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              addressee.name,
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: (_, index) => _messages[index],
                reverse: true,
              ),
            ),
            Divider(
              height: 1,
            ),
            Container(
              color: Theme.of(context).backgroundColor,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (text) {
                  setState(() {
                    if (text.trim().length > 0) {
                      _userIsWriting = true;
                    } else {
                      _userIsWriting = false;
                    }
                  });
                },
                decoration: InputDecoration.collapsed(hintText: 'Send message'),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      child: Text('Send'),
                      onPressed: _userIsWriting
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data:
                            IconThemeData(color: Theme.of(context).buttonColor),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: Icon(Icons.send),
                          onPressed: _userIsWriting
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                        ),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.length == 0) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      userId: authService.user.userId,
      text: text,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 200)),
    );

    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _userIsWriting = false;
    });

    this.socketService.emit('privat-message', {
      'from': this.authService.user.userId,
      'to': this.chatService.addressee.userId,
      'message': text,
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }

    this.socketService.socket.off('privat-message');
    super.dispose();
  }
}
