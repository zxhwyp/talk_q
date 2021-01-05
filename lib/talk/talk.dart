import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class Talk extends StatefulWidget {
  final String name;
  final Uint8List image;
  Talk({this.name, this.image});
  @override
  _TalkState createState() => _TalkState();
}

class _TalkState extends State<Talk> {
  ScrollController _controller;
  TextEditingController _editingController;
  FocusNode _focusNode = FocusNode();
  int testIndex = 0;
  MediaQueryData get media => MediaQuery.of(context);
  var _ims = List<IMModle>();

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _editingController = TextEditingController();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        Future.delayed(Duration(milliseconds: 100), () {
          _controller.animateTo(_controller.position.maxScrollExtent,
              duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
        });
      }
    });
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _controller.animateTo(_controller.position.maxScrollExtent,
          duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(
        title: Text(widget.name),
        elevation: 0,
        backgroundColor: kPrimaryColorLight,
        automaticallyImplyLeading: true,
      ),
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus();
        },
        child: Container(
          child: Column(
            children: <Widget>[buildMessageList(), buildInputArea()],
          ),
        ),
      ),
    );
  }

  Widget buildInputArea() {
    return Container(
        height: 58,
        color: Colors.white,
        padding: EdgeInsets.only(left: 17, right: 17),
        child: Container(
          margin: EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(7)),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: TextField(
            maxLines: 1,
            controller: _editingController,
            focusNode: _focusNode,
            textInputAction: TextInputAction.send,
            cursorColor: kPrimaryColorLight,
            decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 15, color: Color(0xFF656565)),
                hintText: '发消息'),
            onSubmitted: (text) {
              if (text == null || text.trim().length == 0) {
                _focusNode.requestFocus();
                return;
              }
              _editingController.text = '';
              setState(() {
                if (text.trim().length > 0) {
                  _ims.add(IMModle(
                      content: text.trim(), isSelf: testIndex % 2 == 0));
                  testIndex++;
                }
              });
              scrollToBottom();
              _focusNode.requestFocus();
            },
          ),
        ));
  }

  Widget buildMessageList() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: ListView.builder(
          shrinkWrap: true,
          controller: _controller,
          itemCount: _ims.length,
          itemBuilder: (BuildContext context, int index) {
            return messageItem(_ims[index]);
          },
        ),
      ),
    );
  }

  Widget messageItem(IMModle im) {
    return im.isSelf ? selfMessageItem(im) : otherMessageItem(im);
  }

  Widget otherMessageItem(IMModle im) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipOval(
            child: Image.memory(
              widget.image,
              width: 50,
              height: 50,
              fit: BoxFit.fill,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.name),
              Align(
                alignment: Alignment.center,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                  constraints: BoxConstraints(
                      minHeight: 25,
                      minWidth: 50,
                      maxWidth: media.size.width * 2 / 3 - 30),
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    im.content ?? '',
                    maxLines: null,
                    style: TextStyle(fontSize: 13, color: textBlack),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget selfMessageItem(IMModle im) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                  margin: EdgeInsets.only(top: 5),
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 8, bottom: 8),
                  constraints: BoxConstraints(
                    maxWidth: media.size.width * 2 / 3 - 30,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    im.content ?? '',
                    maxLines: null,
                    style: TextStyle(fontSize: 13, color: textBlack),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              ClipOval(
                child: Image.network(
                  'https://img.iplaysoft.com/wp-content/uploads/2019/free-images/free_stock_photo.jpg',
                  width: 50,
                  height: 50,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class IMModle {
  IMModle({this.content, this.isSelf});
  final String content;
  final bool isSelf;
}
