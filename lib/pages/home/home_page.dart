import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/libs/auth.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';
import '../../blocs/home/bloc.dart';
import 'widgets/home_header.dart';

class HomePage extends StatefulWidget {
  static final routeName = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc _bloc = HomeBloc();

  final GlobalKey<InnerDrawerState> _drawerKey = GlobalKey();

  @override
  void dispose() {
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: InnerDrawer(
        key: _drawerKey,
        onTapClose: true,
        rightChild: Container(
          color: Colors.white,
        ),
        scaffold: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              HomeHeader(
                drawerKey: this._drawerKey,
              ),
              BlocBuilder<HomeBloc, HomeState>(
                builder: (_, state) {
                  String text = "";

                  switch (state.status) {
                    case HomeStatus.checking:
                      text = "Checking Database ...";
                      break;
                    case HomeStatus.loading:
                      text = "Loading Artists ...";
                      break;

                    default:
                      text = "";
                  }

                  return SliverFillRemaining(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 10,
                          ),
                          child: LinearProgressIndicator(),
                        ),
                        Text(text)
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
