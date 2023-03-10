import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:myproject/common/utils/colors.dart';
import 'package:myproject/common/widgets/default_image.dart';

class ImageWidget extends StatelessWidget {
  ImageWidget(
    this.title, {
    Key? key,
    required this.path,
    this.onTap,
  }) : super(key: key);
  String title;
  String path;
  Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return path.trim() == ''
        ? Container(
            child: Image.asset(
              'assets/images/logo.png',
            ),
          )
        : GestureDetector(
            onTap: onTap,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    blurRadius: 5,
                  ),
                ],
              ),
              margin: EdgeInsets.all(12),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      imageUrl: path,

                      errorWidget: (context, url, error) => Icon(Icons.error),
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Center(
                        child: DefaultImage(),
                      ),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      maxHeightDiskCache: 500,
                      maxWidthDiskCache: 800,
                      memCacheHeight: 200,
                      memCacheWidth: 300,
                      // fit: BoxFit.fill,
                    ),
                  ),
                  Container(
                    height: 200,
                    alignment: Alignment.bottomRight,
                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                    decoration: BoxDecoration(
                      // تدريج الالوان
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0),
                          Colors.black.withOpacity(0.8),
                        ],
                        // نقطة بداية اللون ونقطة النهاية
                        stops: [0.6, 1],
                      ),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(color: backgroundColor, fontSize: 20),
                      overflow:
                          TextOverflow.fade, // اخفاء النص في حالة طول حجمة
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
