
import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
import '../view/screens/bottom_navigaton.dart';


class SplashController extends GetxController {
  Timer? _timer;


  @override
  void onInit() {
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
      const Duration(milliseconds: 1000),
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
    super.onClose();
  }

  Future<Timer> loadData() async {
    return Timer(const Duration(milliseconds: 3000), onDoneLoading);
  }

  onDoneLoading() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData=await prefs.getString('UserDetail');
    final SupervisorId = prefs.getString('SupervisorId');
    print("SupervisorId $SupervisorId");
    // var userId = storage.read('USER_ID');

    // print("called");
    if (SupervisorId == '' || SupervisorId== null) {
      Get.offNamed("/loginScreen");
    } else {

      Get.offAll(BottomNavigation());
    }
  }
}
