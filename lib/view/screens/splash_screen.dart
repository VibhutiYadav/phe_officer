import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/splash_contoller.dart';
import '../../helper/images.dart';



class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final double _height = Get.height, _width = Get.width;
  // final SplashController _controller = Get.find();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        color: Colors.white,
        height: context.height,
        width: context.width,
        child: Image.asset(ProjectImages.Splash,fit:BoxFit.cover,),
      ),
    );
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

  }
}