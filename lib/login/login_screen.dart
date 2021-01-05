import 'package:flutter/material.dart';
import 'package:talk_q/login/rounded_buttons.dart';
import 'package:talk_q/login/rounded_input_field.dart';
import 'package:talk_q/talk/main_page.dart';
import 'package:talk_q/talk/message.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            RoundedInputField(
              icon: Icons.person,
              hintText: "Phone Number",
              onChanged: (value) {},
            ),
            RoundedInputField(
              icon: Icons.lock,
              obscureText: true,
              hintText: "Password",
              suffixIcon: Icons.visibility,
              onChanged: (value) {},
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => Message()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
