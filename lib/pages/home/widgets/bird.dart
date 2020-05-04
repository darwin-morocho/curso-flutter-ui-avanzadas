import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:math' as math;

class Bird extends StatefulWidget {
  final double width;
  Bird({Key key, @required this.width}) : super(key: key);

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
        milliseconds: 1000,
      ),
    );
    _angle = TweenSequence([
      TweenSequenceItem(
        tween: Tween<double>(begin: 3 * math.pi / 180, end: -3 * math.pi / 180),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -3 * math.pi / 180, end: 3 * math.pi / 180),
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

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: _angle.value,
      origin: Offset(0, widget.width * 0.4),
      child: SvgPicture.asset(
        'assets/pages/home/bird.svg',
        width: widget.width,
      ),
    );
  }
}
