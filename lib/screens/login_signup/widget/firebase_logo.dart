import 'package:fl03_lite/common/screen_size.dart';
import 'package:flutter/cupertino.dart';

class FirebaseLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenSize.height(context) * 0.3,
      width: screenSize.width(context),
      child: Center(
        child: SizedBox(
          height: 150,
          width: 150,
          child: Image.asset('assets/images/firebase-logo.png'),
        ),
      ),
    );
  }
}
