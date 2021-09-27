import 'package:fl03_lite/repository/app_user_repository.dart';
import 'package:fl03_lite/repository/auth_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

part '../app_user/app_user.freezed.dart';
part '../app_user/app_user.g.dart';

final appUserModelProvider =
    StateNotifierProvider<AppUserModel, AppUser>((ref) => AppUserModel());

class AppUserModel extends StateNotifier<AppUser> {
  AppUserModel() : super(AppUser().copyWith());

  Future<void> createUser(String email, String password, String name) async {
    try {
      await authRepository.createUserInAuth(email, password).then(
        (String id) async {
          await appUserRepository.insertAppUser(name, id);
          state = await appUserRepository.getAppUserData(id);
        },
      );
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      await authRepository.signInWithEmailAndPassword(email, password).then(
        (String id) async {
          state = await appUserRepository.getAppUserData(id);
        },
      );
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<String?> getUserData() async {
    try {
      if (state.id == '') {
        final id = await authRepository.getAuthData();
        if (id != null) {
          state = await appUserRepository.getAppUserData(id);
        }
        return id;
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    await authRepository.signOut();
    state = AppUser().copyWith();
  }
}

@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    @Default('') String name,
    @Default('') String id,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
