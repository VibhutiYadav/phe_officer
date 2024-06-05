import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../constant/constants.dart';
import '../../controllers/edit_profile_controller.dart';
import '../../helper/images.dart';
import '../../widget/app_bar.dart';
import '../../widget/cached_network_image.dart';
import '../../widget/signature_pad.dart';

class EditProfile extends StatelessWidget {
  // const EditProfile({super.key});
  EditProfileController editProfileController = Get.put(EditProfileController());

  @override
  Widget build(BuildContext context) {
    print(
        "==================sds=========${Constants.BASE_URL_IMAGE}storage/${editProfileController.imageget.value}");
    print(
        "==============sdfd=============${editProfileController.selectedImage.value}");
    // print("===========================${editProfileController.address.value}");
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.width / 5,
        ),
        child: AppbarCommon(
          heading: 'Profile'.tr,
          enable: true,
        ),
      ),
      body: Obx(() => Stack(children: [
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
                child: Container(
                    padding: EdgeInsets.all(8.0),
                    height: 300,
                    child: Padding(
                      padding:  EdgeInsets.symmetric(horizontal: 15),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                editProfileController.openBottomSheet(context);
                              },
                              child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                      ),
                                      Container(
                                        width: MediaQuery.of(context).size.height * 0.2,
                                        height: MediaQuery.of(context).size.height * 0.2,
                                        decoration: BoxDecoration(
                                            border: Border.all(color: Constants.themeColor),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Constants.themeColor,
                                                  blurStyle: BlurStyle.solid)
                                            ],
                                            color: Colors.grey.shade300,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(100))),
                                        child: (
                                            editProfileController.selectedImage.value == null &&
                                                editProfileController.imageget.value == null)
                                            ? Transform.scale(
                                                scale: 0.5,
                                                child: Image.asset(
                                                  ProjectImages.userDark,
                                                  color: Colors.grey,
                                                ),
                                              )
                                            : ClipRRect(
                                                borderRadius: BorderRadius.circular(100),
                                                child: Obx(() {
                                                  if (editProfileController.selectedImage.value != null && editProfileController.selectedImage.value!=''
                                                      && editProfileController.selectedImage.value!='null'    ) {
                                                    print("i an here");
                                                    return Image.file(
                                                      File("${editProfileController.selectedImage.value}"),
                                                      fit: BoxFit.fill,
                                                    );
                                                  } else if ((editProfileController.imageget.value.isNotEmpty)
                                                  ) {
                                                    // editProfileController.isload.value=true;
                                                    return cached_network_image(image: 'storage/${editProfileController.imageget.value}', fit: BoxFit.cover,);
                                                  } else {
                                                    return Transform.scale(
                                                      scale: 0.5,
                                                      child: Image.asset(
                                                        ProjectImages.userDark,
                                                        color: Colors.grey,
                                                      ),
                                                    );
                                                  }
                                                }),
                                              ),
                                      ),
                                      SizedBox(height: 20,),
                                    ],
                                  ),
                                  Positioned(
                                      bottom: 10,
                                      left: MediaQuery.of(context).size.height * 0.17 / 2,
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        padding: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Constants.blue,
                                        ),
                                        child: Icon(
                                          Icons.camera_alt_outlined,
                                          color: Colors.white70,
                                        ),
                                      ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "NAME".tr,textScaleFactor: 1,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )),
                            TextField(
                              controller: editProfileController.nameController,
                              enabled: false,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 16),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "USERNAME_OR_EMAIL".tr,textScaleFactor: 1,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )),
                            TextField(
                              controller: editProfileController.emailController,
                              enabled: false,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(height: 16),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "PHONE".tr,textScaleFactor: 1,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )),
                            TextField(
                              controller: editProfileController.mobileNumberController,
                              enabled: false,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11)
                              ],
                              decoration: InputDecoration(
                                prefixIcon: Icon(Icons.phone),
                                border: OutlineInputBorder(),

                              ),
                            ),

                            SizedBox(height: 20),
                            Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "SIGNATURE".tr,textScaleFactor: 1,
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold),
                                )),
                            SizedBox(height: 2,),
                            Align(
                                alignment: Alignment.centerLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => SignaturePadDialog(
                                          index: 0,
                                          controller:editProfileController),
                                    );
                                    print("cllaed");
                                  },
                                  child:Padding(
                                    padding: EdgeInsets.all(1.0),
                                    child:Obx(() {
                                      return Container(
                                        height: 200,
                                        width: context.width,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),

                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black54,
                                              spreadRadius: 1,
                                            ),
                                          ],
                                        ),
                                        child: editProfileController.signatures != null && editProfileController.signatures.isNotEmpty&&
                                            editProfileController.signatures[0] != null
                                            ? Image.memory(editProfileController.signatures[0]!, fit: BoxFit.contain,)
                                            : editProfileController.sign.value != null && editProfileController.sign.value != ''
                                            ? cached_network_image(
                                          image: 'storage/${editProfileController.sign.value}',
                                          fit: BoxFit.contain,
                                        )
                                            : Center(
                                          child: Text(
                                            'Signature not found'.tr,textScaleFactor: 1,
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      );
                                    })

                                  ),
                                ),
                              ),

                            SizedBox(height: 16),
                            MaterialButton(
                              minWidth: double.infinity,
                              onPressed: () {

                                if (editProfileController.selectedImage.value.isEmpty &&
                                    editProfileController.signatures[0] == null) {
                                  editProfileController.editProfileWithoutImageAndSign();
                                } else if (editProfileController
                                    .selectedImage.value.isEmpty &&
                                    editProfileController.signatures[0] != null) {
                                  editProfileController.editProfileWithoutImage();
                                } else if (!editProfileController
                                    .selectedImage.value.isEmpty &&
                                    editProfileController.signatures[0] == null) {
                                  editProfileController.editProfileWithoutSign();
                                } else {
                                  editProfileController.editProfile();
                                }
                              },
                              color: Constants.blue,
                              // Background color
                              textColor: Colors.white,
                              // Text color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child:  editProfileController.isload.value
                                  ? Center(child: CircularProgressIndicator(color: Constants.blue,)):Text(
                                'UPDATE'.tr,textScaleFactor: 1,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),

                            SizedBox(height: 16),
                            MaterialButton(
                              minWidth: double.infinity,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('LOGOUT'.tr,textScaleFactor: 1,),
                                      content:
                                          Text('Do you want to log out?'.tr,textScaleFactor: 1,),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            // If the user presses 'No', just close the dialog
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('NO'.tr,textScaleFactor: 1,),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            editProfileController.logout(context);
                                          },
                                          child: Text('YES'.tr,textScaleFactor: 1,),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              color: Constants.blue,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Text(
                                'LOGOUT'.tr,textScaleFactor: 1,
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              ),
            ),
          ])),
    );
  }
}
