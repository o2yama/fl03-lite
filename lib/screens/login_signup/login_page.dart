import 'package:fl03_lite/common/screen_size.dart';
import 'package:fl03_lite/common/validator.dart';
import 'package:fl03_lite/domain/app_user/app_user.dart';
import 'package:fl03_lite/screens/login_signup/signup_page.dart';
import 'package:fl03_lite/screens/login_signup/widget/firebase_logo.dart';
import 'package:fl03_lite/screens/login_signup/widget/text_field_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final emailController = TextEditingController();
final passwordController = TextEditingController();

class LoginPage extends HookWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Route<Widget> route({required bool fullScreenDialog}) {
    return MaterialPageRoute<Widget>(
      builder: (_) => LoginPage(),
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

    Widget _passwordField() {
      return TextFieldWidget(
        icon: CupertinoIcons.lock,
        hintText: 'Password',
        isObscure: true,
        controller: passwordController,
        keyboardType: TextInputType.visiblePassword,
      );
    }

    Future<void> onLoginButtonPressed() async {
      if (!validator.validEmail(emailController.text)) {
        debugPrint('The email address is invalid.');
      } else if (!validator.validPassword(passwordController.text)) {
        debugPrint('The password is invalid.');
      } else {
        buttonColor.value = Colors.grey.shade200;
        try {
          //ログイン
          await _appUserModel.signIn(
              emailController.text, passwordController.text);
          //controllerのクリア
          emailController.clear();
          passwordController.clear();
          //WelcomePageへ
          Navigator.popUntil(context, (route) => route.isFirst);
        } on Exception catch (e) {
          debugPrint(e.toString());
        } finally {
          buttonColor.value = Colors.white;
        }
      }
    }

    Widget _loginButton() {
      return SizedBox(
        width: screenSize.width(context),
        height: 50,
        child: ElevatedButton(
          onPressed: onLoginButtonPressed,
          style: ElevatedButton.styleFrom(primary: buttonColor.value),
          child: Text(
            'LOG IN',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ),
      );
    }

    Widget _toSignupPageText() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Don\'t have an account?',
            style: TextStyle(color: Colors.white),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              SignupPage.route(fullScreenDialog: false),
            ),
            child: Text(
              'Sign up',
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
                  const SizedBox(height: 32),
                  _passwordField(),
                  const SizedBox(height: 32),
                  _loginButton(),
                  const Expanded(child: SizedBox()),
                  _toSignupPageText(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
