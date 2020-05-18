import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_ui_avanzadas/db/app_theme.dart';
import 'package:flutter_ui_avanzadas/pages/home/widgets/my_avatar.dart';
import 'package:flutter_ui_avanzadas/utils/responsive.dart';

import 'bird.dart';

class HomeHeader extends StatelessWidget {
  final GlobalKey<InnerDrawerState> drawerKey;
  const HomeHeader({Key key, @required this.drawerKey})
      : assert(drawerKey != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AspectRatio(
        aspectRatio: 16 / 11,
        child: LayoutBuilder(
          builder: (_, BoxConstraints constraints) {
            final Responsive responsiveHeader = Responsive.fromSize(
                Size(constraints.maxWidth, constraints.maxHeight));

            return Stack(
              children: <Widget>[
                ClipPath(
                  clipper: _MyCustomClipper(),
                  child: Container(
                    color: Color(0xff01579b),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: SvgPicture.asset(
                    'assets/pages/home/happy.svg',
                    width: constraints.maxWidth * 0.55,
                  ),
                ),
                Positioned(
                  bottom: constraints.maxHeight * 0.09,
                  right: constraints.maxWidth * 0.163,
                  child: Bird(size: constraints.maxWidth * 0.22),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: SafeArea(child: MyAvatar(
                    onPressed: () {
                      this.drawerKey.currentState.open();
                    },
                  )),
                ),
                Positioned(
                  bottom: constraints.maxHeight * 0.2,
                  left: 10,
                  child: Text(
                    "Welcome back\nMy Friend ...",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsiveHeader.ip(5.4),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: SafeArea(
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Dark mode:",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Switch(
                          value: MyAppTheme.instance.darkEnabled,
                          onChanged: (v) {
                            MyAppTheme.instance.setTheme(v);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final Path path = Path();
    path.lineTo(0, size.height * 0.9);
    path.arcToPoint(Offset(size.width, size.height * 0.5),
        radius: Radius.circular(size.width), clockwise: false);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
