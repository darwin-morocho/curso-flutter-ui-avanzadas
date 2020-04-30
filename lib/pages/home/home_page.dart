import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_ui_avanzadas/blocs/home/bloc.dart';
import 'package:flutter_ui_avanzadas/libs/auth.dart';
import 'package:flutter_ui_avanzadas/pages/home/widgets/artists_picker.dart';
import 'package:flutter_ui_avanzadas/utils/responsive.dart';

class HomePage extends StatefulWidget {
  static final routeName = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _bloc = HomeBloc();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            HomeHeader(),
            BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
              if (state.status == HomeStatus.checkingDb ||
                  state.status == HomeStatus.loadingArtists) {
                final bool isCheckingDb = state.status == HomeStatus.checkingDb;
                return SliverFillRemaining(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        LinearProgressIndicator(),
                        SizedBox(height: 10),
                        Text(
                          isCheckingDb
                              ? "Checking your database"
                              : "Getting Artists",
                          style: TextStyle(fontSize: 17),
                        ),
                        Text(
                          "1 / 5",
                        )
                      ],
                    ),
                  ),
                );
              } else if (state.status == HomeStatus.selectArtists) {
                return ArtistsPicker();
              } else {
                return SliverFillRemaining(
                  child: Center(
                    child: Text("Network error"),
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
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
                  clipper: WaveClipper(),
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
                    'assets/pages/home/happy-music.svg',
                    width: constraints.maxWidth * 0.55,
                  ),
                ),
                Positioned(
                  left: constraints.maxWidth * 0.05,
                  bottom: constraints.maxHeight * 0.25,
                  child: BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
                    var text = "";
                    if (state.status == HomeStatus.checkingDb) {
                      text = "...";
                    } else if (state.status == HomeStatus.loadingArtists) {
                      text = "Loading\nArtists";
                    } else if (state.status == HomeStatus.selectArtists) {
                      text = "Select your \nfavorites artists";
                    }

                    return Text(
                      text,
                      style: TextStyle(
                        fontSize: responsive.ip(5),
                        color: Colors.white,
                      ),
                    );
                  }),
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
                              onPressed: () {},
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

class WaveClipper extends CustomClipper<Path> {
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
