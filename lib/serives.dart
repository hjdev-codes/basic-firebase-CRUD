import 'package:cloud_firestore/cloud_firestore.dart';

class fireStoreSerive {
  final CollectionReference notes =
      FirebaseFirestore.instance.collection("notes");

//get collection of notes

//CREATE:add a new note

  Future<void> addNotes(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

//READ: get notes from the databse
  Stream<QuerySnapshot> getNotestream() {
    // final noteStream = notes.orderBy('timestamp', descending: true).snapshots();

    final noteStream = notes.orderBy('timestamp', descending: true).snapshots();

    return noteStream;
  }
//UPDATE: update notes given a doc id

//DELETE:Delete notes given a doc
}
