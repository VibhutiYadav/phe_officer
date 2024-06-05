import 'package:get/get.dart';

import '../controllers/my_work_controller.dart';


class MyWorkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyWorkController>(
          () => MyWorkController(),
    );
  }
}
