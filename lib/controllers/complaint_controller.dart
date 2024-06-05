import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../constant/constants.dart';
import '../view/screens/invoice_screen.dart';

class ComplaintController extends GetxController {
  List ComplainList = [].obs;
  RxBool isLoading = false.obs;
  var sign = ''.obs;
  var userType = ''.obs;
  var supervisor = ''.obs;
  final commentController = TextEditingController();

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

  getUserType()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final SupervisorId = prefs.getString('SupervisorId');
    final signature = prefs.getString('sign');
    final supervisorType = prefs.getString('userType');
    // userType.value=supervisorType.toString();

    supervisor.value =  supervisorType!;
    sign.value = signature!;

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

  Future<void> GetData(whichScreen, filter) async {
    ComplainList.clear();
    isLoading.value = true;
    print("function got called");
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final SupervisorId = prefs.getString('SupervisorId');
      print("SupervisorId22: $SupervisorId");
      final response = await http.get(
        Uri.parse(('${Constants.SUPERVISOR_DATA}/$SupervisorId')),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['data'] != null) {
          if (whichScreen == "") {
            ComplainList.addAll(responseData['data']);
            update();
          } else {
            // print("response ${responseData['data']}");
            //
            // List<Map<String, dynamic>> filteredList = [];
            // for (var product in responseData['data']) {
            //   // print("product ${product['service_type']}");
            //   print("filter $filter");
            //   if (product['service_type']
            //       .toLowerCase()
            //       .contains(filter.toLowerCase())) {
            //     filteredList.add(product);
            //   }
            // }
            //
            // print("filteredList $filteredList");
            // ComplainList.assignAll(filteredList);
            String filterLower = filter.toLowerCase();
            List<Map<String, dynamic>> responseDataList = List<Map<String, dynamic>>.from(responseData['data']);

            List<Map<String, dynamic>> filteredList = responseDataList
                .where((product) => product['service_type'].toString().toLowerCase().contains(filterLower))
                .toList();

            ComplainList.assignAll(filteredList);
          }
        } else {
          ComplainList = [];
        }

        // ComplainList.addAll(responseData['data']);
        isLoading.value = false;
        update();
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      print("eroror $error");
      Get.snackbar('Error', 'An error occurred. Please try again later.',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  String formatDate(String dateString) {
    final date = DateTime.parse(dateString);
    final day = date.day.toString().padLeft(2, '0');
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final monthIndex = date.month - 1;
    final year = date.year.toString();
    final hour = date.hour > 12
        ? date.hour - 12
        : date.hour == 0
        ? 12
        : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final ampm = date.hour >= 12 ? 'PM' : 'AM';
    return '$day- ${monthNames[monthIndex]}- $year    $hour:$minute $ampm';
  }

  Future<void> handleApprove(String compId, String pdfUrl) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final SupervisorId = prefs.getString('SupervisorId');

      if (SupervisorId == null) {
        Get.snackbar('Error', 'Supervisor ID not found.');
        return;
      }

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

  // void commentBox(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Comment Box'),
  //         content: TextFormField(
  //           controller: commentController,
  //           decoration: InputDecoration(
  //             hintText: 'Enter your comment here',
  //           ),
  //           maxLines: 3,
  //         ),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: Text('Cancel'),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               // Handle the comment submission logic here
  //               String comment = _commentController.text;
  //               print('Comment: $comment');
  //             },
  //             child: Text('Submit'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> comment(compId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final SupervisorId = prefs.getString('SupervisorId');

      if (SupervisorId == null) {
        Get.snackbar('Error', 'Supervisor ID not found.');
        return;
      }

      Map Data={
        'id': SupervisorId,
        'com_id': compId,
        'comment': commentController.text,
        'supervisor': supervisor.value,
      };
      final response = await http.post(Uri.parse(Constants.COMMENT),body:json.encode(Data),headers: {'Content-Type': 'application/json'},);

      print("Response status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        var responseDataJson = jsonDecode(response.body);
        print("Response: $responseDataJson");

        // String? comments = responseDataJson["data"]["pdf_url"];
        // print("Comment--:$comments");
        // N
        Fluttertoast.showToast(msg: 'Save Successfully');

      } else {
        Fluttertoast.showToast(msg: 'Failed to save the comment. Please try again later.');
        Get.snackbar('Error', 'Failed to save the comment. Please try again later.');
      }
    } catch (error) {
      print("Error: $error");
      Get.snackbar(
          'Error', 'Failed to save the comment. Please try again later.');
    }
  }

}
