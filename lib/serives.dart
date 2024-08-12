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

  Future<void> updateNotes(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
    });
  }

//DELETE:Delete notes given a doc

  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
