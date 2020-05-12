import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/home/bloc.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';
import 'package:flutter_ui_avanzadas/widgets/rounded_button.dart';

class HomeBottomBar extends StatelessWidget {
  const HomeBottomBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HomeBloc bloc = HomeBloc.of(context);
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (_, state) {
        final List<Artist> artistsSelected =
            state.artists.where((element) => element.selected).toList();

        final int count = artistsSelected.length;
        return Container(
          color: Colors.white,
          padding: EdgeInsets.all(10),
          child: SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Select at least 5 artists",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ),
                RoundedButton(
                  onPressed: count >= 5
                      ? () {
                          bloc.add(DownloadEvent(artistsSelected));
                        }
                      : null,
                  label: "NEXT",
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
