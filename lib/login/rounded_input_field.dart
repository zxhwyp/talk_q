import 'package:flutter/material.dart';
import '../constants.dart';
import 'text_field_container.dart';

class RoundedInputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final IconData icon, suffixIcon;
  final String hintText;
  final bool obscureText;

  const RoundedInputField({
    Key key,
    this.hintText,
    this.icon,
    this.obscureText = false,
    this.onChanged,
    this.suffixIcon,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _RoundedInputFieldState();
  }
}

class _RoundedInputFieldState extends State<RoundedInputField> {
  bool obscureText;
  @override
  void initState() {
    obscureText = widget.obscureText;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      child: TextField(
        obscureText: obscureText,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          icon: Icon(
            widget.icon,
            color: kPrimaryColor,
          ),
          suffixIcon: IconButton(
              icon: Icon(
                widget.suffixIcon,
                color: kPrimaryColor,
              ),
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              }),
          hintText: widget.hintText,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
