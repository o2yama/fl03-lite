import 'package:fl03_lite/common/screen_size.dart';
import 'package:fl03_lite/common/validator.dart';
import 'package:fl03_lite/domain/app_user/app_user.dart';
import 'package:fl03_lite/screens/login_signup/widget/firebase_logo.dart';
import 'package:fl03_lite/screens/login_signup/widget/text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'login_page.dart';

final usernameController = TextEditingController();

class SignupPage extends HookWidget {
  const SignupPage({Key? key}) : super(key: key);

  static Route<Widget> route({required bool fullScreenDialog}) {
    return MaterialPageRoute<Widget>(
      builder: (_) => SignupPage(),
      fullscreenDialog: fullScreenDialog,
    );
  }

  @override
  Widget build(BuildContext context) {
    final _appUserModel = useProvider(appUserModelProvider.notifier);
    final buttonColor = useState(Colors.white);

    Widget _emailField() {
      return TextFieldWidget(
        icon: CupertinoIcons.mail,
        hintText: 'Email',
        isObscure: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
      );
    }

    Widget _usernameField() {
      return TextFieldWidget(
        icon: CupertinoIcons.person,
        hintText: 'Username',
        isObscure: false,
        controller: usernameController,
        keyboardType: TextInputType.text,
      );
    }

    Widget _passwordField() {
      return TextFieldWidget(
        icon: CupertinoIcons.lock,
        hintText: 'Password',
        isObscure: true,
        controller: passwordController,
        keyboardType: TextInputType.visiblePassword,
      );
    }

    Future<void> onSignupButtonPressed() async {
      if (!validator.validEmail(emailController.text)) {
        debugPrint('The email address is invalid.');
      } else if (!validator.validPassword(passwordController.text)) {
        debugPrint('The password is invalid.');
      } else if (usernameController.text.isEmpty) {
        debugPrint('Enter your name.');
      } else {
        buttonColor.value = Colors.grey.shade200;
        try {
          //ユーザー作成
          await _appUserModel.createUser(emailController.text,
              passwordController.text, usernameController.text);
          //controllerクリア
          emailController.clear();
          passwordController.clear();
          usernameController.clear();
          //WelcomePageへ
          Navigator.popUntil(context, (route) => route.isFirst);
        } on Exception catch (e) {
          debugPrint(e.toString());
        } finally {
          buttonColor.value = Colors.white;
        }
      }
    }

    Widget _signupButton() {
      return SizedBox(
        width: screenSize.width(context),
        height: 50,
        child: ElevatedButton(
          onPressed: onSignupButtonPressed,
          style: ElevatedButton.styleFrom(primary: buttonColor.value),
          child: Text(
            'SIGN UP',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      );
    }

    Widget _toLoginPageText() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Already have an account?',
            style: TextStyle(color: Colors.white),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              LoginPage.route(fullScreenDialog: false),
            ),
            child: Text(
              'Sign in',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SingleChildScrollView(
          child: SizedBox(
            height: screenSize.height(context),
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  FirebaseLogo(),
                  _emailField(),
                  const SizedBox(height: 40),
                  _usernameField(),
                  const SizedBox(height: 32),
                  _passwordField(),
                  const SizedBox(height: 32),
                  _signupButton(),
                  const Expanded(child: SizedBox()),
                  _toLoginPageText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
