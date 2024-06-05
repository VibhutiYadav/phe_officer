import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/bindings_interface.dart';

import '../../controllers/login_controller/login_controller.dart';

class LoginScreenBinding implements Bindings{
  @override
  void dependencies(){
    Get.lazyPut(() => LoginController());
  }
}