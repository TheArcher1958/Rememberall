import 'package:flutter/material.dart';
import 'package:remembrall/AddInfoScreen.dart';
import 'package:remembrall/People.dart';
import 'package:remembrall/Requests/Firestore.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class ViewPersonScreen extends StatefulWidget {
  const ViewPersonScreen({super.key, required this.person});
  final People person;

  @override
  State<ViewPersonScreen> createState() => _ViewPersonScreenState();
}

class _ViewPersonScreenState extends State<ViewPersonScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text(widget.person.name),),
      body: GroupedListView<dynamic, String>(
        itemBuilder: (BuildContext context, dynamic element) {
          return noteItemWidget(element.text, context);
        },
        elements: widget.person.notes,
        floatingHeader: true,
        groupBy: (element) => DateFormat('E, MMMM d').format(element.date),
        groupComparator: (value1, value2) => value2.compareTo(value1),
        groupSeparatorBuilder: (String groupByValue) => customGroupSeparator(groupByValue),
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
  Widget noteItemWidget(String noteText, BuildContext context, ) {
    return InkWell(
      onTap: getNotes,
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
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            noteText,
            style: GoogleFonts.roboto(
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}


