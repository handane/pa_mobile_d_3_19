import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

Future<bool> updateNameFirebase(String newName) async {
  try {
    await FirebaseAuth.instance.currentUser!.updateDisplayName(newName);
    return true;
  } on Exception catch (e) {
    return false;
  }
}

Future<bool> updatePhotoFirebase(String photoUrl) async {
  try {
    await FirebaseAuth.instance.currentUser!.updatePhotoURL(photoUrl);
    return true;
  } on Exception catch (e) {
    return false;
  }
}

Future<String> uploadProfilePicture(File? fileData) async {
  if (fileData != null) {
    var pathOld = fileData.path;
    var lastSeparator = pathOld.lastIndexOf(Platform.pathSeparator);
    var newPath = pathOld.substring(0, lastSeparator + 1) +
        FirebaseAuth.instance.currentUser!.uid;
    final newFileData = await fileData.rename(newPath);
    String path = basename(newFileData.path);
    final ref = _storage.ref('profilePicture/$path');
    UploadTask uploadTask = ref.putFile(newFileData);
    final snapshotData = await uploadTask.whenComplete(() {});
    final photoDownload = snapshotData.ref.getDownloadURL();
    return photoDownload;
  } else {
    return "Empty";
  }
}

Future<bool> deleteProfilePicture() async {
  try {
    final oldPhoto = FirebaseAuth.instance.currentUser!.photoURL;
    await FirebaseStorage.instance.refFromURL(oldPhoto!).delete();
    return true;
  } on Exception catch (e) {
    return false;
  }
}
