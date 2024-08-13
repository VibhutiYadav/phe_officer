import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../routes/routes.dart';
import 'package:flutter/services.dart';
import '../view/screens/bottom_navigaton.dart';
import 'newLocationController.dart';


class SplashController extends GetxController {
  Timer? _timer;


  @override
  void onInit() {
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    super.onInit();
    loadData();
  }

  @override
  void onReady() {
    super.onReady();
    loadData();
  }


  Future<void> _redirect() async {
    _timer = Timer(
      const Duration(milliseconds: 5000),
          () async {
        await SystemChrome.setEnabledSystemUIMode(
          SystemUiMode.manual,
          overlays: [
            SystemUiOverlay.top,
            SystemUiOverlay.bottom,
          ],
        );
        await Future.delayed(const Duration(milliseconds: 50));


      },
    );
  }

  @override
  void onClose() {
    _timer?.cancel();
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.blue));
    super.onClose();
  }

  Future<Timer> loadData() async {
    return Timer(const Duration(milliseconds: 3000), onDoneLoading);
  }
  LocationController locationController=Get.put(LocationController());
  onDoneLoading() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData=await prefs.getString('UserDetail');
    var userId=await prefs.getString('UserId');
    if(kDebugMode){
      // (kDebugMode)?print("user id $userData");
    }

    // var userId = storage.read('USER_ID');
    if(locationController.PermissionGiven.value!='always'){
      locationController.showAlert();
    };
    // (kDebugMode)?print("called");
    if (userId == '' || userId== null) {
      Get.offNamed("/loginScreen");
    } else {
      // Get.offAll(Bottom());
      Get.offAll(BottomNavigation());
    }
  }
}
