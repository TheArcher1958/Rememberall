import 'package:flutter/material.dart';
import 'package:remembrall/AddInfoScreen.dart';
import 'package:remembrall/People.dart';
import 'package:remembrall/Requests/Firestore.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:remembrall/HomePage.dart';
import 'package:remembrall/globals.dart';
import 'package:remembrall/editNote.dart';


class ViewPersonScreen extends StatefulWidget {
  const ViewPersonScreen({super.key, required this.person});
  final People person;

  @override
  State<ViewPersonScreen> createState() => _ViewPersonScreenState();
}

class _ViewPersonScreenState extends State<ViewPersonScreen> {

  @override
  Widget build(BuildContext context) {
  print(widget.person.notes.length);
  // print(widget.person.notes[0].text);
    return Scaffold(
      appBar: AppBar(title: Text(widget.person.name),),
      body: GroupedListView<dynamic, String>(
        itemBuilder: (BuildContext context, dynamic element) {
          return noteItemWidget(element, context);
        },
        elements: widget.person.notes,
        floatingHeader: true,
        groupBy: (element) => DateFormat('yyyy-MM-dd').format(element.date), // Group by day
        groupComparator: (value1, value2) => DateTime.parse(value2).compareTo(DateTime.parse(value1)), // Sort groups by newest first
        itemComparator: (item1, item2) => item2.date.compareTo(item1.date), // Sort items within groups by newest first
        groupSeparatorBuilder: (groupByValue) => customGroupSeparator(DateFormat('E, MMMM d').format(DateTime.parse(groupByValue))),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddInfoScreen(person: widget.person))
          ).then(onGoBack);
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
  onGoBack(dynamic val) {
    setState(() {

    });
  }
  Widget customGroupSeparator(String groupByValue) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      width: double.infinity,
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment.center, // Align the text to the right
      decoration: const BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.all(Radius.circular(14))),
      child: Text(
        groupByValue,
        style: TextStyle(
          color: Theme.of(context).primaryColor, // Use the primary color from the theme
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  Widget noteItemWidget(Note note, BuildContext context, ) {
    return InkWell(
      // onTap: testFunc(note),
      onTap: () async {


        final Note? updatedNote = await _dialogBuilder(context, note);
        if (updatedNote != null) {
          updateNote(widget.person, note, updatedNote);
          setState(() {
            updateLocalNote(note, widget.person, updatedNote);
            // widget.person.notes[note] = updatedNote;
            int index = widget.person.notes.indexWhere((inote) => inote.text == note.text && inote.date == note.date);

            if (index != -1) {
              // Note found, update it
              widget.person.notes[index] = updatedNote;
            } else {
              print("Unable to find note!");
            }
          });
        }

      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        padding: const EdgeInsets.all(12.0), // Adjust vertical padding to reduce height
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 4),
              blurRadius: 2.0,
              spreadRadius: 0.0,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              // alignment: Alignment.topLeft,
              child: Text(
                note.text,
                style: GoogleFonts.roboto(
                  fontSize: 16.0,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                updateRemoveNote(widget.person, note);
                setState(() {
                  removeLocalNote(note, widget.person);
                  widget.person.notes.remove(note);
                });
              },
              child: const Icon(
                Icons.delete, // Replace with your desired icon

                // color: Colors.your_color, // Optional: Choose your color
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<Note?> _dialogBuilder(BuildContext context, note) async {
    return showDialog<Note>(
      context: context,
      builder: (BuildContext context) {

        return AlertDialog(
          // title: const Text('Basic dialog title'),
          // iconPadding: EdgeInsets.only(left: 12.0),
          // icon: Icon(Icons.delete),
          content: SingleChildScrollView(child: EditMessageDateWidget(note: note,)),
          // actions: <Widget>[
          //   TextButton(
          //     child: Text('Close'),
          //     onPressed: () {
          //       Navigator.of(context).pop(); // Close the dialog
          //     },
          //   ),
          // ],
          // actions: <Widget>[
          //   TextButton(
          //     style: TextButton.styleFrom(
          //       textStyle: Theme.of(context).textTheme.labelLarge,
          //     ),
          //     child: const Text('Disable'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          //   TextButton(
          //     style: TextButton.styleFrom(
          //       textStyle: Theme.of(context).textTheme.labelLarge,
          //     ),
          //     child: const Text('Enable'),
          //     onPressed: () {
          //       Navigator.of(context).pop();
          //     },
          //   ),
          // ],
        );
      },
    );
  }
}


