import 'package:flutter/material.dart';
import 'package:remembrall/People.dart';

import 'Requests/Firestore.dart';

class AddInfoScreen extends StatelessWidget {
  AddInfoScreen({super.key, required this.person});
  final People person;

  final infoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Note"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(28.0),
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              controller: infoController,
              autofocus: true,
              minLines: 4,
              maxLines: 8,
            ),
          ),
          ElevatedButton(
              onPressed: () {
                addNote(person,Note(infoController.text));
                person.notes.add(Note(infoController.text));
                Navigator.pop(context);
              },
              child: const Text("Add"))
        ],
      ),
    );
  }
}
