import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/home/bloc.dart';

class Search extends StatelessWidget {
  const Search({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
      return SliverToBoxAdapter(
        child: state.status == HomeStatus.selecting
            ? Container(
                padding: EdgeInsets.all(15),
                child: CupertinoTextField(
                  placeholder: "Search...",
                  style: TextStyle(
                    fontFamily: 'sans'
                  ),
                  suffix: Padding(
                    padding: EdgeInsets.only(right: 5),
                    child: CupertinoButton(
                      color: Colors.blue,
                      padding: EdgeInsets.all(5),
                      borderRadius: BorderRadius.circular(30),
                      minSize: 25,
                      child: Icon(Icons.clear),
                      onPressed: () {},
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xffdddddd),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              )
            : null,
      );
    });
  }
}
