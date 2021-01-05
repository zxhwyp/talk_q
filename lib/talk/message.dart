import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:talk_q/talk/talk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toast/toast.dart';
import '../constants.dart';

class Message extends StatefulWidget {
  Message({Key key}) : super(key: key);

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _requestPermission();
    });
  }

  final datas = [
    {
      'image':
          'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2241532309,965180071&fm=26&gp=0.jpg',
      'name': '阿露',
      'content': '去上课么',
      'read': false,
      'net': true,
    },
    {
      'image':
          'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2114611637,2615047297&fm=26&gp=0.jpg',
      'name': '贝贝',
      'content': '下课吃什么',
      'net': true,
      'read': false
    },
    {
      'image':
          'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=2853553659,1775735885&fm=26&gp=0.jpg',
      'name': '娜娜',
      'content': '你今天迟到了么',
      'net': true,
      'read': false
    },
    {
      'image':
          'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=360400461,2955275651&fm=26&gp=0.jpg',
      'name': '周周',
      'content': '人呢',
      'net': true,
      'read': false
    },
    {
      'image':
          'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=2606549919,3922038670&fm=26&gp=0.jpg',
      'name': '玲玲',
      'content': '在不',
      'net': true,
      'read': false
    }
  ];

  _requestPermission() async {
    await [
      Permission.storage,
    ].request();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kPrimaryColorLight,
        title: Text('消息'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return item(index);
          },
          itemCount: datas.length,
        ),
      ),
    );
  }

  Widget item(int index) {
    Map item = datas[index];
    return GestureDetector(
      onTap: () async {
        item['read'] = true;
        Uint8List imageBytes;
        if (item['net'] == true) {
          var response = await Dio().get(item['image'],
              options: Options(responseType: ResponseType.bytes));
          imageBytes = Uint8List.fromList(response.data);
        } else {
          imageBytes = File.fromUri(Uri.file(item['image'])).readAsBytesSync();
        }
        Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (ctx) => Talk(
                      name: item['name'],
                      image: imageBytes,
                    )))
            .then((value) {
          setState(() {});
        });
      },
      child: Container(
        height: 65,
        margin: EdgeInsets.only(bottom: 1.0),
        padding: EdgeInsets.symmetric(horizontal: 17),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.2)))),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: const Text('上传头像',
                                  style: TextStyle(
                                      color: Color(0xFF167EFB),
                                      fontSize: 18,
                                      fontFamily: 'PingFangMedium')),
                              onPressed: () async {
                                var value = await ImagePicker()
                                    .getImage(source: ImageSource.gallery);
                                item['image'] = value.path;
                                item['net'] = false;
                                setState(() {});
                                Navigator.of(context).pop();
                              },
                            ),
                            CupertinoActionSheetAction(
                              child: const Text('保存头像',
                                  style: TextStyle(
                                      color: Color(0xFF167EFB),
                                      fontSize: 18,
                                      fontFamily: 'PingFangMedium')),
                              onPressed: () async {
                                Uint8List imageBytes;
                                if (item['net'] == true) {
                                  var response = await Dio().get(item['image'],
                                      options: Options(
                                          responseType: ResponseType.bytes));
                                  imageBytes =
                                      Uint8List.fromList(response.data);
                                } else {
                                  imageBytes =
                                      File.fromUri(Uri.file(item['image']))
                                          .readAsBytesSync();
                                }
                                final result =
                                    await ImageGallerySaver.saveImage(
                                        imageBytes);
                                Toast.show(result.toString(), context);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text('取消',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontFamily: 'PingFangMedium')),
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ));
              },
              child: Container(
                margin: EdgeInsets.only(right: 15),
                child: ClipOval(
                  child: item['net'] == true
                      ? Image.network(
                          item['image'],
                          width: 46,
                          height: 46,
                          fit: BoxFit.fill,
                          errorBuilder: (context, objc, trace) {
                            return Container(
                              width: 46,
                              height: 46,
                              color: Colors.red,
                            );
                          },
                        )
                      : Image.file(
                          File(item['image']),
                          width: 46,
                          height: 46,
                          fit: BoxFit.fill,
                          errorBuilder: (context, objc, trace) {
                            return Container(
                              width: 46,
                              height: 46,
                              color: Colors.red,
                            );
                          },
                        ),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 5.0),
                    child: Text(
                      item['name'],
                      style: TextStyle(fontSize: 15, color: textBlack),
                    ),
                  ),
                  Text(
                    item['content'],
                    style: TextStyle(fontSize: 12, color: textGray),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "2020.1.1",
                  style: TextStyle(fontSize: 12, color: textBlack),
                ),
                SizedBox(
                  height: 8,
                ),
                item['read']
                    ? Container()
                    : CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 4,
                      )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
