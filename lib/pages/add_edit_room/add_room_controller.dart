import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddRoomController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  late CollectionReference dataRooms;
  late Future<ListResult> futureFiles;

  var currentIcon = 0.obs;
  var currentUrlIcon =
      "https://firebasestorage.googleapis.com/v0/b/newsmarthome-d6e3c.appspot.com/o/assets%2Fbathroom.png?alt=media&token=e47bcd6c-df5f-48c1-9103-1501eab02531"
          .obs;
  var initUrlIcon =
      "https://firebasestorage.googleapis.com/v0/b/newsmarthome-d6e3c.appspot.com/o/assets%2Fbathroom.png?alt=media&token=e47bcd6c-df5f-48c1-9103-1501eab02531";

  @override
  void onInit() {
    super.onInit();
    dataRooms = firestore
        .collection('rooms')
        .doc(auth.currentUser!.uid)
        .collection('room');
    futureFiles = FirebaseStorage.instance.ref('/assets').listAll();
  }

  TextEditingController nameController = TextEditingController();

  var lightningDevices = [''].obs;
  var coolingDevices = [''].obs;
  var securityDevices = [''].obs;

  void setLightningDevices(String value, int index) {
    lightningDevices[index] = value;
    print(lightningDevices);
  }

  void setCoolingDevices(String value, int index) {
    coolingDevices[index] = value;
    print(coolingDevices);
  }

  void setSecurityDevices(String value, int index) {
    securityDevices[index] = value;
    print(securityDevices);
  }

  bool get isEmptyAll =>
      lightningDevices[0] == '' &&
      securityDevices[0] == '' &&
      coolingDevices[0] == '';

  Future<bool> addRoom() async {
    var lightningDeviceMap = {for (var e in lightningDevices) e: false};
    lightningDeviceMap.removeWhere((key, value) => key == '');
    var coolingDeviceMap = {for (var e in coolingDevices) e: false};
    coolingDeviceMap.removeWhere((key, value) => key == '');
    var securityDeviceMap = {for (var e in securityDevices) e: false};
    securityDeviceMap.removeWhere((key, value) => key == '');

    Map<String, String> iconData = {
      currentIcon.value.toString(): currentUrlIcon.value,
    };

    try {
      await dataRooms.add({
        'name': nameController.text,
        'icon': iconData,
        'total': lightningDeviceMap.length +
            coolingDeviceMap.length +
            securityDeviceMap.length,
        'lightningDevices': lightningDeviceMap,
        'coolingDevices': coolingDeviceMap,
        'securityDevices': securityDeviceMap,
      });

      lightningDevices.value = [''];
      coolingDevices.value = [''];
      securityDevices.value = [''];
      currentUrlIcon.value = initUrlIcon;
      nameController.clear();

      currentIcon.value = 0;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
