import 'package:sembast/sembast_io.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:path_provider/path_provider.dart';

class DB {
  DB._internal();
  static DB _instance = DB._internal();
  static DB get instance => _instance;

  Database _database;
  Database get database => _database;

  Future<void> init() async {
    final String dbName = "flutter_rocks.db";
    final String path = (await getApplicationDocumentsDirectory()).path;

    final String dbPath = join(path, dbName);

    this._database = await databaseFactoryIo.openDatabase(dbPath);
  }
}
