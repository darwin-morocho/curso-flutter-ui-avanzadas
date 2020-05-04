import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/home/bloc.dart';
import 'package:flutter_ui_avanzadas/utils/theme.dart';

class SearchArtist extends StatefulWidget {
  @override
  _SearchArtistState createState() => _SearchArtistState();
}

class _SearchArtistState extends State<SearchArtist> {
  TextEditingController _controller = TextEditingController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bloc = HomeBloc.of(context);
    return BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
      Widget widget = Container();
      if (state.status == HomeStatus.selectArtists) {
        widget = Container(
          width: double.infinity,
          margin: EdgeInsets.only(
            top: 30,
            left: 15,
            right: 15,
          ),
          child: CupertinoTextField(
            placeholder: "Search ...",
            controller: _controller,
            style: TextStyle(
              fontFamily: 'sans',
              color:
                  AppTheme.instance.darkEnabled ? Colors.white : Colors.black,
            ),
            placeholderStyle: TextStyle(
              fontFamily: 'sans',
              color:
                  (AppTheme.instance.darkEnabled ? Colors.white : Colors.black)
                      .withOpacity(0.5),
            ),
            onChanged: (text) => bloc.add(OnSearchChangeEvent(text)),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            suffix: Padding(
              padding: EdgeInsets.only(right: 5),
              child: state.searchText.isEmpty
                  ? null
                  : CupertinoButton(
                      minSize: 30,
                      child: Icon(
                        Icons.cancel,
                        size: 30,
                        color: Color(0xffaaaaaa),
                      ),
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        bloc.add(OnSearchChangeEvent(''));
                        Future.delayed(Duration(milliseconds: 100), () {
                          _controller.clear();
                        });
                      },
                    ),
            ),
            decoration: BoxDecoration(
              color: AppTheme.instance.darkEnabled
                  ? Color(0xff37474f)
                  : Color(0xffeeeeee),
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        );
      }
      return SliverToBoxAdapter(
        child: widget,
      );
    });
  }
}
