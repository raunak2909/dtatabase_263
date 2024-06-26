import 'package:dtatabase_263/main.dart';
import 'package:dtatabase_263/note_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  //Private Constructor (Singleton class creation)
  AppDatabase._();

  static final AppDatabase db = AppDatabase._();

  static const String DBNAME = "notes.db";
  static const String TABLE_NOTE = "noted";
  static const String COLUMN_NOTE_ID = "n_id";
  static const String COLUMN_NOTE_TITLE = "n_title";
  static const String COLUMN_NOTE_DESC = "n_desc";

  //1
  Database? mDB;

  //2
  //getDB
  Future<Database> getDB() async {
    if (mDB != null) {
      return mDB!;
    } else {
      //openDB
      mDB = await openDB();
      return mDB!;
    }
  }

  Future<Database> openDB() async {
    var rootPath = await getApplicationDocumentsDirectory();
    // data/data/com.example.db/databases/notes.db;
    var dbPath = join(rootPath.path, DBNAME);

    //openDB
    return await openDatabase(dbPath, version: 1,
        //createDB
        onCreate: (db, version) {
      //will be creating all the tables required to maintain in db
      //Tables

      /// run any sql query
      db.execute("create table $TABLE_NOTE ($COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text)");
    });
  }

  ///queries

  //create(insert)
  Future<bool> insertNote({required NoteModel note}) async{

    var mainDB = await getDB();

    int rowsEffect = await mainDB.insert(TABLE_NOTE, note.toMap());

    return rowsEffect>0;
  }

  //read(fetch)
  Future<List<NoteModel>> fetchAllNotes() async{

    var mainDB = await getDB();
    List<NoteModel> mNotes = [];

    try {
      List<Map<String, dynamic>> allNotes = await mainDB.query(TABLE_NOTE);

      for(Map<String, dynamic> eachNote in allNotes){
        mNotes.add(NoteModel.fromMap(eachNote));
      }

    } catch(e){
      print("Error: ${e.toString()}");
    }

    return mNotes;
  }

  Future<bool> updateNote({required String title, required String desc, required int id}) async{
    var mainDB = await getDB();

    int rowsEffect = await mainDB.update(TABLE_NOTE, {
      COLUMN_NOTE_TITLE : title,
      COLUMN_NOTE_DESC : desc,
    }, where: "$COLUMN_NOTE_ID = ?", whereArgs: ['$id']);

    return rowsEffect>0;
  }

  /// all queries work



}
