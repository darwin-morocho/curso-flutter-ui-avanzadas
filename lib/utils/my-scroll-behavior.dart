import 'package:flutter/material.dart';

class MyScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(_) => ClampingScrollPhysics();

  @override
  Widget buildViewportChrome(context, child, axisDirection) {
    return child;
  }
}
