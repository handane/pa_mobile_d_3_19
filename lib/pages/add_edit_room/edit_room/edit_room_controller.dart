import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditRoomController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  QueryDocumentSnapshot<Object?> data;
  FirebaseAuth auth = FirebaseAuth.instance;
  late Future<ListResult> futureFiles;
  late CollectionReference dataRooms;

  var currentUrlIcon = ''.obs;
  var currentIcon = 0.obs;
  var roomName = ''.obs;

  late RxList<String> lightningDevices = [''].obs;
  late RxList<String> coolingDevices = [''].obs;
  late RxList<String> securityDevices = [''].obs;

  EditRoomController(this.data);

  @override
  void onInit() {
    super.onInit();
    dataRooms = firestore
        .collection('rooms')
        .doc(auth.currentUser!.uid)
        .collection('room');
    roomName.value = data.get('name');
    var iconMap = Map<String, String>.from(data.get('icon'));
    currentUrlIcon.value = iconMap.values.first;
    currentIcon.value = int.tryParse(iconMap.keys.first) ?? 0;
    futureFiles = FirebaseStorage.instance.ref('/assets').listAll();

    var map1 = Map<String, bool>.from(data.get('lightningDevices'));
    if (map1.isNotEmpty) {
      lightningDevices.clear();
      map1.forEach((key, value) {
        lightningDevices.add(key);
      });
    }

    var map2 = Map<String, bool>.from(data.get('coolingDevices'));
    if (map2.isNotEmpty) {
      coolingDevices.clear();
      map2.forEach((key, value) {
        coolingDevices.add(key);
      });
    }

    var map3 = Map<String, bool>.from(data.get('securityDevices'));
    if (map3.isNotEmpty) {
      securityDevices.clear();
      map3.forEach((key, value) {
        securityDevices.add(key);
      });
    }
  }

  void setRoomName(String value) {
    roomName.value = value;
    print(roomName.value);
  }

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

  Future<bool> updateRoom() async {
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
      await dataRooms.doc(data.id).update({
        'name': roomName.value,
        'icon': iconData,
        'total': lightningDeviceMap.length +
            coolingDeviceMap.length +
            securityDeviceMap.length,
        'lightningDevices': lightningDeviceMap,
        'coolingDevices': coolingDeviceMap,
        'securityDevices': securityDeviceMap,
      });

      // lightningDevices.value = [''];
      // coolingDevices.value = [''];
      // securityDevices.value = [''];
      // roomName.value = '';
      // currentIcon.value = 0;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
