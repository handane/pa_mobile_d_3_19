import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../auth/firebase_db.dart';

class EditProfileController extends GetxController {
  TextEditingController nameController = TextEditingController();

  var isPictureChanged = false;
  var isSaving = false.obs;

  String initPhoto = FirebaseAuth.instance.currentUser!.photoURL ?? "";
  String initName = FirebaseAuth.instance.currentUser!.displayName ?? "";
  XFile? profilePictureTemp;

  @override
  void onInit() {
    super.onInit();
    nameController.text = initName;
  }

  void changedPictureToTrue() {
    isPictureChanged = true;
    update();
  }

  void changedTempPicture(XFile file) {
    profilePictureTemp = file;
    update();
  }

  Future<void> updateName(String name) async {
    await updateNameFirebase(name);
  }

  Future<void> updatePhotoProfile(File? file) async {
    String photoUrl = await uploadProfilePicture(file);
    await updatePhotoFirebase(photoUrl);
  }

  Future<void> deletePhotoProfile() async {
    await deleteProfilePicture();
  }
}
