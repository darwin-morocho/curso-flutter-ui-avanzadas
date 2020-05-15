import 'package:flutter_ui_avanzadas/models/artist.dart';
import 'package:sembast/sembast.dart';

import 'db.dart';

class ArtistsStore {
  ArtistsStore._internal();
  static ArtistsStore _instance = ArtistsStore._internal();
  static ArtistsStore get instance => _instance;

  Database _db = DB.instance.database;
  StoreRef<int, Map> _store = StoreRef('artists');

  Future<List<Artist>> find() async {
    final snapshots = await this._store.find(this._db);
    return snapshots.map<Artist>((e) => Artist.fromJson(e.value)).toList();
  }

  Future<void> add(Artist artist) async {
    await this._store.record(artist.id).put(this._db, artist.toJson());
  }

  Future<void> addAll(List<Artist> artists) async {
    await this._db.transaction((transaction) async {
      for (final artist in artists) {
        await this._store.record(artist.id).put(transaction, artist.toJson());
      }
    });
  }

  Future<void> clear() async {
    await this._store.delete(this._db);
  }
}
