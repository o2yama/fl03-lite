import 'package:flutter/cupertino.dart';

final screenSize = ScreenSize.instance;

class ScreenSize {
  ScreenSize._();
  static final instance = ScreenSize._();

  double width(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width;
  }

  double height(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return height;
  }
}
