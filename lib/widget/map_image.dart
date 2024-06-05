import 'package:flutter/material.dart';

class ServiceCard extends StatelessWidget {
  final Function()? onPressed;
  final String? imagePath;
  final double height;
  final double width;
  final double scale;
  final  fit;
  const ServiceCard({Key? key, this.onPressed, this.imagePath,required this.height,required this.width,
    required this.fit,
    required this.scale,


  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.20,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Transform.scale(
            scale: scale,
            child: Image.asset(
              imagePath!,
              width: 20,
              height: 20 ,
              fit:fit! ,
            ),
          ),
        ),
      ),
    );
  }
}
