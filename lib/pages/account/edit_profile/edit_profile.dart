import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../account_controller.dart';
import 'edit_profile_controller.dart';

class EditProfile extends StatelessWidget {
  EditProfile({Key? key}) : super(key: key);
  final controller = Get.put(EditProfileController());
  final _cropper = ImageCropper();
  final _picker = ImagePicker();

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      controller.changedTempPicture(response.file!);
    } else {
      print("Error");
    }
  }

  Future _errorDialog() {
    return Get.defaultDialog(
      title: "Unable to change profile",
      titlePadding: const EdgeInsets.only(
        top: 20,
        bottom: 5,
      ),
      contentPadding: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 20,
      ),
      content: Text(
        "Connect to internet and then retry",
      ),
      actions: [
        SizedBox(width: Get.width * 230),
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            width: 70,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
            ),
            child: Center(
              child: Text(
                'Close',
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _saveProfile() async {
    controller.isSaving.value = true;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 5));
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          if (controller.isPictureChanged) {
            String? photoURLold = FirebaseAuth.instance.currentUser!.photoURL;
            await controller.deletePhotoProfile();
            await controller.updatePhotoProfile(
              File(controller.profilePictureTemp!.path),
            );
            CachedNetworkImage.evictFromCache(photoURLold as String);
          }
          if (controller.nameController.text != controller.initName) {
            await controller.updateName(controller.nameController.text);
          }
        }
        Get.back();
      } on SocketException catch (e) {
        _errorDialog();
      }
    } else {
      _errorDialog();
    }
    controller.isSaving.value = false;
  }

  void _pickProfilePicture() async {
    final fileData = await _picker.pickImage(source: ImageSource.gallery);
    if (fileData != null) {
      final croppedFile = await _cropper.cropImage(
        sourcePath: fileData.path,
        cropStyle: CropStyle.circle,
        compressFormat: ImageCompressFormat.png,
        compressQuality: 100,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Photo Crop',
            toolbarColor: Colors.black,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            statusBarColor: Colors.black,
            lockAspectRatio: false,
          ),
        ],
      );
      if (croppedFile != null) {
        controller.changedTempPicture(XFile(croppedFile.path));
        if (controller.isPictureChanged == false) {
          controller.changedPictureToTrue();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Future exitDialog() {
      return Get.defaultDialog(
        title: "Profile unsaved",
        titlePadding: const EdgeInsets.only(
          top: 20,
          bottom: 5,
        ),
        contentPadding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 20,
        ),
        content: Text(
          "Profile not saved. Exit anyway?",
        ),
        actions: [
          SizedBox(width: 250),
          GestureDetector(
            onTap: () {
              Get.back();
              Get.back();
            },
            child: Container(
              width: 70,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  'Exit',
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 70,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  'Cancel',
                ),
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 245, 245, 245),
        foregroundColor: Colors.black,
        title: Text('Edit Profile'),
      ),
      body: Column(
        children: [
          SizedBox(height: Get.height * 0.07),
          GetBuilder<EditProfileController>(
            builder: (_) {
              if (controller.isPictureChanged) {
                return CircleAvatar(
                  radius: 40,
                  backgroundImage: FileImage(
                    File(
                      controller.profilePictureTemp!.path,
                    ),
                  ),
                );
              } else {
                return CachedNetworkImage(
                  imageUrl: controller.initPhoto,
                  imageBuilder: (context, imageProvider) {
                    return Container(
                      width: 80.0,
                      height: 80.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  },
                  placeholder: (context, url) {
                    return const SizedBox(
                      width: 80.0,
                      height: 80.0,
                      child: CircularProgressIndicator(),
                    );
                  },
                  errorWidget: (context, url, error) {
                    return const SizedBox(
                      width: 80.0,
                      height: 80.0,
                      child: Icon(Icons.error),
                    );
                  },
                );
              }
            },
          ),
          SizedBox(height: 10),
          Center(
            child: GestureDetector(
              onTap: () => _pickProfilePicture(),
              child: Text(
                "Change Profile Picture",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextFormField(
              controller: controller.nameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Name",
              ),
            ),
          ),
          SizedBox(height: 35),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: () async {
                if (controller.isSaving.isFalse) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  _saveProfile();
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.blueAccent,
                ),
                child: Obx(() {
                  if (controller.isSaving.value == true) {
                    return Center(
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "Update Profile",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
