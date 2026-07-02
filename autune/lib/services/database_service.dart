import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  static Database? _db;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _inicializar();
    return _db!;
  }

  Future<Database> _inicializar() async {
    final caminho = join(await getDatabasesPath(), 'autune.db');

    return await openDatabase(
      caminho,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE usuarios (
            id        INTEGER PRIMARY KEY AUTOINCREMENT,
            nome      TEXT    NOT NULL,
            email     TEXT    NOT NULL UNIQUE,
            usuario   TEXT    NOT NULL UNIQUE,
            senha     TEXT    NOT NULL
          )
        ''');
      },
    );
  }
}
