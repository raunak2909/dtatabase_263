import 'package:dtatabase_263/app_database.dart';
import 'package:dtatabase_263/cubit/db_cubit.dart';
import 'package:dtatabase_263/cubit/db_state.dart';
import 'package:dtatabase_263/db_provider.dart';
import 'package:dtatabase_263/note_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider<DBCubit>(
        create: (context) => DBCubit(db: AppDatabase.db),
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NoteModel> allNotes = [];
  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getAllNotes();
  }

  /*void getAllNotes() async {
    allNotes = await AppDatabase.db.fetchAllNotes();
    setState(() {});
  }*/

  @override
  Widget build(BuildContext context) {
    AppDatabase db = AppDatabase.db;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: BlocBuilder<DBCubit, DBState>(
        builder: (_, state){
          if(state is DBLoadingState){
            return Center(child: CircularProgressIndicator(),);
          } else if(state is DBErrorState){
            return Center(
              child: Text('Error: ${state.errorMsg}'),
            );
          } else if(state is DBLoadedState){
            return state.mData.isNotEmpty
                ? ListView.builder(
                itemCount: state.mData.length,
                itemBuilder: (_, index) {
                  return ListTile(
                    onTap: (){
                      titleController.text = state.mData[index].title;
                      descController.text = state.mData[index].desc;
                      showModalBottomSheet(
                          context: context,
                          builder: (_) {
                            return bottomSheetUI(isUpdate: true, mId: state.mData[index].id!);
                          },
                          /*enableDrag: false,
           isDismissible: false,*/ /* barrierColor: Colors.blue.shade100,*/
                          backgroundColor: Colors.blue.shade200,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.vertical(top: Radius.circular(43))));
                    },
                    leading: Text('${index+1}'),
                    title: Text(state.mData[index].title),
                    subtitle: Text(state.mData[index].desc),
                    trailing: Icon(Icons.delete, color: Colors.red,),
                  );
                })
                : Center(
              child: Text('No Notes yet!!'),
            );
          } else {
            return Container();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
              context: context,
              builder: (_) {
                titleController.clear();
                descController.clear();
                return bottomSheetUI();
              },
              /*enableDrag: false,
           isDismissible: false,*/ /* barrierColor: Colors.blue.shade100,*/
              backgroundColor: Colors.blue.shade200,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(43))));
        },
        child: Icon(Icons.add),
      ),
    );
  }


  Widget bottomSheetUI({bool isUpdate = false, int mId = 0}){
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(43)),
        color: Colors.grey.shade200,
      ),
      child: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: [
            Text(
              isUpdate ? 'Update Note' : 'Add Note',
              style: TextStyle(
                  fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              isUpdate ? 'Update your title and desc here' : 'Add your brief title and detailed note here',
              style: TextStyle(fontSize: 12),
            ),
            SizedBox(
              height: 11,
            ),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Enter title in here..",
                  label: Text("Title"),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25)),
                  )),
            ),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Enter desc in here..",
                  label: Text("Desc"),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(25)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(25)),
                  )),
            ),
            SizedBox(
              height: 21,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                    onPressed: () async{
                      if (titleController.text.isNotEmpty &&
                          descController.text.isNotEmpty) {

                        // bool check = false;

                        //BlocProvider.of<DBCubit>(context).addNote(newNote: NoteModel(title: titleController.text, desc: descController.text));
                        context.read<DBCubit>().addNote(newNote: NoteModel(title: titleController.text, desc: descController.text));
                        titleController.clear();
                        descController.clear();
                        Navigator.pop(context);

                        /*if(isUpdate){
                          check = await AppDatabase.db.updateNote(
                              title: titleController.text,
                              desc: descController.text,
                            id: mId,
                          );
                        } else {
                          check = await AppDatabase.db.insertNote(
                              title: titleController.text,
                              desc: descController.text,
                          );
                        }

                        if(check) {
                          getAllNotes();
                          titleController.clear();
                          descController.clear();
                          Navigator.pop(context);
                        }*/


                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'TItle or Desc fields cannot be empty, please fill up all the required blanks!!')));
                      }
                    },
                    child: Text(isUpdate ? 'Update' : 'Add')),
                OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        FlutterLogo(),
                        Text('Cancel'),
                      ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
