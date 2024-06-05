import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constant/constants.dart';
import '../../controllers/complaint_controller.dart';
import '../../helper/images.dart';
import '../../widget/cached_network_image.dart';
import 'complaint_details.dart';
import 'edit_profile.dart';

class ComplaintScreen extends StatelessWidget {
  final String whichScreen;
  final String filter;

  const ComplaintScreen(
      {super.key, required this.whichScreen, required this.filter});

  @override
  Widget build(BuildContext context) {
    ComplaintController _controller = Get.put(ComplaintController());
    _controller.getUserType();
    print('what is this value: ${_controller.userType.value}' ?? "");
    print("Which Screen: $whichScreen");
    print("Filter: $filter");
    _controller.GetData(whichScreen, filter);
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 75,
          iconTheme: IconThemeData(color: Colors.white, size: 25, weight: 25),
          centerTitle: true,
          backgroundColor: Constants.blue,
          title: Text(
            "SERVICES".tr,textScaleFactor: 1,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
          ),
        ),
        body: Stack(children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Constants.blue,
          ),
          Positioned(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.vertical(
                  top: Radius.circular(23),
                ),
              ),
              child: Obx(
                () => _controller.isLoading.value
                    ? Center(
                        child: CircularProgressIndicator(color: Constants.blue))
                    : _controller.ComplainList.isEmpty
                        ? Center(
                            child: Text('DATA NOT FOUND'.tr,textScaleFactor: 1,
                                style: TextStyle(fontSize: 15)))
                        : Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: ListView.builder(
                              itemCount: _controller.ComplainList.length,
                              itemBuilder: (context, index) {
                                final complaint =
                                    _controller.ComplainList[index];
                                print("complaint Details $complaint");
                                return GestureDetector(
                                  onTap: () {
                                    if (complaint['status'] != 'completed') {
                                      Get.to(ComplaintListScreenView(
                                          data: complaint['id']));
                                    }
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            left: 10, right: 10, top: 25),
                                        padding: EdgeInsets.only(bottom: 20),
                                        // height: MediaQuery.of(context).size.height * 0.6,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black38,
                                              blurRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 15, horizontal: 10),
                                              width: double.infinity,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.24,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color:
                                                        Constants.THEMECOLOR),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Constants.THEMECOLOR,
                                                    blurStyle: BlurStyle.solid,
                                                  ),
                                                ],
                                                color: Colors.grey.shade300,
                                              ),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                child: cached_network_image(
                                                  image:
                                                      'storage/${complaint['image']}',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 20),
                                              child: Row(
                                                children: [
                                                  Image(
                                                    image: AssetImage(
                                                        ProjectImages.userIcon),
                                                    color: Colors.grey,
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                                  SizedBox(width: 10),
                                                  // Adjust spacing as needed
                                                  Expanded(
                                                      child: Text(
                                                          complaint['name'],textScaleFactor: 1,)),
                                                  complaint['status'] !=
                                                          'completed'
                                                      ? Container(
                                                          alignment:
                                                              Alignment.center,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: _controller
                                                                .getStatusColor(
                                                                    complaint[
                                                                            'status']
                                                                        .toString()),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        (30)),
                                                          ),
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  horizontal:
                                                                      10,
                                                                  vertical: 5),
                                                          child: Text(
                                                            _controller.getStatusText(
                                                                complaint[
                                                                        'status']
                                                                    .toString()),textScaleFactor: 1,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 20),
                                              child: Row(
                                                children: [
                                                  Image(
                                                    image: AssetImage(
                                                        ProjectImages.form),
                                                    color: Colors.grey,
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    complaint['service_type'],textScaleFactor: 1,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 20),
                                              child: Row(
                                                children: [
                                                  Image(
                                                    image: AssetImage(
                                                        ProjectImages.location),
                                                    color: Colors.grey,
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Flexible(
                                                    child: Text(
                                                      complaint['address'],textScaleFactor: 1,
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8, horizontal: 20),
                                              child: Row(
                                                children: [
                                                  Image(
                                                    image: AssetImage(
                                                        ProjectImages.calendar),
                                                    color: Colors.grey,
                                                    width: 25,
                                                    height: 25,
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(_controller.formatDate(
                                                      complaint['created_at']),textScaleFactor: 1,),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            complaint['${_controller.userType.value}'] !=
                                                    'Approved'
                                                ? Row(
                                              mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    MaterialButton(
                                                        onPressed: () {
                                                          _controller.sign == null || _controller.sign.isEmpty
                                                              ? Get.defaultDialog(
                                                                  title: 'Signature not found'.tr,
                                                                  middleText: 'Please add your signature in the profile section'.tr,
                                                                  textConfirm: 'YES'.tr,
                                                                  confirmTextColor:
                                                                      Colors.white,
                                                                  onConfirm: () {
                                                                    Get.back(); // Close the dialog
                                                                    Get.to(
                                                                        EditProfile());
                                                                  },
                                                                )
                                                              : _controller.handleApprove(complaint['id'].toString(), complaint['pdf_url']);
                                                        },
                                                        shape:
                                                            RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                  8.0),
                                                        ),
                                                        height: 60,
                                                        minWidth: context.width / 3,
                                                        textColor: Colors.white,
                                                        color: Color(0xFF388E3C),
                                                        child: Text(
                                                          "APPROVE".tr,textScaleFactor: 1,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                'Jost-Regular',
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 20,
                                                          ),
                                                        ),
                                                      ),
                                                    SizedBox(width: 2),
                                                    MaterialButton(
                                                      onPressed: () {
                                                        _controller.sign == null || _controller.sign.isEmpty
                                                            ? Get.defaultDialog(
                                                          title: 'Signature not found'.tr,
                                                          middleText: 'Please add your signature in the profile section'.tr,
                                                          textConfirm: 'YES'.tr,
                                                          confirmTextColor: Colors.white,
                                                          onConfirm: () {
                                                            Get.back(); // Close the dialog
                                                            Get.to(EditProfile());
                                                          },
                                                        )
                                                            : showDialog(
                                                          context: context,
                                                          builder: (BuildContext context) {
                                                            return AlertDialog(
                                                              title: Text('टिप्पणी बॉक्स',textScaleFactor: 1,),
                                                              content: TextFormField(
                                                                controller:_controller.commentController,
                                                                decoration: InputDecoration(
                                                                  hintText: 'अपनी टिप्पणी दर्ज करें',
                                                                ),
                                                                maxLines: 3,
                                                              ),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  onPressed: () {
                                                                    Navigator.of(context).pop();
                                                                  },
                                                                  child: Text('NO'.tr,textScaleFactor: 1,),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () {
                                                                    // Handle the comment submission logic here

                                                                    String comment = _controller.commentController.text;
                                                                    print('Comment: $comment');
                                                                    _controller.comment(complaint['id'].toString());

Navigator.pop(context);
                                                                  },
                                                                  child: Text('SUBMIT'.tr,textScaleFactor: 1,),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      },
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                      ),
                                                      height: 60,
                                                      minWidth: context.width / 3,
                                                      textColor: Colors.white,
                                                      color: Color(0xFF388E3C),
                                                      child: Text(
                                                        "note".tr,textScaleFactor: 1,
                                                        style: TextStyle(
                                                          fontFamily:
                                                          'Jost-Regular',
                                                          fontWeight:
                                                          FontWeight.w700,
                                                          fontSize: 20,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                                : Padding(
                                                    padding:
                                                        EdgeInsets.all(12.0),
                                                    child: Container(
                                                      height: 60,
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Color(0xFF388E3C),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8.0),
                                                      ),
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        _controller.getStatusText(
                                                            complaint['status']
                                                                .toString()),textScaleFactor: 1,
                                                        style: TextStyle(
                                                          fontFamily:
                                                              'Jost-Regular',
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 20,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
              ),
            ),
          )
        ]));
  }
}
