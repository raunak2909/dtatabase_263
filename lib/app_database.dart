import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AppDatabase{
  //Private Constructor (Singleton class creation)
  AppDatabase._();

  static final AppDatabase db = AppDatabase._();

  //1
  Database? mDB;

  //2
  //getDB
  Future<Database> getDB() async{

    if(mDB!=null){
      return mDB!;
    } else {
      //openDB
      return await openDB();
    }

  }

  Future<Database> openDB() async{

    var rootPath = await getApplicationDocumentsDirectory();
    // data/data/com.example.db/databases/notes.db;
    var dbPath = join(rootPath.path, "notes.db");

    //openDB
    return await openDatabase(dbPath, version: 1,
        //createDB
        onCreate: (db, version){
      //will be creating all the tables required to maintain in db
      //Tables

      /// run any sql query
      db.execute("create Table noted (n_id integer primary key autoincrement, n_title text, n_desc text)");

    });

  }






}