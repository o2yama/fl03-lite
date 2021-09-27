import 'package:fl03_lite/domain/app_user/app_user.dart';
import 'package:fl03_lite/screens/login_signup/login_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class WelcomePage extends HookWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _appUserModel = useProvider(appUserModelProvider.notifier);
    final _appUser = useProvider(appUserModelProvider);

    //ログイン情報取得
    final count = useState(0); //処理を1回だけにするため
    if (count.value == 0) {
      Future.microtask(() async {
        await _appUserModel.getUserData().then((String? id) {
          if (id == null) {
            Navigator.push(context, LoginPage.route(fullScreenDialog: true));
          }
          count.value++;
        });
      });
    }

    Future<void> _showConformationDialog() async {
      await showCupertinoModalPopup(
          context: context,
          builder: (BuildContext context) {
            return CupertinoActionSheet(
              message: Text('Are you sure you want to sign out?'),
              actions: <Widget>[
                CupertinoActionSheetAction(
                  child: Text('Sign Out'),
                  onPressed: () async {
                    await _appUserModel.signOut();
                    count.value--;
                  },
                  isDestructiveAction: true,
                ),
              ],
              cancelButton: CupertinoActionSheetAction(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            );
          });
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text(
          'Firebase Login',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () async {
            await _showConformationDialog();
            Navigator.popUntil(context, (route) => route.isFirst);
          },
          icon: Icon(Icons.arrow_back_sharp, color: Colors.white),
        ),
      ),
      body: Center(
        child: FittedBox(
          child: Text(
            _appUser.id != '' ? 'Welcome, ${_appUser.name}' : 'Welcome, Text',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
        ),
      ),
    );
  }
}
