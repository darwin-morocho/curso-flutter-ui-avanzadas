import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/home/home_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/home/home_state.dart';
import 'package:flutter_ui_avanzadas/utils/theme.dart';

class MyArtists extends StatelessWidget {
  const MyArtists({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (_, state) {
        return SliverPadding(
          padding: EdgeInsets.only(
            top: 20,
            bottom: 10,
          ),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                final artist = state.artists[index];
                return Padding(
                  padding: EdgeInsets.only(bottom: 10),
                  child: CupertinoButton(
                    onPressed: () {},
                    padding: EdgeInsets.zero,
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.instance.darkEnabled
                            ? Color(0xff37474f).withOpacity(0.1)
                            : Color(0xfff4f4f4),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.only(left: 0, right: 10),
                      margin: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: Row(
                        children: <Widget>[
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: artist.picture,
                              width: 60,
                              height: 60,
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
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                    color: AppTheme.instance.darkEnabled
                                        ? Colors.white
                                        : Colors.black87,
                                    fontFamily: 'sans',
                                  ),
                                ),
                                Text(
                                  "${artist.tracks.length} songs",
                                  style: TextStyle(
                                    fontFamily: 'sans',
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          CircleAvatar(
                            child: Icon(
                              Icons.play_arrow,
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
          ),
        );
      },
    );
  }
}
