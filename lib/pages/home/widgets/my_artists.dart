import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/home/home_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/home/home_state.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';

class MyArtists extends StatelessWidget {
  const MyArtists({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (_, state) {
      return SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            final Artist artist = state.artists[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CupertinoButton(
                onPressed: () {},
                padding: EdgeInsets.zero,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: artist.picture,
                              width: 70,
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                artist.name,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'sans',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("${artist.tracks.length} tracks"),
                            ],
                          ),
                        ],
                      ),
                      CircleAvatar(
                        child: Icon(Icons.play_arrow),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
          childCount: state.artists.length,
        ),
      );
    });
  }
}
