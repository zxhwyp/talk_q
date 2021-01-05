import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flustars/flustars.dart';
import 'login/login_screen.dart';

main() async {
  runApp(RootPage());
  if (Platform.isAndroid) {
    /// 设置android状态栏为透明的沉浸
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class RootPage extends StatelessWidget {
  final bool welcome;
  RootPage({this.welcome});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [Locale("zh"), Locale("en")],
      debugShowCheckedModeBanner: false,
      home: AnnotatedRegion(
          child: LoginScreen(), value: SystemUiOverlayStyle.dark),
    );
  }
}
