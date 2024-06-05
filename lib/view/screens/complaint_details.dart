import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handpump_supervisor/view/screens/invoice_screen.dart';

import '../../constant/constants.dart';
import '../../controllers/complaint_detail_controller.dart';
import '../../widget/app_bar.dart';
import '../../widget/cached_network_image.dart';
import '../../widget/common_column.dart';
import '../../widget/video_player.dart';
import 'edit_profile.dart';

class ComplaintListScreenView extends GetView<ComplaintListScreenController> {
  int? data;

  // final dynamic data;

  ComplaintListScreenView({Key? key, required this.data}) : super(key: key);

  final ComplaintListScreenController _complaintListScreenController = ComplaintListScreenController();

  @override
  Widget build(BuildContext context) {
    _complaintListScreenController.getUserType();
    _complaintListScreenController.viewComplaintData(data.toString());
    print('what is this value:--- ${_complaintListScreenController.userType.value}' ?? "");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.width / 5,
        ),
        child: AppbarCommon(
          heading: 'COMPAINT_DESCRIP'.tr,
          enable: true,
        ),
      ),
      body: Stack(
        children: [
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
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(23),
                ),
              ),
              child: Obx(()=>
              (_complaintListScreenController.loading.value)?
              Center(child: CircularProgressIndicator(color: Constants.blue,),)

                  :
                 Container(
                  padding: EdgeInsets.all(8.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        commoncolumn(
                          title: "id".tr,
                          data: _complaintListScreenController
                              .formatIdWithLeadingZeros(_complaintListScreenController.viewComplaint.value['id'].toString()),
                          type: "text",
                        ),
                        commoncolumn(
                          title: "STATUS".tr,
                          data: _complaintListScreenController
                              .getStatusText(_complaintListScreenController.viewComplaint.value['status'].toString()),
                          type: "text",
                        ),
                        commoncolumn(
                          title: "Date".tr,
                          data: _complaintListScreenController.viewComplaint.value['service_date'] == null
                              ? "-"
                              : _complaintListScreenController.viewComplaint.value['service_date'].toString(),
                          type: "text",
                        ),
                        commoncolumn(
                          title: "Due".tr,
                          data: _complaintListScreenController.viewComplaint.value['due_date'] == null
                              ? "-"
                              : _complaintListScreenController.viewComplaint.value['due_date'].toString(),
                          type: "text",
                        ),
                        commoncolumn(
                          title: "NAME".tr,
                          data: _complaintListScreenController.viewComplaint.value['client'] == null
                              ? "-"
                              : _complaintListScreenController.viewComplaint.value['client'].toString(),
                          type: "text",
                        ),
                        commoncolumn(
                          title: "PHONE".tr,
                          data: _complaintListScreenController.viewComplaint.value['phone'] == null
                              ? "-"
                              : _complaintListScreenController.viewComplaint.value['phone'].toString(),
                          type: "text",
                        ),
                        commoncolumn(
                          title: "Assign".tr,
                          data: _complaintListScreenController.viewComplaint.value['assign'] == null
                              ? "-"
                              : _complaintListScreenController.viewComplaint.value['assign'].toString(),
                          type: "text",
                        ),
                        commoncolumn(
                          title: "CATEGORY".tr,
                          data: _complaintListScreenController.viewComplaint.value['category'] == null
                              ? "-"
                              : _complaintListScreenController.viewComplaint.value['category'].toString(),
                          type: "text",
                        ),
                        commoncolumn(
                          title: "SERVICE_TYPE".tr,
                          data: _complaintListScreenController.viewComplaint.value['service'] == null
                              ? "-"
                              : _complaintListScreenController.viewComplaint.value['service'].toString(),
                          type: "text",
                        ),
                        commoncolumn(
                          title: "service_type".tr,
                          data: _complaintListScreenController.viewComplaint.value['service_type'] == null
                              ? "-"
                              : _complaintListScreenController.viewComplaint.value['service_type'].toString(),
                          type: "text",
                        ),
                        commoncolumn(
                          title: "ADDRESS".tr,
                          data: _complaintListScreenController.viewComplaint.value['address'] == null
                              ? "-"
                              : _complaintListScreenController.viewComplaint.value['address'].toString(),
                          type: "text",
                        ),
                        commoncolumn(
                          title: "CITY".tr,
                          data: _complaintListScreenController.viewComplaint.value['p_city'] == null
                              ? "-"
                              : _complaintListScreenController.viewComplaint.value['p_city'].toString(),
                          type: "text",
                        ),
                        commoncolumn(
                          title: "note".tr,
                          data: _complaintListScreenController.viewComplaint.value['notes'] == null
                              ? "NOTFOUND".tr
                              : _complaintListScreenController.viewComplaint.value['notes'].toString(),
                          type: "text",
                        ),
                        commoncolumn(
                          title: "Image".tr,
                          data: _complaintListScreenController.viewComplaint.value['image'] == null
                              ? "-"
                              : _complaintListScreenController.viewComplaint.value['image'].toString(),
                          type: "image",
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "Video".tr,
                              style: TextStyle(
                                color: Colors.black87,
                                fontSize:
                                    MediaQuery.of(context).size.height * 0.02,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        (_complaintListScreenController.viewComplaint.value['work_video'] != null &&
                                _complaintListScreenController.viewComplaint.value['work_video'].isNotEmpty)
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 1),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height:
                                        MediaQuery.of(context).size.height * 0.20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: AspectRatio(
                                        aspectRatio: 9 / 16,
                                        child: (_complaintListScreenController.viewComplaint.value['work_video'] != null &&
                                                _complaintListScreenController.viewComplaint.value['work_video'].isNotEmpty)
                                            ? VideoPlayerScreen(
                                                // videoPath: "https://www.youtube.com/watch?v=N_lC9sTYo7E",
                                                videoPath: _complaintListScreenController.viewComplaint.value['work_video'],
                                              )
                                            : Center(
                                                child: Text(
                                                  "Video not found".tr,
                                                  style: TextStyle(
                                                    fontFamily: 'Jost-Regular',
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.black38,
                                                  ),
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 1),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: AspectRatio(
                                  aspectRatio: 9 / 16,
                                  child: (_complaintListScreenController.viewComplaint.value['work_image'] != null &&
                                          _complaintListScreenController.viewComplaint.value['work_image'].isNotEmpty)
                                      ? cached_network_image(
                                          image: 'storage/${_complaintListScreenController.viewComplaint.value['work_image']}',
                                          fit: BoxFit.cover,
                                        )
                                      : Center(
                                          child: Text(
                                            "Image not found".tr,
                                            style: TextStyle(
                                              fontFamily: 'Jost-Regular',
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black38,
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.withOpacity(0.2),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.white54,
                                  offset: Offset(0, 1),
                                  // blurRadius: 2,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Container(
                                width: double.infinity,
                                // height: MediaQuery.of(context).size.height * 0.20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(),
                                ),
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 8, right: 8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "NAME".tr,
                                                style: TextStyle(
                                                  fontFamily: 'Jost-Regular',
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                "Quantity".tr,
                                                style: TextStyle(
                                                  fontFamily: 'Jost-Regular',
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Divider(),
                                      Container(
                                        height: 250,
                                        child: Obx(() {
                                          var usedItems = _complaintListScreenController.viewComplaint.value['used_item'];
                                          if (usedItems == null) {
                                            return Center(child: CircularProgressIndicator());
                                          }
                                          return ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: _complaintListScreenController.viewComplaint.value['used_item'].length,

                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.only(
                                                    left: 8, right: 8),
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                      children: [
                                                        Text(
                                                          _complaintListScreenController.viewComplaint.value["used_item"][index]
                                                          ['name'],
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Jost-Regular',
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                        Text(
                                                          _complaintListScreenController.viewComplaint.value["used_item"][index]
                                                          ['qty']
                                                              .toString(),
                                                          style: TextStyle(
                                                            fontFamily:
                                                            'Jost-Regular',
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            color: Colors.black,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        SizedBox(height: 40),

                        _complaintListScreenController.viewComplaint.value['${_complaintListScreenController.userType.value}'] !=
                            'Approved'
                            ? MaterialButton(
                          onPressed: () {
                            _complaintListScreenController.sign == null || _complaintListScreenController.sign.isEmpty
                                ? Get.defaultDialog(
                              title: 'Signature not found'.tr,
                              middleText: 'Please add your signature in the profile section'.tr,
                              textConfirm: 'YES'.tr,
                              confirmTextColor:Colors.white,
                              onConfirm: () {
                                Get.back(); // Close the dialog
                                Get.to(EditProfile());
                              },
                            )
                                : _complaintListScreenController.handleApprove(_complaintListScreenController.viewComplaint.value['id'].toString(), _complaintListScreenController.viewComplaint.value['pdf_url']);
                          },
                          shape:
                          RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(
                                8.0),
                          ),
                          height: 60,
                          minWidth:  double.infinity,
                          textColor: Colors.white,
                          color: Color(0xFF388E3C),
                          child: Text(
                            "APPROVE".tr,
                            style: TextStyle(
                              fontFamily:
                              'Jost-Regular',
                              fontWeight:
                              FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        )
                            : Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xFF388E3C),
                            borderRadius:
                            BorderRadius.circular(
                                8.0),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _complaintListScreenController.getStatusText(
                                _complaintListScreenController.viewComplaint.value['status']
                                    .toString()),
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
                        SizedBox(height: 30),
                        MaterialButton(
                          onPressed: () {
                            Get.to(InVoiceView(InvoiceUrl: _complaintListScreenController.viewComplaint.value['pdf_url']));
                          },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          height: 60,
                          minWidth: double.infinity,
                          textColor: Colors.white,
                          color: Constants.blue,
                          child: Text(
                            "Download the invoice".tr,
                            style: TextStyle(
                                fontFamily: 'Jost-Regular',
                                fontWeight: FontWeight.w700,
                                fontSize: 20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
