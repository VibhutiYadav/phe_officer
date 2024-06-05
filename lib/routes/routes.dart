import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../bindings/dashboard_binding/dashboard_binding.dart';
import '../bindings/login_binding/login_binding.dart';
import '../bindings/my_work_binding.dart';
import '../bindings/splash_binding.dart';
import '../view/screens/dashboard_view.dart';
import '../view/screens/login_screen.dart';
import '../view/screens/my_work_screen.dart';
import '../view/screens/splash_screen.dart';



class Routes {
  // UserLoginController? _loginController;
  static Future<void> Initial_route = Routes.splashScreen();
  static final List<GetPage<dynamic>> getPages = [
    GetPage(
      name: "/",
      page: () => SplashScreen(),
      popGesture: true,
      binding: SplashBinding(),
      showCupertinoParallax: true,
    ),

    GetPage(
      name: "/loginScreen",
      page: () =>  LoginScreen(),
      popGesture: true,
      binding: LoginScreenBinding(),
      showCupertinoParallax: true,
    ),

    GetPage(
      name: "/dashboard",
      page: () =>  DashboardView(),
      popGesture: true,
      binding: DashboardBinding(),
      showCupertinoParallax: true,
    ),

    GetPage(
      name: "/workscreen",
      page: () =>  MyWorkScreen(),
      popGesture: true,
      binding: MyWorkBinding(),
      showCupertinoParallax: true,
    ),

  ];

  static Future<void> splashScreen() async {
    return await Get.offAllNamed("/");
  }
  static Future<void> loginScreen() async {
    return await Get.offAllNamed("/loginScreen");
  }
  static Future<void> dashboardScreen() async {
    return await Get.offAllNamed("/dashboardScreen");
  }
  static Future<void> myWorkScreen() async {
    return await Get.offAllNamed("/workScreen");
  }





}