import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/features/carousel/controller/carousel_controller.dart';
import 'package:myproject/features/carousel/models/carousel.dart';
import 'package:myproject/widgets/image_gallery_widget.dart';
import 'package:myproject/widgets/nodata_widget.dart';
import '../../../common/widgets/error.dart';
import '../../../common/widgets/loader.dart';
import '/constants.dart';

class CarouselSliderDataFound extends ConsumerStatefulWidget {
  // final List<Carousel> carouselList = carouselImageList;
  //  CarouselSliderDataFound(this.carouselList);

  @override
  _CarouselSliderDataFoundState createState() =>
      _CarouselSliderDataFoundState();
}

class _CarouselSliderDataFoundState
    extends ConsumerState<CarouselSliderDataFound> {
  int _current = 0;
  List<Widget>? imageSlider;

  @override
  void initState() {
    // imageSlider = loadSlider(carouselList);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(getCarouselFutureProvider).when(
          data: (dataList) {
            if (dataList == null || dataList == [] || dataList.isEmpty) {
              dataList.add(defaultSlider);
              print(dataList);
            }
            if (dataList == null || dataList == [] || dataList.isEmpty) {
              return NoDataWidget();
            }
            return Container(
              margin: EdgeInsets.only(
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CarouselSlider(
                      items: loadSlider(dataList),
                      // items: imageSlider,
                      options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 18 / 9,
                          viewportFraction: 1,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                            });
                          })),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: dataList.map((e) {
                      int index = dataList.indexOf(e);
                      return Container(
                        width: 8,
                        height: 8,
                        margin:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index
                              ? Color.fromRGBO(0, 0, 0, 0.9)
                              : Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          },
          error: (err, trace) {
            return ErrorScreen(
              error: err.toString(),
            );
          },

          //loading: () => Loader(),
          loading: () => CarouselSlider(
              items: loadSlider([defaultSlider]),
              // items: imageSlider,
              options: CarouselOptions(
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 18 / 9,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  })),
        );
  }

  List<Widget>? loadSlider(List<Carousel> carouselList) {
    return carouselList
        .map((e) => GestureDetector(
              onTap: () {
                openImage(context, e.image);
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.all(5),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Stack(
                    children: [
                      e.image.trim() == 'assets/images/logo.png'
                          ? Image.asset(
                              e.image,
                              width: 700,
                              height: 500,
                              fit: BoxFit.fill,
                            )
                          : CachedNetworkImage(
                              imageUrl: e.image,
                              width: double.infinity,
                              // height: 500,
                              fit: BoxFit.fill,
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                child: CircularProgressIndicator(),
                              ),
                              maxHeightDiskCache: 500,
                              maxWidthDiskCache: 800,
                              memCacheHeight: 200,
                              memCacheWidth: 300,
                            ),
                      Container(
                        height: 250,
                        alignment: Alignment.bottomRight,
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                        decoration: BoxDecoration(
                          // تدريج الالوان
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              primaryColor.withOpacity(0),
                              primaryColor.withOpacity(0.3),
                            ],
                            // نقطة بداية اللون ونقطة النهاية
                            // stops: [0.6, 1],
                            stops: [0.5, 1],
                          ),
                        ),
                        // child: Text(
                        //   '',
                        //   style: Theme.of(context).textTheme.headline6,
                        //   overflow:
                        //       TextOverflow.fade, // اخفاء النص في حالة طول حجمة
                        // ),
                      ),
                      // CachedNetworkImage(
                      //   imageUrl: e.image,
                      //   errorWidget: (context, url, error) =>
                      //   Icon(Icons.error),
                      //   progressIndicatorBuilder: (context, url, downloadProgress) =>
                      //   Center(
                      //     child: CircularProgressIndicator(
                      //       value: downloadProgress.progress,
                      //     ),
                      //   ),
                      //   fit: BoxFit.cover,
                      //   width: 1000,
                      // ),
                      // Positioned(
                      //   bottom: 0,
                      //   left: 0,
                      //   right: 0,
                      //   child: Container(
                      //     padding: EdgeInsets.all(10),
                      //     child: Text(
                      //       'Some Text',
                      //       style: TextStyle(
                      //           color: Color.fromARGB(255, 245, 38, 38),
                      //           fontSize: 20,
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ))
        .toList();
  }
}
