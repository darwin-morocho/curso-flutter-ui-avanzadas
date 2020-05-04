import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/home/bloc.dart';
import 'package:flutter_ui_avanzadas/widgets/rounded_button.dart';

class BottomView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = HomeBloc.of(context);

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (_, state) {
        if (state.status != HomeStatus.selectArtists)
          return Container(height: 0);
        final count = state.artists.where((item) => item.selected).length;
        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: SafeArea(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "Select at least 5 artists",
                    style: TextStyle(fontSize: 17),
                  ),
                ),
                RoundedButton(
                  onPressed: count >= 5
                      ? () {
                          bloc.add(DownloadPlayListsEvent());
                        }
                      : null,
                  label: "NEXT",
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
