import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constant/constants.dart';

class MyWorkController extends GetxController {
  var complaintData = <dynamic>[].obs;
  var sign = ''.obs;
  var userType = ''.obs;
  RxBool isLoading=false.obs;

  @override
  void onInit() {
    super.onInit();
    complaintData.clear();
    fetchComplaintData();
  }
  @override
  void onClose(){
    super.onClose();
    complaintData.clear();
  }

  String formatIdWithLeadingZeros(String id) {
    int maxLength = 5; // Maximum length with leading zeros
    return '#LX-' + id.padLeft(maxLength, '0');
  }

  String getStatusText(String status) {
    return status == 'pending' ? 'Pending' :
    status == 'in_progress' ? 'In Progress' :
    status == 'completed' ? 'Completed' :
    status;
  }

  Color getStatusColor(String status) {
    return status == 'pending' ? Colors.red :
    status == 'in_progress' ? Colors.orange :
    status == 'completed' ? Colors.green :
    Colors.black;
  }



  Future<void> fetchComplaintData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final SupervisorId = prefs.getString('SupervisorId');
    final signature = prefs.getString('sign');
    final SupervisorType = prefs.getString('userType');

    sign.value=signature!;
    userType.value=SupervisorType!;
    print("SupervisorId22: $SupervisorId");

    try {
      final response = await http.get(Uri.parse('${Constants.SUPERVISOR_DATA}/$SupervisorId'));
      if (response.statusCode == 200) {
        complaintData.value = json.decode(response.body)['data'];
        isLoading.value = false;
        update();
        print("complaint ${complaintData.value}");
      } else {
        print('Failed to load data: ${response.statusCode}');
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }



}
