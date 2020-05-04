import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/home/bloc.dart';
import 'package:flutter_ui_avanzadas/libs/auth.dart';
import 'package:flutter_ui_avanzadas/pages/home/widgets/artists_picker.dart';
import 'package:flutter_ui_avanzadas/pages/home/widgets/bottom_view.dart';
import 'package:flutter_ui_avanzadas/pages/home/widgets/home_header.dart';
import 'package:flutter_ui_avanzadas/pages/home/widgets/my_artists.dart';
import 'package:flutter_ui_avanzadas/pages/home/widgets/search_artist.dart';
import 'package:flutter_ui_avanzadas/sembast/db.dart';

class HomePage extends StatefulWidget {
  static final routeName = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeBloc _bloc = HomeBloc();
  final _drawerKey = GlobalKey<InnerDrawerState>();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paddings = MediaQuery.of(context).padding;
    return InnerDrawer(
      key: _drawerKey,
      onTapClose: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      rightChild: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              CupertinoButton(
                child: Text("Sign Out"),
                onPressed: () async {
                  await ArtistsStore.instance.clear();
                  Auth.instance.logOut(context);
                },
              )
            ],
          ),
        ),
      ),
      scaffold: BlocProvider.value(
        value: _bloc,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            bottomNavigationBar: BottomView(),
            body: CustomScrollView(
              slivers: <Widget>[
                HomeHeader(
                  drawerKey: _drawerKey,
                ),
                SearchArtist(),
                BlocBuilder<HomeBloc, HomeState>(
                  builder: (_, state) {
                    if (state.status == HomeStatus.selectArtists) {
                      return ArtistsPicker();
                    } else if (state.status == HomeStatus.error) {
                      return SliverFillRemaining(
                        child: Center(
                          child: Text("Network error"),
                        ),
                      );
                    } else if (state.status == HomeStatus.myArtists) {
                      return MyArtists();
                    } else {
                      String text = "";
                      switch (state.status) {
                        case HomeStatus.checkingDb:
                          text = "Checking your database";
                          break;
                        case HomeStatus.loadingArtists:
                          text = "Getting artists";
                          break;
                        case HomeStatus.downloading:
                          text = "Downloading playlists";
                          break;
                        default:
                          text = "";
                      }
                      return SliverFillRemaining(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              LinearProgressIndicator(),
                              SizedBox(height: 10),
                              Text(
                                text,
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
                SliverToBoxAdapter(
                  child: Container(
                    height: paddings.bottom,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
