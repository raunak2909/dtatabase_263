import 'package:dtatabase_263/note_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../app_database.dart';
import 'db_state.dart';

class DBCubit extends Cubit<DBState>{
  AppDatabase db;
  DBCubit({required this.db}) : super(DBInitialState());
  
  ///events
  void addNote({required NoteModel newNote}) async{
    emit(DBLoadingState());
    
    bool check = await db.insertNote(note: newNote);
    
    if(check){
      var data = await db.fetchAllNotes();
      emit(DBLoadedState(mData: data));
    } else {
      emit(DBErrorState(errorMsg: 'Note can\'t be inserted!!' ));
    }
    
  }

  ///getInitialNotes
  ///updateNote
  ///deleteNote

}