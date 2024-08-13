import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import '../constant/constants.dart';

class DashController extends GetxController {
  var isLoading = false.obs;
  var refreshing = false.obs;
  var number = 0.obs;
  var activeSlide = 0.obs;
  var currentLocation = ''.obs;
  var services = [].obs;
  var banner = [].obs;
  var types = [].obs;
  var status = [].obs;
  var modalVisible = false.obs;
  var modalData = [].obs;
  var modalTitle = ''.obs;
  var city = ''.obs;
  var address = ''.obs;
  var page = 0.obs;
  var newAddress = ''.obs;
  var isShowing = false.obs;
  // RxDouble lat = 0.0.obs;
  // RxDouble long = 0.0.obs;
  Timer? locationUpdateTimer;
  bool isUpdatingLocation = false;  // Flag

  StreamSubscription<Position>? positionStreamSubscription;

  @override
  void onInit() {
    // _checkLocationPermission();
    fetchStatusData();
    super.onInit();
    getBanners();
    fetchData();
    fetchServicesData();
    fetchIssues();
  }

  // Future<void> _checkLocationPermission() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;
  //
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //
  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       throw 'Location permissions are denied';
  //     }
  //   }
  //   if (permission == LocationPermission.deniedForever) {
  //     throw 'Location permissions are permanently denied, we cannot request permissions.';
  //   }
  //   Position position = await Geolocator.getCurrentPosition(
  //       desiredAccuracy: LocationAccuracy.bestForNavigation);
  //     print("Current position called");
  //     update();
  //     lat.value = position.latitude;
  //     long.value = position.longitude;
  //     updateUserLocation(position.latitude, position.longitude);
  //     print("current lat ${lat}");
  //     print("current Long $long");
  //
  //   Workmanager().registerPeriodicTask(
  //       "3",
  //       "locationTask",
  //       frequency: Duration(minutes: 2), existingWorkPolicy: ExistingWorkPolicy.append
  //   );
  //
  //
  //
  //   // Cancel the existing timer if it exists
  //   locationUpdateTimer?.cancel();
  //   SharedPreferences prefs=await SharedPreferences.getInstance();
  //   final SupervisorId = prefs.getString('SupervisorId');
  //   // Initialize the periodic timer to update the location every 2 minutes
  //   if(SupervisorId==null){
  //     locationUpdateTimer?.cancel();
  //   }else{
  //     locationUpdateTimer = Timer.periodic(Duration(minutes: 2), (timer) async {
  //       if (isUpdatingLocation) return;  // If an update is in progress, skip this call
  //
  //       isUpdatingLocation = true;// Set the flag to indicate the update process has started
  //
  //       if(SupervisorId==null)return;
  //       try {
  //         Position newPosition = await Geolocator.getCurrentPosition(
  //           desiredAccuracy: LocationAccuracy.bestForNavigation,
  //         );
  //
  //         // Update current location variables
  //         lat.value = newPosition.latitude;
  //         long.value = newPosition.longitude;
  //         print("Timer called: updating location");
  //         print("lat ${lat.value}");
  //         print("long ${long.value}");
  //
  //         // Get formatted address asynchronously
  //         await getFormattedAddress1(newPosition.latitude, newPosition.longitude);
  //         print("New address: ${newAddress.value}");
  //         String currentAddress = newAddress.value;
  //
  //         // Update user location with the fetched details
  //         updateUserLocation(newPosition.latitude, newPosition.longitude,);
  //
  //         // Update UI after updating the location
  //         update();
  //       } catch (e) {
  //         print("Error occurred during location update: $e");
  //       } finally {
  //         isUpdatingLocation = false;  // Reset the flag after the update process is complete
  //       }
  //     });
  //   }
  //
  //   update();
  //   isShowing.value = false;
  //
  //
  //   // Timer.periodic(Duration(minutes: 2), (timer) async {
  //   //   Position newPosition = await Geolocator.getCurrentPosition(
  //   //       desiredAccuracy: LocationAccuracy.bestForNavigation);
  //   //
  //   //   // Update current location variables
  //   //   lat.value  = newPosition.latitude;
  //   //   long.value  = newPosition.longitude;
  //   //
  //   //   // Get formatted address asynchronously
  //   //   getFormattedAddress1(newPosition.latitude,newPosition.longitude);
  //   //
  //   //   // Update user location with the fetched details
  //   //   updateUserLocation(newPosition.latitude, newPosition.longitude);
  //   //
  //   //   // Update UI after updating the location
  //   //   update();
  //   // });
  //   //  update();
  // }
  //
  // Future<void> updateUserLocation(double lat, double long) async {
  //   print("Update user Location");
  //   try {
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     final SupervisorId = prefs.getString('SupervisorId');
  //     String url = Constants.LOCATION;
  //
  //     if(SupervisorId==null){
  //       locationUpdateTimer?.cancel();
  //       return;
  //     }else{
  //       Map data = {
  //         'userid': SupervisorId,
  //         'lat': lat,
  //         'log': long,
  //         'address':newAddress.value,
  //         'date_time':new DateTime.now().toString(),
  //       };
  //
  //       final response = await http.post(Uri.parse(url), body: json.encode(data), headers: {
  //         'Content-type': "application/json",
  //       });
  //       print("Update user Location Data: ${data}");
  //       print("URL:$url");
  //       print("Response status code: ${response.statusCode}");
  //       if (response.statusCode == 200) {
  //         print("Location updated");
  //       } else {
  //         print("Location cannot be updated");
  //       }
  //     }
  //   } catch (err) {
  //     print("Error: ${err}");
  //     Get.snackbar(
  //       'Alert',
  //       'Please try again later.',
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }
  //
  // Future<void> getFormattedAddress1(double latitude, double longitude) async {
  //   print("lat $latitude");
  //   print("long $longitude");
  //   final response = await http.get(Uri.parse(
  //       'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${Constants.Google_Map_key}'));
  //
  //   if (response.statusCode == 200) {
  //     var data = json.decode(response.body);
  //     if (data['status'] == 'OK' && data['results'].isNotEmpty) {
  //       var result = data['results'][0];
  //       var formattedAddress = result['formatted_address'];
  //       print("Formatted Address: $formattedAddress");
  //       newAddress.value = formattedAddress;
  //       update();
  //       return formattedAddress;
  //     } else {
  //       print('No results found');
  //     }
  //   } else {
  //     print('Error fetching address');
  //   }
  // }

  Future<void> getBanners() async {
    try {
      final response = await http.get(Uri.parse(Constants.BANNER));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        banner.value = data['data'].where((item) => item['type'] == 'Banner').toList();
      } else {
        print('Failed to load banners');
      }
    } catch (e) {
      print('Error fetching banners: $e');
    }
  }

  Future<void> fetchData() async {
    final servicesData = await fetchServicesData();
    services.value = servicesData;
  }

  Future<List<dynamic>> fetchServicesData() async {
    try {
      final response = await http.get(Uri.parse(Constants.SERVICE));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data['types'];
      } else {
        return [];
      }
    } catch (e) {
      print('Error fetching services data: $e');
      return [];
    }
  }

  Future<void> fetchIssues() async {
    try {
      final response = await http.get(Uri.parse(Constants.ISSUE));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        types.value = data['types'];
      } else {
        print('Failed to load issues');
      }
    } catch (e) {
      print('Error fetching issues: $e');
    }
  }

  Future<void> fetchStatusData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final SupervisorId = prefs.getString('SupervisorId');

      if (SupervisorId != null) {
        final response = await http.get(Uri.parse('${Constants.SUPERVISOR_DATA}/$SupervisorId'));
        if (response.statusCode == 200) {
          var data = json.decode(response.body);
          status.value = data['data'];
          update();
        } else {
          print('Failed to load status data');
        }
      }
    } catch (e) {
      print('Error fetching status data: $e');
    }
  }

  Future<void> onRefresh() async {
    refreshing.value = true;
    await Future.delayed(Duration(seconds: 1));
    onInit();
    refreshing.value = false;
  }

  void updateState(Map<String, dynamic> newData) {
    newData.forEach((key, value) {
      switch (key) {
        case 'isLoading':
          isLoading.value = value;
          break;
        case 'refreshing':
          refreshing.value = value;
          break;
        case 'city':
          city.value = value;
          break;
        case 'address':
          address.value = value;
          break;
        default:
          break;
      }
    });
  }
}
