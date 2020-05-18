import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/home/home_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/home/home_state.dart';
import 'package:flutter_ui_avanzadas/db/app_theme.dart';
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
                  decoration: BoxDecoration(
                    color: MyAppTheme.instance.darkEnabled
                        ? Color(0xff37474f).withOpacity(0.2)
                        : Color(0xfff0f0f0),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: artist.picture,
                                width: 70,
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    artist.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'sans',
                                      color: MyAppTheme.instance.darkEnabled
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text("${artist.tracks.length} tracks"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: CircleAvatar(
                          child: Icon(Icons.play_arrow),
                        ),
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
