import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/firebase_options.dart';
import 'package:flutter_application_1/serives.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ChatApp(),
    );
  }
}

class ChatApp extends StatefulWidget {
  const ChatApp({super.key});

  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  fireStoreSerive fireStoreservice = fireStoreSerive();

  TextEditingController _controller = TextEditingController();
  TextEditingController _editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat App"),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * .7,
                child: TextField(
                  controller: _controller,
                ),
              ),
              MaterialButton(
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    fireStoreservice.addNotes(_controller.text);
                  } else {
                    print("No Input found");
                  }

                  _controller.clear();
                },
                child: Icon(Icons.send),
              )
            ],
          ),
          Container(
            height: MediaQuery.sizeOf(context).height * .6,
            child: StreamBuilder(
              stream: fireStoreservice.getNotestream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List notesList = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: notesList.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = notesList[index];

                      String docID = document.id;

                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;

                      String noteText = data['note'];

                      return ListTile(
                        title: Text(noteText),
                        trailing: editWidgets(
                            editingController: _editingController,
                            fireStoreservice: fireStoreservice,
                            docID: docID),
                      );
                    },
                  );
                } else {
                  return Text("data");
                }
              },
            ),
          )
        ],
      ),
    );
  }
}

class editWidgets extends StatelessWidget {
  const editWidgets({
    super.key,
    required TextEditingController editingController,
    required this.fireStoreservice,
    required this.docID,
  }) : _editingController = editingController;

  final TextEditingController _editingController;
  final fireStoreSerive fireStoreservice;
  final String docID;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: TextField(
              controller: _editingController,
            ),
            content: Row(
              children: [
                MaterialButton(
                  onPressed: () {
                    fireStoreservice.updateNotes(
                        docID, _editingController.text);

                    _editingController.clear();

                    Navigator.pop(context);
                  },
                  child: Text("Add"),
                ),
                MaterialButton(
                  onPressed: () {
                    fireStoreservice.deleteNote(docID);

                    _editingController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Delete"),
                ),
                MaterialButton(
                  onPressed: () {
                    _editingController.clear();
                    Navigator.pop(context);
                  },
                  child: Text("Cancel"),
                )
              ],
            ),
          ),
        );
      },
      icon: Icon(Icons.edit),
    );
  }
}
