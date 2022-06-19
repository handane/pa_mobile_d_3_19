import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:posttest6/auth/login.dart';

import '../../auth/firebase_db.dart';

class AccountController extends GetxController {
  Stream<User?> get userStream => FirebaseAuth.instance.userChanges();

  void logout() async {
    await logoutFirebase();
  }
}
