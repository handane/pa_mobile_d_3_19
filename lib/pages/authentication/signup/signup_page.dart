import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:posttest6/pages/authentication/signup/signup_controller.dart';

import '../../../routes/app_routes.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);
  SignUpController signUpController = Get.put(SignUpController());

  Future successDialog() {
    return Get.defaultDialog(
      title: 'Success',
      content: Container(
        child: Column(
          children: [
            Text(
              'Signup success, login to continue',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: GestureDetector(
                onTap: () {
                  signUpController.logout();
                  Get.offAllNamed(AppRoutes.HOMEPAGE);
                  Get.toNamed(AppRoutes.LOGIN);
                },
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
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Container(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: Get.height * 0.07),
            Center(
              child: SizedBox(
                width: Get.width * 0.5,
                child: Image.asset(
                  'assets/splash.png',
                ),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                signUpController.nameChanged(value);
              },
              decoration: InputDecoration(
                labelText: 'Name',
              ),
            ),
            SizedBox(height: 7),
            //Text("Email"),
            //SizedBox(height: 5),
            TextField(
              onChanged: (value) {
                signUpController.emailChanged(value);
              },
              decoration: InputDecoration(
                labelText: 'Email',
              ),
            ),
            SizedBox(height: 7),
            //Text("Password"),
            //SizedBox(height: 5),
            TextField(
              obscureText: true,
              onChanged: (value) {
                signUpController.passwordChanged(value);
              },
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: GestureDetector(
                onTap: () async {
                  if (signUpController.isLoading.isFalse) {
                    FocusManager.instance.primaryFocus?.unfocus();
                    signUpController.isLoading.value = true;
                    var isLogin = await signUpController.signUp();
                    if (isLogin) {
                      signUpController.isLoading.value = false;
                      //Get.offAllNamed(AppRoutes.DASHBOARD);
                      successDialog();
                    } else {
                      signUpController.isLoading.value = false;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Sign up Failed'),
                        ),
                      );
                    }
                  }
                },
                child: Obx(
                  () {
                    return Container(
                      child: (signUpController.isLoading.value)
                          ? Center(
                              child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ))
                          : Center(
                              child: Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                      width: Get.width * 0.6,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.blue,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () => Get.back(),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back),
                    SizedBox(width: 5),
                    Text("Back"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
