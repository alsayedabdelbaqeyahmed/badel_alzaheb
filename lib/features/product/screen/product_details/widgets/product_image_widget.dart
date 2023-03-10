import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myproject/features/home/screen/home/components/special_offers.dart';
import 'package:myproject/widgets/image_gallery_widget.dart';
import 'package:myproject/widgets/image_network_widget.dart';

import '../../../../../common/widgets/default_image.dart';

class ProductImageWidget extends StatelessWidget {
  const ProductImageWidget({
    Key? key,
    required this.image,
    this.colId,
  }) : super(key: key);

  final colId;
  final image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openImage(context, image!);
      },
      child: Container(
        height: 330,
        // color: kPrimaryColor,
        width: double.infinity,
        child: Hero(
          tag: colId.toString(),
          child: CachedNetworkImage(
            // maxHeightDiskCache: 250,
            // maxWidthDiskCache: 300,
            // memCacheHeight: 200,
            // memCacheWidth: 200,
            // ---
            memCacheHeight: 850,
            memCacheWidth: 850,

            //height:height,
            width: double.infinity,
            imageUrl: image,
            fit: BoxFit.fill,
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: DefaultImage(),
            ),
            //placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
          // child: ImageNetWorkWidget(
          //   image: image!,
          // ),
        ),
      ),
    );
  }
}
