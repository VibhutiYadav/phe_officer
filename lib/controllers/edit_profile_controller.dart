import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';

import '../constant/constants.dart';
import '../view/screens/bottom_navigaton.dart';
import '../view/screens/login_screen.dart';

class EditProfileController extends GetxController {
  final SignatureController signatureController = SignatureController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String imagepick = '';

  var isload = false.obs;
  var signatures = List<Uint8List?>.filled(1, null, growable: false).obs;

  @override
  void onInit() {
    super.onInit();
    getdata();
  }

  @override
  void onClose() {
    // Clear the list of signatures when the controller is closed
    signatures.clear();
    signatures = List<Uint8List?>.filled(1, null, growable: false).obs;
    super.onClose();
  }

  void updateSignature(int index, Uint8List signature) {
    print("Signature updated at index $index");
    print("Signature updated at index $signature");
    if (index == 0) {
      signatures[index] = signature;
      update();

      print("signature list ${signatures}");
    } else {
      print("Invalid index: $index");
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all shared preferences
    Get.offAll(LoginScreen());
  }

  Future<bool> showExitConfirmationDialog(BuildContext context) async {
    return await showDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: Text('बाहर निकलने की पुष्टि करें',textScaleFactor: 1,),
            content: Text('क्या आप वाकई ऐप से बाहर निकलना चाहते हैं?',textScaleFactor: 1,),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('नहीं',textScaleFactor: 1,),
              ),
              TextButton(
                onPressed: () => logout(context),
                child: Text('हां',textScaleFactor: 1,),
              ),
            ],
          ),
        ) ??
        false;
  }


  final ImagePicker picker = ImagePicker();
  RxString selectedImage = ''.obs;

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(
        source: source, maxHeight: 1800, maxWidth: 1800, imageQuality: 40);
    if (pickedFile != null) {
      final croppedFile = await cropImage(pickedFile.path);
      print("cropped File ${croppedFile!.path}");
      if (croppedFile != null) {
        imageget.value = '';
        selectedImage.value = croppedFile.path;

        update();
        print("Selected Image:${selectedImage.value}");
      }
    }
  }

  Future<CroppedFile?> cropImage(String imagePath) async {
    return await ImageCropper().cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Constants.darkblue,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(
          title: 'Crop Image',
        ),
      ],
    );
  }

  openBottomSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          actions: [
            Material(
              color: Colors.transparent,
              child: CupertinoActionSheetAction(
                onPressed: () {
                  // Capture from Camera
                  pickImage(ImageSource.camera);
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.camera,
                      color: CupertinoColors.black,
                    ),
                    SizedBox(width: 12.0),
                    Text(
                      'Capture from Camera',textScaleFactor: 1,
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: CupertinoActionSheetAction(
                onPressed: () {
                  // Pick from Gallery
                  pickImage(ImageSource.gallery);
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.photo,
                      color: CupertinoColors.black,
                    ),
                    SizedBox(width: 12.0),
                    Text(
                      'Pick from Gallery',textScaleFactor: 1,
                      style: TextStyle(
                        color: CupertinoColors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              // Cancel
              Navigator.pop(context); // Close the bottom sheet
            },
            child: Text(
              'Cancel',textScaleFactor: 1,
              style: TextStyle(
                color: CupertinoColors.systemBlue,
                fontSize: 16.0,
              ),
            ),
          ),
        );
      },
    );
  }

  var name = ''.obs;
  var email = ''.obs;
  var imageget = ''.obs;
  var number = ''.obs;
  RxString sign = ''.obs;

  Future<void> getdata() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name.value = prefs.get('SupervisorName').toString();
    email.value = prefs.get('email').toString();
    imageget.value = prefs.get('image').toString();
    sign.value = prefs.get('sign').toString();
    number.value = prefs.get('phone').toString();
    // selectedImage.value = prefs.get('profile').toString();
    nameController.text = name.value;
    emailController.text = email.value;
    mobileNumberController.text = number.value;
  }

  Future<void> editProfileWithoutImageAndSign() async {
    try {
      print("Edit Profile Without Image And Sign Is Called...");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final SupervisorId = prefs.getString('SupervisorId');

      if (SupervisorId == null) {
        print('User ID not found');
        return;
      }
      var signatureField = 'sign';
      print('SupervisorId33: $SupervisorId');
      print('mobileNumberController: ${mobileNumberController.text.trim()}');
      print('nameController: ${nameController.text.trim()}');
      print('imagepick: $imagepick');

      Map Data={
        'name':nameController.text.trim(),
        'userid': SupervisorId,
        'phone':mobileNumberController.text.trim(),
      };

      final response =await http.post(Uri.parse(Constants.UPDATE_PROFILE),body:json.encode(Data),headers: {'Content-Type': 'application/json'},);

      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Profile updated successfully');

        final ResponseData = json.decode(response.body);
        prefs.setString("phone",ResponseData['data']['phone_number']??"");
        prefs.setString("UserName",ResponseData['data']['name']??"");
        prefs.setString("image",ResponseData['data']['profile']??"");
        prefs.setString("sign",ResponseData['data']['sign']??"");
        isload.value = false;
        getdata();
        Get.offAll(BottomNavigation());
      } else {
        print('Request failed with status: ${response.statusCode}');
        Fluttertoast.showToast(msg: 'Something went wrong!');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> editProfileWithoutImage() async {
    try {
      print("Edit Profile Without Image Is Called...");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final SupervisorId = prefs.getString('SupervisorId');

      if (SupervisorId == null) {
        print('User ID not found');
        return;
      }
      var signatureField = 'sign';
      print('SupervisorId33: $SupervisorId');
      print('mobileNumberController: ${mobileNumberController.text.trim()}');
      print('nameController: ${nameController.text.trim()}');
      print('imagepick: $imagepick');

      var request = http.MultipartRequest('POST', Uri.parse(Constants.UPDATE_PROFILE),);

      request.fields['userid'] = SupervisorId;
      request.fields['phone_number'] = mobileNumberController.text.trim();
      request.fields['name'] = nameController.text.trim();

      var multipartFile = http.MultipartFile.fromBytes(
        signatureField,
        signatures[0] as List<int>,
        filename: 'test.png',
      );
      request.files.add(multipartFile);

      print("Signature field:${signatureField}");
      print("Request fields: ${request.fields}");
      print("Request files: ${request.files}");

      http.StreamedResponse response = await request.send();

      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Profile updated successfully');
        String responseBody = await response.stream.bytesToString();
        final ResponseData = json.decode(responseBody);
        prefs.setString("phone",ResponseData['data']['phone_number']??"");
        prefs.setString("UserName",ResponseData['data']['name']??"");
        prefs.setString("image",ResponseData['data']['profile']??"");
        prefs.setString("sign",ResponseData['data']['sign']??"");
        isload.value = false;
        getdata();
        Get.offAll(BottomNavigation());
      } else {
        print('Request failed with status: ${response.statusCode}');
        Fluttertoast.showToast(msg: 'Something went wrong!');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> editProfileWithoutSign() async {
    try {
      print("Edit Profile Without Sign Is Called...");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final SupervisorId = prefs.getString('SupervisorId');

      if (SupervisorId == null) {
        print('User ID not found');
        return;
      }
      var signatureField = 'sign';
      print('SupervisorId33: $SupervisorId');
      print('mobileNumberController: ${mobileNumberController.text.trim()}');
      print('nameController: ${nameController.text.trim()}');
      print('imagepick: $imagepick');

      var request = http.MultipartRequest('POST', Uri.parse(Constants.UPDATE_PROFILE),);

      request.fields['userid'] = SupervisorId;
      request.fields['phone_number'] = mobileNumberController.text.trim();
      request.fields['name'] = nameController.text.trim();
      request.files.add(await http.MultipartFile.fromPath('profile', selectedImage.value));

      print("Signature field:${signatureField}");
      print("Request fields: ${request.fields}");
      print("Request files: ${request.files}");

      http.StreamedResponse response = await request.send();

      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Profile updated successfully');
        String responseBody = await response.stream.bytesToString();
        final ResponseData = json.decode(responseBody);
        prefs.setString("phone",ResponseData['data']['phone_number']??"");
        prefs.setString("UserName",ResponseData['data']['name']??"");
        prefs.setString("image",ResponseData['data']['profile']??"");
        prefs.setString("sign",ResponseData['data']['sign']??"");
        isload.value = false;
        getdata();
        Get.offAll(BottomNavigation());
      } else {
        print('Request failed with status: ${response.statusCode}');
        Fluttertoast.showToast(msg: 'Something went wrong!');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> editProfile() async {
    try {
      print("Edit Profile Is Called...");
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final SupervisorId = prefs.getString('SupervisorId');

      if (SupervisorId == null) {
        print('User ID not found');
        return;
      }
      var signatureField = 'sign';
      print('SupervisorId33: $SupervisorId');
      print('mobileNumberController: ${mobileNumberController.text.trim()}');
      print('nameController: ${nameController.text.trim()}');
      print('imagepick: $imagepick');

      var request = http.MultipartRequest('POST', Uri.parse(Constants.UPDATE_PROFILE),);

      request.fields['userid'] = SupervisorId;
      request.fields['phone_number'] = mobileNumberController.text.trim();
      request.fields['name'] = nameController.text.trim();
      var multipartFile = http.MultipartFile.fromBytes(
        signatureField,
        signatures[0] as List<int>,
        filename: 'test.png',
      );
      request.files.add(multipartFile);
      request.files.add(await http.MultipartFile.fromPath('profile', selectedImage.value));

      print("Signature field:${signatureField}");
      print("Request fields: ${request.fields}");
      print("Request files: ${request.files}");

      http.StreamedResponse response = await request.send();
      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Profile updated successfully');
        String responseBody = await response.stream.bytesToString();
        final ResponseData = json.decode(responseBody);
        prefs.setString("phone",ResponseData['data']['phone_number']??"");
        prefs.setString("UserName",ResponseData['data']['name']??"");
        prefs.setString("image",ResponseData['data']['profile']??"");
        prefs.setString("sign",ResponseData['data']['sign']??"");
        isload.value = false;
        Get.offAll(BottomNavigation());
      } else {
        print('Request failed with status: ${response.statusCode}');
        Fluttertoast.showToast(msg: 'Something went wrong!');
      }
    } catch (e) {
      print('Error: $e');
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  String getSignatureMapList() {
    List<Map<String, dynamic>> signatureMapList = [];
    String signatureBase64 = '';
    Uint8List? signatureBytes = signatures[0];
    // String name = textControllers[0].text;

    if (signatureBytes != null) {
      signatureBase64 = base64Encode(signatureBytes);
    }
    return signatureBase64;
  }
}
