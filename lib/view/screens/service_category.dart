import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
// import 'package:handpump_manager/view/screens/complaint_screen.dart';

import '../../constant/constants.dart';
import '../../controllers/dashboard_controller.dart';
import '../../helper/images.dart';
import '../../widget/cached_network_image.dart';
import 'complaint_screen.dart';

class ServiceCategory extends StatelessWidget {
  const ServiceCategory({
    super.key,
    required this.controller,
  });

  final DashController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(()=>
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 3 / 4,
          ),
          itemCount: controller.services.length,
          itemBuilder: (context, index) {
            var item = controller.services[index];
            return GestureDetector(
              onTap: () {


                String filterText=item['type'];
                print("item selected ${item['type']}");
                if(filterText == "हैंडपंप काम नहीं कर रहा है"){
                  List<String> words = filterText.split(' ');
                  words.removeAt(0);
                  print("words length ${words.length}");
                  words.removeRange( 3,words.length);
                  print("words $words");
                  filterText=words.join(' ');
                }
                Get.to(ComplaintScreen(whichScreen:"Dashboard",filter: filterText));

                // Get.to(AddScreen());
              },
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: Card(
                        margin: EdgeInsets.all(8),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            cached_network_image(image: 'storage/${item['image']}', fit: BoxFit.contain,),
                            SizedBox(height: 10,),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.2,
                              child: Text(item['type'],textScaleFactor: 1,
                                style: TextStyle(color: Constants.darkblue, fontWeight: FontWeight.w400, height: 1.2),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis, maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                      )),
                  Positioned(
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Container(

                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Obx(() => Text(
                              textScaleFactor: 1,
                              // "120",
                              formatIndianNumber(controller.status.where((item) => item['service_type'] == controller.services[index]['type']).length ),


                              // "${controller.status.where((item) => item['service_type'] == controller.services[index]['type']).length}",
                              style:
                              TextStyle(color: Colors.blue, fontSize: 21),overflow: TextOverflow.ellipsis,))),
                      )),

                  Positioned(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Color(0xFF468ef2),
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(ProjectImages.rightArrow)),
                      )),
                ],
              ),
            );
          },
        ),
    );
  }
  String formatIndianNumber(int number) {

    if (number >= 10000000) {
      return "${(number / 10000000).toStringAsFixed(1)}Cr"; // Crore
    } else if (number >= 100000) {
      return "${(number / 100000).toStringAsFixed(1)}L"; // Lakh
    } else if (number >= 1000) {
      return "${(number / 1000).toStringAsFixed(1)}k"; // Thousand
    } else {
      return number.toString();
    }
  }
}

