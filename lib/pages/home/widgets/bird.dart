import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

class Bird extends StatefulWidget {
  final double size;

  const Bird({Key key, @required this.size}) : super(key: key);

  @override
  _BirdState createState() => _BirdState();
}

class _BirdState extends State<Bird> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _angle;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        seconds: 1,
      ),
    );
    _angle = TweenSequence([
      TweenSequenceItem<double>(
        tween: Tween(begin: _toRadians(3), end: -_toRadians(3)),
        weight: 50,
      ),
      TweenSequenceItem<double>(
        tween: Tween(begin: -_toRadians(3), end: _toRadians(3)),
        weight: 50,
      ),
    ]).animate(_controller);

    _angle.addListener(() {
      setState(() {});
    });

    _controller.repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  double _toRadians(double value) {
    return value * math.pi / 180;
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _angle.value,
      origin: Offset(0, widget.size * 0.4),
      child: SvgPicture.asset(
        'assets/pages/home/bird.svg',
        width: widget.size,
      ),
    );
  }
}
