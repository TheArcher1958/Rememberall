// File: edit_message_date_widget.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'People.dart';

class EditMessageDateWidget extends StatefulWidget {
  const EditMessageDateWidget({super.key, required this.note});
  final Note note;
  @override
  _EditMessageDateWidgetState createState() => _EditMessageDateWidgetState();
}

class _EditMessageDateWidgetState extends State<EditMessageDateWidget> {
  late TextEditingController messageController;
  late TextEditingController dateController;
  DateTime selectedDate = DateTime.now();

  @override
  void dispose() {
    messageController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the widget's initial value
    messageController = TextEditingController(text: widget.note.text);
    dateController = TextEditingController(text: DateFormat('yyyy-MM-dd').format(widget.note.date));
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        TextFormField(
          controller: messageController,
          decoration: const InputDecoration(
            labelText: 'Edit Message',
          ),
        ),
        TextFormField(
          controller: dateController,
          decoration: const InputDecoration(
            labelText: 'Edit Date',
          ),
          readOnly: true,
          onTap: () => _selectDate(context),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Note newNote = Note(messageController.text);
                newNote.setDate(DateTime.parse(dateController.text));
                // newNote.setDate(selectedDate);
                Navigator.of(context).pop(newNote);

              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
