import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../constant/constants.dart';
import '../../controllers/login_controller/login_controller.dart';
import '../../helper/images.dart';

class LoginScreen extends GetView<LoginController> {
  LoginScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    final LoginController _loginController = Get.put(LoginController());
    return SafeArea(
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle(
          statusBarColor: Color(0xFF2196F3),
          statusBarIconBrightness: Brightness.dark,
        ),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 60.0),
                  Image.asset(
                    ProjectImages.HKBlack,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.198,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 60.0),
                  Text(
                    "WELCOME".tr,textScaleFactor: 1,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D1E25),
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "SIGNINAC".tr,textScaleFactor: 1,
                      style: TextStyle(
                        fontSize: 14,
                        color: Constants.inputColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.0),
                  buildTextField(
                    hintText: 'PLEASE_ENTER_YOUR_EMAIL'.tr,
                    prefixIcon: ProjectImages.mail,
                    controller: _loginController.emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) => controller.email.value = value,
                    validator: (value) => controller.validateEmail(value!),
                  ),
                  SizedBox(height: 20.0),
                  Obx(() =>    buildTextField(
                    hintText: 'PLEASE_ENTER_YOUR_PASSWORD'.tr,
                    prefixIcon: ProjectImages.lock,
                    controller: _loginController.passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: !controller.isPasswordVisible.value,
                    onChanged: (value) => controller.password.value = value,
                    validator: (value) => controller.validatePassword(value),
                    suffixIcon: IconButton(
                      icon: Icon(controller.isPasswordVisible.value
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => controller.togglePasswordVisibility(),
                    ),
                  ),),
                  SizedBox(height: 50.0),
                  MaterialButton(
                    onPressed: () {
                      if (_loginController.validateForm()) {
                        _loginController.login();
                      }
                    },
                    height: 60.0,
                    minWidth: double.infinity,
                    color: Color(0xFF1877cb),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Obx(() => _loginController.isLoading.value
                        ? CircularProgressIndicator(
                      color: Constants.blue,
                    )
                        : Text(
                      'LOGIN'.tr,textScaleFactor: 1,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField({
    required String hintText,
    required String prefixIcon,
    required TextEditingController controller,
    required TextInputType keyboardType,
    required Function(String) onChanged,
    required String? Function(String?)? validator,
    bool obscureText = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Color(0xFFE9ECF2),
        ),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        obscureText: obscureText,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          border: InputBorder.none,
          prefixIcon: Padding(
            padding: EdgeInsets.all(15.0),
            child: Image.asset(
              prefixIcon,
              height: 22,
              width: 22,
            ),
          ),
          suffixIcon: suffixIcon,
          hintStyle: TextStyle(
            color: Color(0xFF000000),
            letterSpacing: 0.3,
          ),
          hintText: hintText,
        ),
      ),
    );
  }
}
