import 'package:dtatabase_263/app_database.dart';
import 'package:flutter/material.dart';

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
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> allNotes = [];
  var titleController = TextEditingController();
  var descController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllNotes();
  }

  void getAllNotes() async {
    allNotes = await AppDatabase.db.fetchAllNotes();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    AppDatabase db = AppDatabase.db;
    return Scaffold(
      appBar: AppBar(
        title: Text('Notes'),
      ),
      body: allNotes.isNotEmpty
          ? ListView.builder(
              itemCount: allNotes.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(allNotes[index][AppDatabase.COLUMN_NOTE_TITLE]),
                  subtitle: Text(allNotes[index][AppDatabase.COLUMN_NOTE_DESC]),
                );
              })
          : Center(
              child: Text('No Notes yet!!'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showModalBottomSheet(
              context: context,
              builder: (_) {
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
                          'Add Note',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Add you brief title and detailed note here',
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
                                    bool check = await AppDatabase.db.insertNote(
                                        title: titleController.text,
                                        desc: descController.text);

                                    if(check) {
                                      getAllNotes();
                                      titleController.clear();
                                      descController.clear();
                                      Navigator.pop(context);
                                    }



                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'TItle or Desc fields cannot be empty, please fill up all the required blanks!!')));
                                  }
                                },
                                child: Text('Add')),
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
}
