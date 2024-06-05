
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handpump_supervisor/view/screens/my_work_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../constant/constants.dart';

class InVoiceView extends StatefulWidget {
  final String InvoiceUrl;
  const InVoiceView({super.key, required this.InvoiceUrl});

  @override
  State<InVoiceView> createState() => _InVoiceViewState();
}

class _InVoiceViewState extends State<InVoiceView> {
  late WebViewController _webViewController;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _webViewController = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (mounted) {
              setState(() {
                _isLoading = false; // Set loading to false when page finishes loading
              });
            }
          },
        ),
      )
      ..loadRequest(
        Uri.parse(widget.InvoiceUrl),
      );

    print("pdfurl ${widget.InvoiceUrl}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Get.offAll(MyWorkScreen());
          },
          child: Icon(Icons.arrow_back_ios),
        ),
        toolbarHeight: 58,
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 25,
          weight: 25,
        ),
        centerTitle: true,
        backgroundColor: Constants.blue,
        title: Text(
          "Download the invoice".tr,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadiusDirectional.vertical(
                  top: Radius.circular(23),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: _isLoading
                    ? Center(
                  child: CircularProgressIndicator(
                    color: Constants.blue,
                  ),
                )
                    : WebViewWidget(
                  controller: _webViewController,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class Styles {
  static const TextStyle headingTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const BoxDecoration buttonContainerDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(10)),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 5,
        spreadRadius: 1,
      ),
    ],
  );
}

class Header extends StatelessWidget {
  final String title;

  Header({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadiusDirectional.vertical(
          bottom: Radius.circular(BorderSide.strokeAlignOutside),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
