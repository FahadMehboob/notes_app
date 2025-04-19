import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class NotesDatabase {
  NotesDatabase._init();

  static final NotesDatabase instance = NotesDatabase._init();

  static Database? _database;

  Future<Database> _initDB() async {
    if (_database != null) return _database!;

    _database = await openDatabase(
      join(await getDatabasesPath(), 'notes.db'),
      version: 1,
      onCreate: (db, version) async => await db.execute('''

        CREATE TABLE notes(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL
        description TEXT NOT NULL
        date TEXT NOT NULL
        color INTEGER NOT NULL DEFAULT 0)
'''),
    );
    return _database!;
  }

  Future<int> _insertNote(
      String title, String description, String date, int color) async {
    final db = await instance._initDB();

    return await db.insert(
        'notes',
        {
          'title': title,
          'description': description,
          'date': date,
          'color': color
        },
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> _getNotes() async {
    final db = await instance._initDB();

    return await db.query(
      'notes',
      orderBy: 'date DESC',
    );
  }

  Future<int> _updateNote(
      String title, String description, String date, int color, int id) async {
    final db = await instance._initDB();

    return await db.update(
        'notes',
        {
          'title': title,
          'description': description,
          'date': date,
          'color': color
        },
        where: 'id = ?',
        whereArgs: [id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> _deleteNote(int id) async {
    final db = await instance._initDB();
    return await db.delete('notes', where: 'id=?', whereArgs: [id]);
  }
}
