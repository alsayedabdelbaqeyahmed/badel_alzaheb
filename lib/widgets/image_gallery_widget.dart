import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:myproject/common/utils/colors.dart';
import 'package:myproject/constants.dart';
import 'package:myproject/widgets/image_network_widget.dart';
import 'package:photo_view/photo_view.dart';

class ImageGalleryWidget extends StatelessWidget {
  ImageGalleryWidget({
    Key? key,
    required this.path,
  }) : super(key: key);
  String path;
  @override
  Widget build(BuildContext context) {
    try {
      return Scaffold(
        // appBar: AppBar(
        //   // title: Text('الصورة'),
        //   backgroundColor: Colors.transparent,
        // ),
        body: Stack(
          alignment: Alignment.topRight,
          children: [
            Container(
              child: PhotoView(
                imageProvider: CachedNetworkImageProvider(
                  path,
                ), //   NetworkImage
                //    imageProvider: NetworkImage('$path'), // NetworkImage
              ),
            ),
            Container(
              height: 80,
              child: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: backgroundColor,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      return Scaffold(
        // appBar: AppBar(
        //   title: Text('الصورة'),
        //   backgroundColor: kPrimaryColor,
        // ),
        body: Center(
          child: ImageNetWorkWidget(
            image: path, //   NetworkImage
          ),
        ),
      );
    }
  }
}

void openImage(context, path) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ImageGalleryWidget(
        path: '$path',
      ),
    ),
  );
}
