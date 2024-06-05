import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:handpump_supervisor/view/screens/service_Category.dart';
import 'package:handpump_supervisor/widget/cached_network_image.dart';
import 'package:pie_chart/pie_chart.dart';
import '../../constant/constants.dart';
import '../../controllers/dashboard_controller.dart';
import '../../helper/images.dart';

class DashboardView extends StatelessWidget {
  final DashController controller = Get.put(DashController());

  @override
  Widget build(BuildContext context) {
    controller.fetchStatusData();
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          if (controller.isLoading.value) {
            return CircularProgressIndicator();
          } else {
            return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ProjectImages.watermark),
                  fit: BoxFit.fill,
                  alignment: Alignment.center,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.05), BlendMode.dstATop),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      onRefresh: controller.onRefresh,
                      child: SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 8,),
                              CarouselSlider(
                                options: CarouselOptions(
                                  enlargeFactor: 0.0,
                                  autoPlay: true,
                                  autoPlayAnimationDuration: Duration(seconds: 3),
                                  height:225,
                                  enlargeCenterPage: true,
                                  viewportFraction: 0.92,
                                  onPageChanged: (index, reason) {
                                    controller.activeSlide.value = index;
                                  },
                                ),
                                items: controller.banner.map((item) {
                                  return Builder(
                                    builder: (BuildContext context) {
                                      return Container(
                                        width: MediaQuery.of(context).size.width,
                                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            boxShadow: [
                                              BoxShadow(color: Colors.black26)
                                            ]
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(20),
                                          child: cached_network_image(image:'${item['image']}', fit:BoxFit.fill,)
                                        ),
                                      );
                                    },
                                  );
                                }).toList(),
                              ),
                              Padding(
                                padding:EdgeInsets.only(left: 12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height:8),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'Chart'.tr,textScaleFactor: 1,
                                        style: TextStyle(
                                          fontSize: 26,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Obx(() {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      height: 10,

                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text('${controller.status.where((item) => item['status'] == 'pending').length}',textScaleFactor: 1,style: TextStyle(
                                                        height: 0.8, fontWeight: FontWeight.bold,
                                                        fontSize: 13
                                                    ),),
                                                    SizedBox(width: 5),
                                                    Text("Pending".tr,textScaleFactor: 1,style: TextStyle(
                                                        height: 0.8, fontWeight: FontWeight.bold,
                                                        letterSpacing: 0.01,
                                                        wordSpacing: 0.1,
                                                        fontSize: 13
                                                    ),),
                                                  ],
                                                ),
                                                SizedBox(height: 22),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      height: 10,
                                                      decoration: BoxDecoration(
                                                          color: Colors.orange,
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text('${controller.status.where((item) => item['status'] == 'in_progress').length}',
                                                        textScaleFactor: 1, style: TextStyle(
                                                          height: 0.8,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 13
                                                      ),),
                                                    SizedBox(width: 5),
                                                    Text("INProgress".tr,textScaleFactor: 1,style: TextStyle(
                                                        height: 0.7,
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 0.01,
                                                        wordSpacing: 0.5,
                                                        fontSize: 13
                                                    ),),
                                                  ],
                                                ),
                                                SizedBox(height: 22),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 20,
                                                      height: 10,

                                                      decoration: BoxDecoration(
                                                          color: Colors.green,
                                                          borderRadius: BorderRadius.circular(5)
                                                      ),

                                                    ),
                                                    SizedBox(width: 5),
                                                    Text('${controller.status.length}',textScaleFactor: 1,style: TextStyle(
                                                        height: 0.9,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.bold
                                                    ),),
                                                    SizedBox(width: 5),
                                                    Text('Total'.tr,textScaleFactor: 1,style: TextStyle(
                                                        height: 0.9,
                                                        fontWeight: FontWeight.bold,
                                                        letterSpacing: 0.5,
                                                        wordSpacing: 0.5,
                                                        fontSize: 13
                                                    ),),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            // (controller.status.where((item) => item['status'] == 'pending').length==0)?SizedBox():
                                            PieChart(

                                              dataMap: {
                                                'Pending': controller.status.where((item) => item['status'] == 'pending').length.toDouble(),
                                                'In Progress': controller.status.where((item) => item['status'] == 'in_progress').length.toDouble(),
                                                'Completed': controller.status.length.toDouble(),
                                              },
                                              ringStrokeWidth: 28,
                                              legendOptions: LegendOptions(
                                                  showLegends: false,

                                                  legendPosition: LegendPosition.left,
                                                  legendShape:BoxShape.circle
                                              ),

                                              colorList: [Colors.red, Colors.orange, Colors.green],
                                              chartType: ChartType.ring,
                                              animationDuration: Duration(milliseconds: 800),
                                              chartRadius: MediaQuery.of(context).size.width / 3.5,
                                            )
                                          ],
                                        ),
                                      );
                                    }),
                                    SizedBox(height: 24),
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        'SERVICES'.tr,textScaleFactor: 1,
                                        // 'SERVICES'.tr,textScaleFactor: 1,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 0,),
                                    Padding(
                                      padding:  EdgeInsets.only(right: 12),
                                      child: ServiceCategory(controller: controller,),
                                    ),
                                    SizedBox(height: 40),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
