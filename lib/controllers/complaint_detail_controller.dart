import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';

import '../constant/constants.dart';
import '../view/screens/invoice_screen.dart';

class ComplaintListScreenController extends GetxController {
  List<File>? _mediaFileList; // Change to File type
  RxList capturedImage = <File>[].obs;
  final ImagePicker picker = ImagePicker();
  final SignatureController signatureController = SignatureController();

  get mediaFileList => _mediaFileList;

  var city = ''.obs;
  var address = ''.obs;
  var zone = ''.obs;
  var state = ''.obs;
  var sign = ''.obs;
  RxString userType = ''.obs;
  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;
  RxBool loading = false.obs;
  RxMap viewComplaint = Map().obs;

  get textControllers => null;


  @override
  void onInit() {
    super.onInit();
    requestLocationPermission();

  }

  var signatures = List<Uint8List?>.filled(1, null, growable: false).obs;

  @override






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

  pickImage(ImageSource source) async {
    XFile? pickedFile = await picker.pickImage(
        source: source, maxHeight: 1800, maxWidth: 1800, imageQuality: 40);
    if (pickedFile != null) {
      final croppedFile = await cropImage(pickedFile.path);
      print("cropped File ${croppedFile!.path}");
      if (croppedFile != null) {
        capturedImage.add(File(croppedFile!.path));
        update();
        // selectedImage.value = ;
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

  showAlertBox(context) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text("select_image".tr,textScaleFactor: 1,),
          content: Text("mandate".tr,textScaleFactor: 1,),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text(
                "CLOSE".tr,textScaleFactor: 1,
                style: TextStyle(color: Colors.blue),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> requestLocationPermission() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      getCurrentLocation();
      print('Location permission granted');
    } else {
      print('Location permission denied');
    }
  }

  void getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    lat.value = position.latitude;
    long.value = position.longitude;
    getFormattedAddress(position.latitude, position.longitude);
  }

  void getFormattedAddress(double latitude, double longitude) async {
    print("lat $latitude");
    print("long $longitude");
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${Constants.Google_Map_key}'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print(" data $data");
      if (data['status'] == 'OK' && data['results'].length > 0) {
        var result = data['results'][0];
        var formattedAddress = result['formatted_address'];
        print("formated Addres $formattedAddress");
        address.value = formattedAddress;
        for (var component in data['results'][0]['address_components']) {
          var types = List<String>.from(component['types']);
          if (types.contains('locality')) {
            city.value = component['long_name'];
          }
          if (types.contains('sublocality_level_1')) {
            zone.value = component['long_name'];
          }
          if (types.contains('administrative_area_level_1')) {
            state.value = component['long_name'];
          }
        }
      } else {
        print('No results found');
      }
    } else {
      print('Error fetching address');
    }
  }

  String formatIdWithLeadingZeros(String id) {
    int maxLength = 5; // Maximum length with leading zeros
    return '#LX-' + id.padLeft(maxLength, '0');
  }

  String getStatusText(String status) {
    return status == 'pending'
        ? 'Pending'.tr
        : status == 'in_progress'
            ? 'In Progress'.tr
            : status == 'completed'
                ? 'Completed'.tr
                : status;
  }

  Color getStatusColor(String status) {
    return status == 'pending'
        ? Colors.red
        : status == 'in_progress'
            ? Colors.orange
            : status == 'completed'
                ? Colors.green
                : Colors.black;
  }

  Future<File> _resizeImage(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final image = img.decodeImage(bytes);
    final resizedImage =
        img.copyResize(image!, width: 800); // Resize width to 800px
    final resizedImageFile = File(imageFile.path);
    await resizedImageFile.writeAsBytes(img.encodeJpg(resizedImage));
    return resizedImageFile;
  }

  // Compress image function
  Future<List<int>> compressImage(File file) async {
    // Read image file
    var bytes = await file.readAsBytes();

    // Decode image
    img.Image? image = img.decodeImage(bytes);

    // Resize image
    img.Image resizedImage = img.copyResize(image!, width: 500);

    // Encode resized image to JPEG
    List<int> compressedBytes = img.encodeJpg(resizedImage, quality: 85);

    return compressedBytes;
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

  Future<void> handleApprove(String compId, String pdfUrl) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final SupervisorId = prefs.getString('SupervisorId');

      if (SupervisorId == null) {
        Get.snackbar('Error', 'Supervisor ID not found.');
        return;
      }
      // data['${userType.value}'] = 'Approved';
      Map Data={
        'id': SupervisorId,
        'comp_id': compId,
      };
      final response = await http.post(Uri.parse(Constants.SUPERVISOR_APPROVED),body:json.encode(Data),headers: {'Content-Type': 'application/json'},);

      print("Response status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseDataJson = jsonDecode(response.body);
        print("Response: $responseDataJson");

        String? pdfUrl = responseDataJson["data"]["pdf_url"];
        if (pdfUrl != null) {
          Get.to(InVoiceView(InvoiceUrl: pdfUrl));
        } else {
          Fluttertoast.showToast(msg: 'PDF URL not found in response.');
          Get.snackbar('Error', 'PDF URL not found in response.');
        }
      } else {
        Fluttertoast.showToast(msg: 'Failed to approve supervisor. Please try again later.');
        Get.snackbar('Error', 'Failed to approve supervisor. Please try again later.');
      }
    } catch (error) {
      print("Error: $error");
      Get.snackbar(
          'Error', 'Failed to approve supervisor. Please try again later.');
    }
  }

  Future<void> viewComplaintData(String compId) async {
    loading.value=true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final SupervisorId = prefs.getString('SupervisorId');
    final signature = prefs.getString('sign');
    final supervisorType = prefs.getString('userType');
    // print("SupervisorId1111: $SupervisorId");
   print("complaint id$compId");
    try {
      final response = await http.get(Uri.parse('${Constants.COMPLAINT}/$compId'));
      if (response.statusCode == 200) {
        viewComplaint.value = json.decode(response.body)['data'][0];
        loading.value = false;
        update();
        print("view complaint ${viewComplaint.value}");
      } else {
        print('Failed to load data: ${response.statusCode}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  getUserType()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final SupervisorId = prefs.getString('SupervisorId');
    final signature = prefs.getString('sign');
    final supervisorType = prefs.getString('userType');
    sign.value = signature!;

    // userType.value=supervisorType.toString();
    String user = '';
    switch (supervisorType) {
      case 'supervisor1':
        user = 'supervisor_1';
        break;
      case 'supervisor2':
        user = 'supervisor_2';
        break;
      case 'supervisor3':
        user = 'supervisor_3';
        break;
      default:
        Get.snackbar('Error', 'Invalid user type.');
        return;
    }

    userType.value=user;
    print("userType ${userType.value}");
    update();
  }
}
