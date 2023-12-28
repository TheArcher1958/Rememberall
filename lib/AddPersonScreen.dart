import 'package:flutter/material.dart';
import 'People.dart';
import 'Requests/Firestore.dart';
import 'globals.dart';

class AddPersonScreen extends StatelessWidget {
  AddPersonScreen({super.key});

  final nameController = TextEditingController();
  final numberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create New Person"),
      ),
      body: Column(
        children: [
          TextField(controller: nameController,),
          TextField(controller: numberController,),
          ElevatedButton(
            onPressed: () {
              var newPerson = People(nameController.text, numberController.text, [], getRandomString(15), null);
              addContactToFirestore(newPerson);
              Navigator.pop(context, newPerson);
            },
            child: Text("Add ${nameController.text}"))
        ],
      ),
    );
  }
}
