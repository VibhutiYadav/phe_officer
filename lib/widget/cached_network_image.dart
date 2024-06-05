import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../constant/constants.dart';
import '../helper/images.dart';

class cached_network_image extends StatelessWidget {
  const cached_network_image({
    super.key,

    required this.image,
    required this.fit,
  });


  final  image;
  final fit;

  @override
  Widget build(BuildContext context) {

    // /print("image url  ${Constants.BASE_URL_IMAGE}/$image");
    return CachedNetworkImage(
      imageUrl: '${Constants.BASE_URL_IMAGE}/$image',
      width: context.width,
      fit: fit == "" ? BoxFit.contain : fit,
      memCacheHeight: 400,
      memCacheWidth: 400,
      height: MediaQuery.of(context).size.height * 0.068,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,

        child: Container(
          width: context.width,
          height: MediaQuery.of(context).size.height * 0.068,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) => Image.asset(
        ProjectImages.HKBlack,
      ),
    );
  }
}