import 'package:dtatabase_263/app_database.dart';

class NoteModel{

  int? id;
  String title;
  String desc;

  NoteModel({this.id, required this.title, required this.desc});

  factory NoteModel.fromMap(Map<String, dynamic> map){
    return NoteModel(
        id: map[AppDatabase.COLUMN_NOTE_ID],
        title: map[AppDatabase.COLUMN_NOTE_TITLE],
        desc: map[AppDatabase.COLUMN_NOTE_DESC]);
  }

  Map<String, dynamic> toMap(){
    return {
      //AppDatabase.COLUMN_NOTE_ID : id,
      AppDatabase.COLUMN_NOTE_TITLE : title,
      AppDatabase.COLUMN_NOTE_DESC : desc,
    };
  }

}