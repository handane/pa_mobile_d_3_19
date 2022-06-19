import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../add_room.dart';
import '../text_field/edit_text_field.dart';
import 'edit_room_controller.dart';

class EditRoom extends StatefulWidget {
  EditRoom({Key? key}) : super(key: key);

  @override
  State<EditRoom> createState() => _EditRoomState();
}

class _EditRoomState extends State<EditRoom> {
  EditRoomController controller = Get.put(EditRoomController(Get.arguments));
  final _formKey = GlobalKey<FormState>();

  Future _getIcon() {
    return Get.defaultDialog(
      title: "Choose Icon",
      contentPadding: const EdgeInsets.symmetric(vertical: 20),
      content: SizedBox(
        width: 250,
        height: 200,
        child: FutureBuilder<ListResult>(
          future: controller.futureFiles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error"),
              );
            } else {
              final data = snapshot.data!.items;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 70,
                  childAspectRatio: 1,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return FutureBuilder<String>(
                    future: data[index].getDownloadURL(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text("Error"),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            controller.currentUrlIcon.value = snapshot.data!;
                            controller.currentIcon.value = index;
                          },
                          child: Obx(
                            () {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: (controller.currentIcon.value ==
                                              index)
                                          ? Colors.blue
                                          : Colors.black,
                                      width: 3),
                                ),
                                child: Image.network(snapshot.data!),
                              );
                            },
                          ),
                        );
                      }
                    },
                  );
                },
              );
            }
          },
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
            width: 70,
            height: 35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            child: Center(
              child: Text('Close'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Room'),
        backgroundColor: Color.fromARGB(255, 245, 245, 245),
        foregroundColor: Colors.black,
      ),
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 20),
            Center(
              child: Text(
                "Edit Room",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: GestureDetector(
                onTap: () => _getIcon(),
                child: Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.black),
                    color: const Color(0xffFCF7D3),
                  ),
                  child: Obx(() {
                    return Image.network(
                      controller.currentUrlIcon.value,
                    );
                  }),
                ),
              ),
            ),
            SizedBox(height: 15),
            Form(
              key: _formKey,
              child: SizedBox(
                //height: 45,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter name room';
                    }
                    return null;
                  },
                  initialValue: controller.roomName.value,
                  decoration: InputDecoration(
                    labelText: "Room Name",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) => controller.roomName.value = value,
                ),
              ),
            ),
            SizedBox(height: 15),
            Row(
              children: [
                Center(
                  child: Image.asset(
                    'assets/light.png',
                    color: Colors.black,
                    width: 40,
                    height: 40,
                  ),
                ),
                SizedBox(width: 7),
                Text(
                  'Lightning Devices',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 5),
            ..._getLightningDevices(),
            SizedBox(height: 15),
            Row(
              children: [
                Center(
                  child: Image.asset(
                    'assets/cooling.png',
                    color: Colors.black,
                    width: 40,
                    height: 40,
                  ),
                ),
                SizedBox(width: 7),
                Text(
                  'Cooling Devices',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 5),
            ..._getCoolingDevices(),
            SizedBox(height: 15),
            Row(
              children: [
                Center(
                  child: Image.asset(
                    'assets/secure.png',
                    color: Colors.black,
                    width: 40,
                    height: 40,
                  ),
                ),
                SizedBox(width: 7),
                Text(
                  'Security Devices',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 5),
            ..._getSecurityDevices(),
            SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
                if (_formKey.currentState!.validate()) {
                  if (controller.isEmptyAll) {
                    Get.defaultDialog(
                      title: 'Warning',
                      content: Container(
                        child: Column(
                          children: [
                            Text(
                              'At least one device is inserted in first line',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 30),
                            Center(
                              child: GestureDetector(
                                onTap: () => Get.back(),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.blueAccent,
                                  ),
                                  width: 75,
                                  height: 50,
                                  child: Center(child: Text("Oke")),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else {
                    controller.updateRoom().then((value) {
                      if (value) {
                        Get.back();
                        Get.defaultDialog(
                          title: '',
                          content: Container(
                            child: Column(
                              children: [
                                Text(
                                  'Room has been updated',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 30),
                                Center(
                                  child: GestureDetector(
                                    onTap: () => Get.back(),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.blueAccent,
                                      ),
                                      width: 75,
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          "Oke",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Failed to update room'),
                          ),
                        );
                      }
                    });
                  }
                }
              },
              child: Center(
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blueAccent,
                  ),
                  child: Center(
                    child: Text(
                      "Edit Ruangan",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  List<Widget> _getLightningDevices() {
    List<Widget> friendsTextFields = [];
    for (int i = 0; i < controller.lightningDevices.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Expanded(child: EditLightningDeviceTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(
              i == controller.lightningDevices.length - 1,
              i,
              DeviceType.lightning,
            ),
          ],
        ),
      ));
    }
    return friendsTextFields;
  }

  List<Widget> _getCoolingDevices() {
    List<Widget> friendsTextFields = [];
    for (int i = 0; i < controller.coolingDevices.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Expanded(child: EditCoolingDeviceTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(
              i == controller.coolingDevices.length - 1,
              i,
              DeviceType.cooling,
            ),
          ],
        ),
      ));
    }
    return friendsTextFields;
  }

  List<Widget> _getSecurityDevices() {
    List<Widget> friendsTextFields = [];
    for (int i = 0; i < controller.securityDevices.length; i++) {
      friendsTextFields.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        child: Row(
          children: [
            Expanded(child: EditSecurityDeviceTextFields(i)),
            SizedBox(
              width: 16,
            ),
            // we need add button at last friends row
            _addRemoveButton(
              i == controller.securityDevices.length - 1,
              i,
              DeviceType.security,
            ),
          ],
        ),
      ));
    }
    return friendsTextFields;
  }

  Widget _addRemoveButton(bool add, int index, DeviceType type) {
    return InkWell(
      onTap: () {
        if (type == DeviceType.lightning) {
          if (add) {
            controller.lightningDevices.add('');
          } else {
            controller.lightningDevices.removeAt(index);
          }
        } else if (type == DeviceType.cooling) {
          if (add) {
            controller.coolingDevices.add('');
          } else {
            controller.coolingDevices.removeAt(index);
          }
        } else {
          if (add) {
            controller.securityDevices.add('');
          } else {
            controller.securityDevices.removeAt(index);
          }
        }
        setState(() {});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }
}
