import 'package:flutter_ui_avanzadas/models/artist.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';

class DB {
  DB._internal();
  static DB _instance = DB._internal();
  static DB get instance => _instance;

  Database database;

  Future<void> init() async {
    String dbName = 'flutter_avanzado.db';
    final dir = await getApplicationDocumentsDirectory();
    final path = join(dir.path, dbName);
    this.database = await databaseFactoryIo.openDatabase(path);
  }

  Future<void> close() async {
    await this.database.close();
  }
}

class ArtistsStore {
  final StoreRef _store = intMapStoreFactory.store('artists');
  final Database _db = DB.instance.database;
  ArtistsStore._internal();
  static ArtistsStore _instance = ArtistsStore._internal();
  static ArtistsStore get instance => _instance;

  Future<void> add(Artist artist) async {
    await _store.record(artist.id).put(_db, artist.toJson());
  }

  Future<void> addAll(List<Artist> artists) async {
    await _db.transaction((txn) async {
      for (final artist in artists) {
        await _store.record(artist.id).put(txn, artist.toJson());
      }
    });
  }

  Future<List<Artist>> getAll() async {
    final List<RecordSnapshot<dynamic, dynamic>> snapshots =
        await _store.find(_db);
    final artists = snapshots
        .map(
          (item) => Artist.fromJson(item.value),
        )
        .toList();
    return artists;
  }

  // delete all records
  Future<void> clear() async {
    await _store.drop(_db);
  }
}
