// ignore_for_file: avoid_print

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import 'firebase_db.dart';

Future<bool> registerFirebase(
  String name,
  String email,
  String password,
) async {
  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user!.updateDisplayName(name);
    final photoUrl =
        await uploadProfilePicture(await getImageFileFromAssets('profile.png'));
    await credential.user!.updatePhotoURL(photoUrl);
    return true;
  } catch (e) {
    print(e.toString());
    return false;
  }
}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');

  final file = File('${(await getTemporaryDirectory()).path}/$path');
  await file.create(recursive: true);
  await file.writeAsBytes(byteData.buffer
      .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));

  var pathOld = file.path;
  var lastSeparator = pathOld.lastIndexOf(Platform.pathSeparator);
  var newPath = pathOld.substring(0, lastSeparator + 1) +
      FirebaseAuth.instance.currentUser!.uid;

  return file.rename(newPath);
}
