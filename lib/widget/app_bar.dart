
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constant/constants.dart';

class AppbarCommon extends StatelessWidget {
  final String heading;
  final bool enable;

   AppbarCommon({
    super.key,
    required this.heading,
    required this.enable,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(foregroundColor: Colors.white,
      automaticallyImplyLeading: enable,
      elevation: 0,
      backgroundColor: Constants.blue,
      centerTitle: true,
      title: Text(heading,textScaleFactor: 1,style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20)),
    );
  }
}
