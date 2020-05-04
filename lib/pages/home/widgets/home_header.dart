import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_ui_avanzadas/blocs/home/bloc.dart';
import 'package:flutter_ui_avanzadas/libs/auth.dart';
import 'package:flutter_ui_avanzadas/pages/home/widgets/bird.dart';
import 'package:flutter_ui_avanzadas/utils/responsive.dart';
import 'package:flutter_ui_avanzadas/utils/theme.dart';
import 'package:provider/provider.dart';

class HomeHeader extends StatelessWidget {
  final GlobalKey<InnerDrawerState> drawerKey;

  const HomeHeader({Key key, @required this.drawerKey}) : super(key: key);

  Widget _getAlias(String displayName) {
    final List<String> tmp = displayName.split(" ");

    String alias = "";
    if (tmp.length > 0) {
      alias = tmp[0][0];
      if (tmp.length == 2) {
        alias += tmp[1][0];
      }
    }

    return Center(
      child: Text(
        alias,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'sans'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: AspectRatio(
        aspectRatio: 16 / 10,
        child: LayoutBuilder(
          builder: (_, constraints) {
            final Responsive responsive = Responsive.ofSize(
              Size(constraints.maxWidth, constraints.minHeight),
            );
            return Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                ClipPath(
                  clipper: MyCustomClipper(),
                  child: Container(
                    color: Color(0xff01579b),
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.only(left: 20),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: SvgPicture.asset(
                    'assets/pages/home/happy.svg',
                    width: constraints.maxWidth * 0.55,
                  ),
                ),
                Positioned(
                  right: constraints.maxWidth * 0.16,
                  bottom: constraints.maxHeight * 0.1,
                  child: Bird(width: constraints.maxWidth * 0.22),
                ),
                Positioned(
                  left: 20,
                  top: 10,
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
                          value: AppTheme.instance.darkEnabled,
                          onChanged: (isDark) {
                            AppTheme.instance.darkEnabled = isDark;
                          },
                          activeColor: Colors.greenAccent,
                          inactiveTrackColor: Colors.white.withOpacity(0.4),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: constraints.maxWidth * 0.05,
                  bottom: constraints.maxHeight * 0.25,
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (_, state) {
                      var text = "";
                      TextStyle style = TextStyle(
                        fontSize: responsive.ip(5),
                        color: Colors.white,
                      );
                      if (state.status == HomeStatus.checkingDb) {
                        text = "...";
                        style = TextStyle(
                          fontSize: responsive.ip(10),
                          color: Colors.white,
                        );
                      } else if (state.status == HomeStatus.loadingArtists) {
                        text = "Loading\nArtists";
                      } else if (state.status == HomeStatus.selectArtists) {
                        text = "Select your \nfavorites artists";
                      } else {
                        text = "Welcome back\nMy friend ...";
                      }

                      return AnimatedDefaultTextStyle(
                        child: Text(text),
                        style: style,
                        curve: Curves.easeInOutCirc,
                        duration: Duration(milliseconds: 300),
                      );
                    },
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: SafeArea(
                    child: FutureBuilder<FirebaseUser>(
                      future: Auth.instance.user,
                      builder: (BuildContext _,
                          AsyncSnapshot<FirebaseUser> snapshot) {
                        if (snapshot.hasData) {
                          final user = snapshot.data;
                          return CircleAvatar(
                            radius: 30,
                            backgroundColor: Color(0xfff50057),
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                drawerKey.currentState.open();
                              },
                              child: user.photoUrl != null
                                  ? ClipOval(
                                      child: Image.network(
                                        user.photoUrl,
                                        width: 74,
                                        height: 74,
                                        fit: BoxFit.contain,
                                      ),
                                    )
                                  : _getAlias(user.displayName),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("Network error"),
                          );
                        }

                        return Center(
                          child: CupertinoActivityIndicator(),
                        );
                      },
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

class MyCustomClipper extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    var path = new Path();
    path.lineTo(0, 0);
    path.lineTo(0, size.height / 1.1);

    path.arcToPoint(Offset(size.width, size.height / 2),
        radius: Radius.circular(size.width), clockwise: false);
    // path.lineTo(size.width, size.height * 0.7);
    path.lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
