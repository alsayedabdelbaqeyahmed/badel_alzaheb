import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../common/widgets/default_image.dart';

class ImageNetWorkWidget extends StatelessWidget {
  const ImageNetWorkWidget({
    Key? key,
    required this.image,
  }) : super(key: key);

  final String image;
  // final double height;
  //final double width;

  @override
  Widget build(BuildContext context) {
    // return Image.network(
    //   image,
    //   width: double.infinity,
    //   fit: BoxFit.fill,
    //   loadingBuilder: (context, child, loadingProgress) => Center(
    //     child: DefaultImage(),
    return CachedNetworkImage(
      maxHeightDiskCache: 400,
      maxWidthDiskCache: 400,
      memCacheHeight: 300,
      memCacheWidth: 300,

      //height:height,
      width: double.infinity,
      imageUrl: image,
      fit: BoxFit.fill,
      progressIndicatorBuilder: (context, url, progress) => Center(
        child: DefaultImage(),
      ),
      //placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
