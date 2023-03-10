import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class ListTileAnimation extends StatelessWidget {
  ListTileAnimation({
    required this.index,
    required this.child,
  });
  int index;
  final child;
  @override
  Widget build(BuildContext context) {
    return AnimationConfiguration.staggeredList(
      position: index,
      delay: Duration(milliseconds: 100),
      child: SlideAnimation(
        duration: Duration(
          milliseconds: 2500,
        ),
        curve: Curves.fastLinearToSlowEaseIn,
        horizontalOffset: 30,
        verticalOffset: 300,
        child: FlipAnimation(
          duration: Duration(
            milliseconds: 3000,
          ),
          curve: Curves.fastLinearToSlowEaseIn,
          flipAxis: FlipAxis.y,
          child: child,
        ),
      ),
    );
  }
}
