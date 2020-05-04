import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_ui_avanzadas/blocs/home/bloc.dart';
import 'package:flutter_ui_avanzadas/models/artist.dart';

class ArtistsPicker extends StatelessWidget {
  const ArtistsPicker({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = HomeBloc.of(context);
    return BlocBuilder<HomeBloc, HomeState>(
      condition: (prev, next) =>
          prev.artists != next.artists || prev.searchText != next.searchText,
      builder: (_, state) {
        final List<Artist> artists = state.artists.where((item) {
          if (state.searchText.isEmpty) return true;
          return item.name.toLowerCase().contains(
                state.searchText.toLowerCase(),
              );
        }).toList();

        return SliverPadding(
          padding: EdgeInsets.only(top: 30, bottom: 10),
          sliver: SliverGrid(
            delegate: SliverChildBuilderDelegate(
              (_, index) {
                final Artist artist = artists[index];
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            bloc.add(
                              OnSelectedArtistEvent(index),
                            );
                          },
                          child: Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              ClipOval(
                                child: CachedNetworkImage(
                                  imageUrl: artist.picture,
                                  placeholder: (_, __) => Center(
                                    child: CupertinoActivityIndicator(
                                      radius: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned.fill(
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  child: Icon(
                                    Icons.check_circle,
                                    size: 30,
                                    color: artist.selected
                                        ? Colors.white
                                        : Colors.transparent,
                                  ),
                                  decoration: BoxDecoration(
                                    color: artist.selected
                                        ? Colors.black38
                                        : Colors.transparent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Text(
                      artist.name,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    )
                  ],
                );
              },
              childCount: artists.length,
            ),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 150,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
          ),
        );
      },
    );
  }
}
