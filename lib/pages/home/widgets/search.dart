import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/home/bloc.dart';
import 'package:flutter_ui_avanzadas/db/app_theme.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';

class Search extends StatefulWidget {
  const Search({Key key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Bloc bloc = HomeBloc.of(context);
    return BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
      return SliverToBoxAdapter(
        child: state.status == HomeStatus.selecting
            ? Container(
                padding: EdgeInsets.all(15),
                child: CupertinoTextField(
                  controller: this._controller,
                  placeholder: "Search...",
                  onChanged: (text) {
                    bloc.add(OnSearchEvent(text));
                  },
                  style: TextStyle(
                    fontFamily: 'sans',
                    color: MyAppTheme.instance.darkEnabled
                        ? Colors.white
                        : Colors.black,
                  ),
                  suffix: state.searchText.length > 0
                      ? Padding(
                          padding: EdgeInsets.only(right: 5),
                          child: CupertinoButton(
                            color: Colors.blue,
                            padding: EdgeInsets.all(5),
                            borderRadius: BorderRadius.circular(30),
                            minSize: 25,
                            child: Icon(Icons.clear),
                            onPressed: () {
                              this._controller.clear();
                              bloc.add(OnSearchEvent(''));
                            },
                          ),
                        )
                      : null,
                  padding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: MyAppTheme.instance.darkEnabled
                        ? Color(0xff29434e)
                        : Color(0xffdddddd),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              )
            : null,
      );
    });
  }
}
