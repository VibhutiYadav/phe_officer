import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constant/constants.dart';
import '../../controllers/my_work_controller.dart';
import '../../widget/app_bar.dart';
import 'complaint_details.dart';
import 'complaint_screen.dart';

class MyWorkScreen extends StatelessWidget {
  const MyWorkScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MyWorkController controller = Get.put(MyWorkController());
     controller.fetchComplaintData();
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.width / 5,
        ),
        child: AppbarCommon(
          heading: 'MYCOMPLAINTS'.tr,
          enable: false,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Card(
                color: Colors.white.withOpacity(0.5),
                shadowColor: Colors.white.withOpacity(0.5),
                surfaceTintColor: Colors.white.withOpacity(0.5),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 30),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'NAME'.tr,textScaleFactor: 1,
                          style: TextStyle(fontFamily: 'Jost-Regular',fontWeight: FontWeight.w800,color: Constants.blue),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Issues'.tr,textScaleFactor: 1,
                        style: TextStyle(fontFamily: 'Jost-Regular',fontWeight: FontWeight.w800,color: Constants.blue),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'STATUS'.tr,textScaleFactor: 1,
                        style: TextStyle(fontFamily: 'Jost-Regular',fontWeight: FontWeight.w800,color: Constants.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(() => controller.isLoading.value
              ? Center(child: CircularProgressIndicator(color: Constants.blue,))
                :controller.complaintData.isEmpty
              ? Center(child: Text('DATA NOT FOUND'.tr,textScaleFactor: 1, style: TextStyle(fontSize: 15)))
              : Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.complaintData.length,
                  itemBuilder: (context, index) {
                    var data = controller.complaintData[index];
                    return SizedBox(
                      height: 70,
                      child: InkWell(
                        onTap: () {
                          print("----1----");
                          // Get.to(()=>ComplaintListScreenView();
                          Get.to(ComplaintListScreenView(data: controller.complaintData[index]['id']));
                          // Get.to((ComplaintScreen(whichScreen: '', filter: "",)));
                        },
                        child: Card(
                          color: Colors.white.withOpacity(0.5),
                          shadowColor: Colors.white.withOpacity(0.5),
                          surfaceTintColor: Colors.white.withOpacity(0.5),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    controller.formatIdWithLeadingZeros(data['id'].toString()),textScaleFactor: 1,
                                    style: TextStyle(
                                      fontFamily: 'Jost-Regular',
                                      fontWeight: FontWeight.w700,
                                      color: Constants.blue,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    data['service_type'],textScaleFactor: 1,
                                    style: TextStyle(
                                      fontFamily: 'Jost-Regular',
                                      fontWeight: FontWeight.w700,
                                      color: Constants.blue,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(controller.getStatusText(data['status'].toString()),textScaleFactor: 1,
                                    style: TextStyle(
                                      fontFamily: 'Jost-Regular',
                                      fontWeight: FontWeight.w700,
                                      color: controller.getStatusColor(data['status'].toString()),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
