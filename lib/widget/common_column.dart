import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import 'cached_network_image.dart';

class commoncolumn extends StatelessWidget {
  var title;

  var data;
  var type;

  commoncolumn({
    super.key,
    required this.title,
    required this.data,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {


    // print("data $data");
    return
       Container(
        width: double.infinity,
        padding: EdgeInsets.all(MediaQuery.of(context).size.height * 0.01),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: MediaQuery.of(context).size.height * 0.002,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 4,
              child: Text(title,textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  ':',textScaleFactor: 1,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child:

              (type == 'image')?cached_network_image(image:'storage/$data', fit: null,):



              Text(
                data,textScaleFactor: 1,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );

  }
}
