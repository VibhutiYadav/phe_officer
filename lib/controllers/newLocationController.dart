
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:background_locator_2/background_locator.dart';
import 'package:background_locator_2/location_dto.dart';
import 'package:background_locator_2/settings/ios_settings.dart';
import 'package:background_locator_2/settings/android_settings.dart' as ad;
import 'package:background_locator_2/settings/locator_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart' as gl;

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../constant/constants.dart';
@pragma('vm:entry-point')
void callback(LocationDto locationDto) async {
  // final dir = await getApplicationDocumentsDirectory();
  // final file = File('${dir.path}/location.txt');
  // await file.writeAsString(
  //   '${DateTime.now()}: ${locationDto.latitude}, ${locationDto.longitude}\n',
  //   mode: FileMode.append,
  // );
  final SendPort? send = IsolateNameServer.lookupPortByName("LocatorIsolate");
  send?.send(locationDto);
  String currentAddress=await getFormattedAddress1(locationDto.latitude,locationDto.longitude);



  updateUserLocation(locationDto.latitude,locationDto.longitude,currentAddress);
  print("lat long${DateTime.now()}: ${locationDto.latitude}, ${locationDto
      .longitude}\n");
}



updateUserLocation(double lat, double long, String currentAddress) async {
  // await Future.delayed(Duration(seconds: 120));

  try {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userId = await prefs.getString('SupervisorId');
    String Url = '${Constants.BASE_URL}emp_location';
    if (userId == null) {
      // locationUpdateTimer?.cancel();
      return;
    }
    else {
      Map data = {
        'user_id': userId,
        'lat': lat,
        'log': long,
        'address': currentAddress,
        'date_time': new DateTime.now().toString(),
      };
      print("data ${data}");
      // print("data of loction $data");
      final response = await http.post(
          Uri.parse(Url), body: json.encode(data), headers: {
        'Content-type': "application/json"
      });
      if (response.statusCode == 200) {
        print("Location updated");
      }
      else {
        print("locatino cannont be updated");
      }
    }
  }
  catch (er) {
    print("errrorr $er");
    Get.snackbar(
      'Alert',
      'Please try again later.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

// getFormattedAddress1(double latitude, double longitude) async {
//   print("lat $latitude");
//   print("long $longitude");
//   final response = await http.get(Uri.parse(
//       'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${Constants
//           .Google_Map_key}'));
//   if (response.statusCode == 200) {
//     var data = json.decode(response.body);
//     // print("api  data $data");
//     if (data['status'] == 'OK' && data['results'].length > 0) {
//       var result = data['results'][0];
//       var formattedAddress = result['formatted_address'];
//       // / print("formated Addres $formattedAddress");
//       // address.value = formattedAddress;
//       // newAddress.value = formattedAddress;
//       // update();
//       return formattedAddress;
//
//       // for (var component in data['results'][0]['address_components']) {
//       //   var types = List<String>.from(component['types']);
//       //   if (types.contains('locality')) {
//       //     city.value = component['long_name'];
//       //   }
//       //   if (types.contains('sublocality_level_1')) {
//       //     zone.value = component['long_name'];
//       //   }
//       //   if (types.contains('administrative_area_level_1')) {
//       //     state.value = component['long_name'];
//       //   }
//       // }
//     } else {
//       print('No results found');
//     }
//   } else {
//     print('Error fetching address');
//   }
// }

getGoogleMapApi()async{
  try{
    var response=await http.get(Uri.parse('${Constants.BASE_URL}map_key'));
    print("response of google map api${response.statusCode}");

    var data=json.decode(response.body);
    print("response of google map api${data["map_key"]["value"]}");
    Constants.Google_Map_key=data["map_key"]["value"];
    return data["map_key"]["value"];
  }
  catch(err){
    print(err.toString);
  }
}



getFormattedAddress1(double latitude, double longitude) async {
  print("lat $latitude");
  print("long $longitude");
  String map_api='';
  if(Constants.Google_Map_key == "" || Constants.Google_Map_key == null){
    map_api=await getGoogleMapApi();
  }
  else {
    map_api=Constants.Google_Map_key;
  }
  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${map_api}'));
  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    // print("api  data $data");
    if (data['status'] == 'OK' && data['results'].length > 0) {
      var result = data['results'][0];
      var formattedAddress = result['formatted_address'];
      // / print("formated Addres $formattedAddress");
      // address.value = formattedAddress;
      // newAddress.value = formattedAddress;
      // update();
      return formattedAddress;

      // for (var component in data['results'][0]['address_components']) {
      //   var types = List<String>.from(component['types']);
      //   if (types.contains('locality')) {
      //     city.value = component['long_name'];
      //   }
      //   if (types.contains('sublocality_level_1')) {
      //     zone.value = component['long_name'];
      //   }
      //   if (types.contains('administrative_area_level_1')) {
      //     state.value = component['long_name'];
      //   }
      // }
    } else {
      print('No results found');
    }
  } else {
    print('Error fetching address');
  }
}
class LocationController extends GetxController with WidgetsBindingObserver {

  var locationEnabled = false.obs;
  var locationPermissionGranted = false.obs;
  var isUpdatingLocation = false;
  Timer? locationUpdateTimer;
  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;
  RxString newAddress = ''.obs;RxString _appState=''.obs;
  var isShowing = false.obs;
  RxString userID=''.obs;
  static const String _isolateName = "LocatorIsolate";
  ReceivePort port = ReceivePort();
  RxString PermissionGiven=''.obs;
  @override
  void onInit() async{
   await  checkAndRequestPermission();
   await  BackgroundLocator.initialize();
    super.onInit();
    // IsolateNameServer.registerPortWithName(port.sendPort, _isolateName);
    // port.listen((dynamic data) {
    //   // Handlestatic const String _isolateName = "LocatorIsolate";
    //   //   ReceivePort port = ReceivePort(); location data received from background isolate
    //   print('Location update received: $data');
    // });

    // initLoca/tionService();
  }

  // Future<void> initLocationService() async {
  //
  //   await checkAndRequestPermission();
  //   // await checkAndEnableLocationService();
  // }

  // Future<void> checkAndRequestPermission() async {
  //   var status = await Permission.location.request();
  //   if (status == PermissionStatus.granted) {
  //     locationEnabled.value = true;
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     var userId = prefs.getString('UserId');
  //     if (userId != null) {
  //
  //       userID.value=userId;
  //       // startBackgroundLocationUpdates();
  //       startLocationService();
  //     }
  //   }
  //   else {
  //     locationEnabled.value = false;
  //     await gl.Geolocator.openLocationSettings();
  //   }
  //   update();
  // }



  Future<void> checkAndRequestPermission() async {
    print("func called");
    bool serviceEnabled;
    // serviceEnabled = await gl.Geolocator.isLocationServiceEnabled();
    gl.LocationPermission permission = await gl.Geolocator.checkPermission();

    if (permission == gl.LocationPermission.denied || permission == gl.LocationPermission.deniedForever) {
      permission = await gl.Geolocator.requestPermission();
      if (permission == gl.LocationPermission.always || permission == gl.LocationPermission.whileInUse) {
        locationPermissionGranted.value = true;
        if(permission==gl.LocationPermission.always){
          PermissionGiven.value='always';
        }

        await checkAndEnableLocationService();
      } else {
        await gl.Geolocator.openLocationSettings();
      }
    } else if (permission == gl.LocationPermission.always || permission == gl.LocationPermission.whileInUse) {
      locationPermissionGranted.value = true;
      if(permission==gl.LocationPermission.always){
        PermissionGiven.value='always';
      }
      await checkAndEnableLocationService();
    }
    else{
      SystemNavigator.pop();
    }

    update();
  }
  Future<void> checkAndEnableLocationService() async {
    bool isLocationServiceEnabled = await gl.Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      await gl.Geolocator.openLocationSettings();
      // Optionally, you can keep checking if the location service is enabled
      // and prompt the user again if it's still not enabled.
    }
    // await gl.Geolocator.openLocationSettings();
  }

   Future<void> startLocationService() async {
     await  BackgroundLocator.initialize();
     print("functions called");
    await BackgroundLocator.registerLocationUpdate(
      callback,
      autoStop: false,
      iosSettings: IOSSettings(
        accuracy: LocationAccuracy.NAVIGATION,
        distanceFilter: 100,
      ),
      androidSettings: ad.AndroidSettings(
        accuracy: LocationAccuracy.BALANCED,
        interval: 30,
        distanceFilter: 100,
      ),
    );


  }
   updateUserLocation(double lat, double long, String currentAddress) async {
    // await Future.delayed(Duration(seconds: 120));

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = await prefs.getString('SupervisorId');
      String Url = '${Constants.BASE_URL}emp_location';
      if (userId == null) {
        // locationUpdateTimer?.cancel();
        return;
      }
      else {
        Map data = {
          'user_id': userId,
          'lat': lat,
          'log': long,
          'address': newAddress.value,
          'date_time': new DateTime.now().toString(),
        };
        print("data ${data}");
        // print("data of loction $data");
        final response = await http.post(
            Uri.parse(Url), body: json.encode(data), headers: {
          'Content-type': "application/json"
        });
        if (response.statusCode == 200) {
          print("Location updated");
        }
        else {
          print("locatino cannont be updated");
        }
      }
    }
    catch (er) {
      print("errrorr $er");
      Get.snackbar(
        'Alert',
        'Please try again later.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  getFormattedAddress1(double latitude, double longitude) async {
    print("lat $latitude");
    print("long $longitude");
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${Constants
            .Google_Map_key}'));
    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      // print("api  data $data");
      if (data['status'] == 'OK' && data['results'].length > 0) {
        var result = data['results'][0];
        var formattedAddress = result['formatted_address'];
        // / print("formated Addres $formattedAddress");
        // address.value = formattedAddress;
        newAddress.value = formattedAddress;
        update();
        return formattedAddress;

        // for (var component in data['results'][0]['address_components']) {
        //   var types = List<String>.from(component['types']);
        //   if (types.contains('locality')) {
        //     city.value = component['long_name'];
        //   }
        //   if (types.contains('sublocality_level_1')) {
        //     zone.value = component['long_name'];
        //   }
        //   if (types.contains('administrative_area_level_1')) {
        //     state.value = component['long_name'];
        //   }
        // }
      } else {
        print('No results found');
      }
    } else {
      print('Error fetching address');
    }
  }
  // Callback for receiving location updates from background isolate

showAlert(){
   return       Get.dialog(
        AlertDialog(
          title: Text("पृष्ठभूमि स्थान अनुमति"),
          content: Text('हम हैंडपंप के रखरखाव के लिए जिम्मेदार उपयोगकर्ता या इंजीनियर को कुशलतापूर्वक ट्रैक करने के लिए पृष्ठभूमि स्थान तक पहुंच रहे हैं। यह किसी भी रखरखाव की आवश्यकता या उत्पन्न होने वाली आपात स्थिति के लिए समय पर और प्रभावी प्रतिक्रिया सुनिश्चित करता है। पृष्ठभूमि में स्थान की निगरानी करके, जब भी आवश्यकता हो, हम सहायता और सहायता प्रदान कर सकते हैं, जिससे उस समुदाय के लिए हैंडपंप की विश्वसनीयता और कार्यक्षमता में वृद्धि हो सकती है।.'),
          actions: [
            TextButton(
              onPressed: () async {
                (PermissionGiven.value=='always')? Get.back():gl.Geolocator.openAppSettings();
                await  checkAndRequestPermission();
                Get.back();
                update();


              },
              child: Text('OK'),
            ),
          ],
        ),
      );
}

}



