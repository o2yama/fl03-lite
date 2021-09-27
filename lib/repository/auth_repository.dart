import 'package:firebase_auth/firebase_auth.dart';

final authRepository = AuthRepository.instance;

class AuthRepository {
  AuthRepository._();
  static final instance = AuthRepository._();

  final _auth = FirebaseAuth.instance;

  Future<String> createUserInAuth(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw _convertErrorMessage(e.code);
    } on Exception catch (e) {
      throw _convertErrorMessage(e.toString());
    }
  }

  Future<String> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user!.uid;
    } on FirebaseAuthException catch (e) {
      throw _convertErrorMessage(e.code);
    } on Exception catch (e) {
      throw _convertErrorMessage(e.toString());
    }
  }

  Future<String?> getAuthData() async {
    final user = _auth.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

String _convertErrorMessage(String errorMassage) {
  switch (errorMassage) {
    case 'weak-password':
      return '安全なパスワードではありません';
    case 'email-already-in-use':
      return 'メールアドレスがすでに使われています';
    case 'invalid-email':
      return 'メールアドレスを正しい形式で入力してください';
    case 'operation-not-allowed':
      return '登録が許可されていません';
    case 'wrong-password':
      return 'パスワードが間違っています';
    case 'user-not-found':
      return 'ユーザーが見つかりません';
    case 'user-disabled':
      return 'ユーザーが無効です';
    default:
      return '不明なエラーです';
  }
}
