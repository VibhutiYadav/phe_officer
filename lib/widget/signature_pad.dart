import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:handpump_supervisor/controllers/complaint_detail_controller.dart';
import 'package:signature/signature.dart';

import '../controllers/edit_profile_controller.dart';

class SignaturePadDialog extends StatelessWidget {
  final int index;
  final EditProfileController controller;
  SignaturePadDialog({required this.index, required this.controller});

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      content: SignaturePadScreen(index: index,controler:controller),
    );
  }
}

class SignaturePadScreen extends StatefulWidget {
  final int index;
  final EditProfileController controler;
  SignaturePadScreen({required this.index,  required this.controler});

  @override
  _SignaturePadScreenState createState() => _SignaturePadScreenState();
}

class _SignaturePadScreenState extends State<SignaturePadScreen> {
  final SignatureController _controller = SignatureController(penStrokeWidth: 5, penColor: Colors.black);
  // ComplaintListScreenController controller=Get.put(ComplaintListScreenController());
  Future<void> _saveSignature() async {
    if (_controller.isNotEmpty) {
      final signature = await _controller.toPngBytes();
      if (signature != null) {
        print("signature called $signature");
        print("index ${widget.index}");
        widget.controler.updateSignature(widget.index, signature);

        Get.back();
        Get.snackbar('Success', 'Signature saved successfully');
      }
    } else {
      Get.snackbar('Error', 'Signature is empty');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: 400,
      child: Column(
        // mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 300,
            width: 300,
            child: Signature(
              controller: _controller,
              backgroundColor: Colors.grey[200]!,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  _controller.clear();
                  Get.find<EditProfileController>().signatures[0] = null;
                },
                child: Text('Clear'),
              ),
              ElevatedButton(
                onPressed: _saveSignature,
                child: Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}