import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFieldWidget extends StatelessWidget {
  TextFieldWidget({
    required this.icon,
    required this.hintText,
    required this.isObscure,
    required this.controller,
    required this.keyboardType,
  });
  final TextEditingController controller;
  final IconData icon;
  final String hintText;
  final bool isObscure; //Textを隠すかどうか
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return CupertinoTextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isObscure,
      placeholder: hintText,
      prefix: Icon(icon, color: Colors.white),
      cursorColor: Colors.white,
      placeholderStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
      style: TextStyle(color: Colors.white),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.white)),
      ),
    );
  }
}
