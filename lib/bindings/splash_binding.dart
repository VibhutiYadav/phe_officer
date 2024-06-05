import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../controllers/splash_contoller.dart';


class SplashBinding implements Bindings{
  @override
  void dependencies(){
    // Get.lazyPut(() => SplashController());
    Get.put(SplashController());
  }
}