import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import 'account_controller.dart';

class AccountPage extends GetView<AccountController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50),
              StreamBuilder<User?>(
                stream: controller.userStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return CachedNetworkImage(
                      imageUrl: snapshot.data!.photoURL as String,
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
                  } else {
                    return const SizedBox(
                      width: 80.0,
                      height: 80.0,
                      child: Icon(Icons.error),
                    );
                  }
                },
              ),
              // Image.asset(
              //   'assets/profile.png',
              //   width: 70,
              //   height: 70,
              // ),
              SizedBox(height: 15),
              StreamBuilder<User?>(
                stream: controller.userStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!.displayName.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(height: 20),
              StreamBuilder<User?>(
                stream: controller.userStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "${snapshot.data!.email}",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.EDITPROFILE),
                child: Container(
                  width: 100,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.amber,
                  ),
                  child: Center(
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  controller.logout();
                  Get.offAllNamed(AppRoutes.HOMEPAGE);
                },
                child: Container(
                  width: 100,
                  height: 35,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
