import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
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
  RxDouble lat = 0.0.obs;
  RxDouble long = 0.0.obs;

  StreamSubscription<Position>? positionStreamSubscription;

  @override
  void onInit() {
    fetchStatusData();
    super.onInit();
    getBanners();
    fetchData();
    fetchServicesData();
    fetchIssues();
    _checkLocationPermission();
  }

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied';
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw 'Location permissions are permanently denied, we cannot request permissions.';
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
      print("Current position called");
      update();
      lat.value = position.latitude;
      long.value = position.longitude;
      updateUserLocation(position.latitude, position.longitude);
      print("current lat ${lat}");
      print("current Long $long");
     update();
  }

  Future<void> updateUserLocation(double lat, double long) async {
    print("Update user Location");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final SupervisorId = prefs.getString('SupervisorId');
      String url = Constants.LOCATION;

      Map data = {
        'userid': SupervisorId,
        'lat': lat,
        'log': long,
        'address':newAddress.value,
      };

      final response = await http.post(Uri.parse(url), body: json.encode(data), headers: {
        'Content-type': "application/json",
      });
      print("URL:$url");
      print("Response status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        print("Location updated");
      } else {
        print("Location cannot be updated");
      }
    } catch (err) {
      print(err);
    }
  }

  Future<void> getFormattedAddress1(double latitude, double longitude) async {
    print("lat $latitude");
    print("long $longitude");
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${Constants.Google_Map_key}'));

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['status'] == 'OK' && data['results'].isNotEmpty) {
        var result = data['results'][0];
        var formattedAddress = result['formatted_address'];
        print("Formatted Address: $formattedAddress");
        newAddress.value = formattedAddress;
      } else {
        print('No results found');
      }
    } else {
      print('Error fetching address');
    }
  }

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
