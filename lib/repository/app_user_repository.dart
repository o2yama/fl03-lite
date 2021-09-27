import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl03_lite/domain/app_user/app_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final appUserRepository = AppUserRepository.instance;

class AppUserRepository {
  AppUserRepository._();

  static final instance = AppUserRepository._();
  final _db = FirebaseFirestore.instance;

  Future<void> insertAppUser(String name, String id) async {
    final appUser = AppUser().copyWith(name: name, id: id);

    await _db.collection('users').doc(id).set(appUser.toJson());
  }

  Future<AppUser> getAppUserData(String id) async {
    try {
      final query = await _db.collection('users').doc(id).get();
      final appUser = AppUser.fromJson(query.data()!).copyWith();
      return appUser;
    } on Exception catch (e) {
      debugPrint(e.toString());
      return AppUser().copyWith();
    }
  }
}
