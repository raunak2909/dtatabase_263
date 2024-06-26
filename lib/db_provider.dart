import 'package:dtatabase_263/app_database.dart';
import 'package:dtatabase_263/note_model.dart';
import 'package:flutter/foundation.dart';

class DBProvider extends ChangeNotifier{
  AppDatabase db;
  DBProvider({required this.db});
  List<NoteModel> _allNotes = [];

  ///getDefaultNotes
  ///updateNote
  ///deleteNote

  ///add note
  void addNote({required NoteModel newNote}) async{
    bool check = await db.insertNote(note: newNote);

    if(check){
      _allNotes = await db.fetchAllNotes();
      notifyListeners();
    }
  }

  ///fetchNotes
  List<NoteModel> getAllNotes(){
    return _allNotes;
  }



}