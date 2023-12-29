import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:remembrall/globals.dart';

import '../People.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
Stream contactsCollection = FirebaseFirestore.instance.collection('contacts').snapshots();
CollectionReference<Map<String, dynamic>> notesCollection = firestore.collection('notes');


addNote(People person,note) async {
  DocumentReference<Map<String, dynamic>> newNoteRef = FirebaseFirestore.instance.collection('notes').doc(person.id);
  if (person.notes.isEmpty) {
    Map<String, dynamic> newNote = {
      'text': [note.text],
      'dates': [note.date],
    };
    await newNoteRef.set(newNote);
  }

  // Set the new note using the personId as the document ID
  // await newNoteRef.set(newNote);
  else {
    await newNoteRef.update({
      'text': FieldValue.arrayUnion([note.text]),
      'dates': FieldValue.arrayUnion([note.date]),
    });
  }

  print('Note added to Firestore successfully');

}

updateRemoveNote(People person,note) async {
  DocumentReference<Map<String, dynamic>> newNoteRef = FirebaseFirestore.instance.collection('notes').doc(person.id);
  if (person.notes.isNotEmpty) {
    var newNotes = [];
    var newDates = [];
    person.notes.forEach((noteElement) {
      if (noteElement.text != note.text && noteElement.date != note.date) {
        newNotes.add(noteElement.text);
        newDates.add(noteElement.date);
      }
    });
    print(person.notes.length);
    print('Old ^ NEw v');
    print(newNotes.length);
    Map<String, dynamic> newNote = {
      'dates': newDates,
      'text': newNotes,
    };
    await newNoteRef.update(newNote);
  }

  // Set the new note using the personId as the document ID
  // await newNoteRef.set(newNote);


  print('Note updated to Firestore successfully');

}

Future<Map<dynamic,dynamic>> getNotes() async {
  var notesList = {};

  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('notes').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> document
    in querySnapshot.docs) {
      // Assuming your Firestore document has 'text' and 'date' fields as arrays
      List<String> textArray = List<String>.from(document.get('text'));
      List<Timestamp> dateArray = List<Timestamp>.from(document.get('dates'));

      // Convert Timestamps to DateTime
      notesList[document.id] = [];
      List<DateTime> dateList = dateArray.map((timestamp) => timestamp.toDate()).toList();
      for (var i = 0; i < dateList.length; i++) {
        Note note = Note(textArray[i]);
        note.setDate(dateList[i]);
        notesList[document.id].add(note);
      }
    }
    // print(notesList);
    return notesList;
  } catch (e) {
    // Handle errors here
    print('Error fetching notes: $e');
    return {};
  }
}


Future<List<People>> getPeople() async {
  List<People> peopleList = [];

  try {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
    await FirebaseFirestore.instance.collection('contacts').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> document
    in querySnapshot.docs) {
      var person = document.data();
      // print(document.data());
      // print(document.data()['name']);
      peopleList.add(People(person['name'], person['phone'], [], document.id, null));

    }
    // print(notesList);
    return peopleList;
  } catch (e) {
    // Handle errors here
    print('Error fetching notes: $e');
    return [];
  }
}


addContactToFirestore(People person) async {
  DocumentReference<Map<String, dynamic>> newPersonRef = FirebaseFirestore.instance.collection('contacts').doc(person.id);
  if (person.notes.isEmpty) {
    Map<String, dynamic> newNote = {
      'name': person.name,
      'phone': person.number,
    };
    await newPersonRef.set(newNote);
  }

  print('Person added to Firestore successfully');
}

