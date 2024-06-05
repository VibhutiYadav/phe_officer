import 'dart:convert';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/constants.dart';
import '../../routes/routes.dart';
import 'package:http/http.dart' as http;
import '../../view/screens/bottom_navigaton.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  RxBool isLoading = false.obs;
  Map<String, dynamic>? user;
  RxBool isPasswordVisible = false.obs;
  RxString email = ''.obs;
  RxString password = ''.obs;
  var deviceToken=''.obs;
  @override
  void onClose() {
    super.onClose();
    passwordController.clear();
    emailController.clear();
    email.value='';
    password.value='';
  }


  @override
  void onInit(){
    _fetchDeviceToken();
    super.onInit();
  }

  Future<void> _fetchDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();

      deviceToken.value = token ?? "Failed to get token";

  }
  Future<void> login() async {
    // Get.to(BottomNavigation());
    if (validateForm()) {
      isLoading.value = true;
      print("email ${email.value}");
      final data = {'email': email.value, 'password': password.value, 'deviceId':deviceToken.value};
      print("device Token $deviceToken");
      try {
        final response = await http.post(
          Uri.parse(Constants.LOG_IN),
          body: json.encode(data),
          headers: {'Content-Type': 'application/json'},
        );
        print("Response code: ${response.statusCode}");
        if (response.statusCode == 200) {
          final responseData = json.decode(response.body);
          final supervisorDetails = responseData['user'];
          print("${response.statusCode}");
          print(" response ${responseData}");
          print(" response ${responseData['message'] }");
          if (responseData['message'] == 'User successfully Login') {
            final supervisorId = supervisorDetails['id'];
            final sign = supervisorDetails['sign'];
            final name = supervisorDetails['name'];
            final email = supervisorDetails['email'];
            final phone=supervisorDetails['phone_number'];
            final image = supervisorDetails['profile'];
            final userType = supervisorDetails['type'];
            SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('SupervisorDetail', json.encode(supervisorDetails));
            await prefs.setString('SupervisorId', supervisorId.toString());
            await prefs.setString('sign', sign??"");
            print("Sign: ${prefs.getString('sign')}");
            await prefs.setString('SupervisorName',name??"");
            print("SupervisorName: ${prefs.getString('SupervisorName')}");
            await prefs.setString('email', email);
            await prefs.setString("phone",phone??"");
            await prefs.setString("userType",userType??"");
            print("SupervisorData $supervisorDetails");
            await prefs.setString("image",image);
            print("Image:${image}");
            print("User details: ${userType}");
            Get.offAll(BottomNavigation());
            // Get.snackbar('लॉगिन सफल', 'आपका स्वागत है!', snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          throw Exception('Failed to load data');
        }
      } catch (error) {
        print("Error:$error");
        Get.snackbar('Alert', 'Invalid email/password.', snackPosition: SnackPosition.BOTTOM);
      } finally {
        isLoading.value = false;
      }
    }
  }

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  // bool validateForm() {
  //   return validateEmail(email.value) == null && validatePassword(password.value) == null;
  // }
  bool validateForm() {
    final emailValidation = validateEmail(emailController.text);
    final passwordValidation = validatePassword(passwordController.text);

    if (emailValidation != null) {
      // Get.snackbar('Error', emailValidation);
      Fluttertoast.showToast(
        msg: emailValidation,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;

    } else if (passwordValidation != null) {
      // Get.snackbar('Error', passwordValidation);
      Fluttertoast.showToast(
        msg: passwordValidation,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return false;
    }

    return true;
  }
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    } else if (!value.isEmail) {
      return 'Please enter a valid email address';
    }
    return null; // Return null when the validation passes
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    } else if (value.length < 6) {
      return 'Password must be of 6 or more characters';
    }
    return null; // Return null when the validation passes
  }



}