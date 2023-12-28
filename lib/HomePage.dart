import 'package:flutter/material.dart';
import 'People.dart';
import 'Requests/GetContacts.dart';
import 'ViewPersonScreen.dart';
// import 'globals.dart';
import 'People.dart';
import 'Requests/Firestore.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'AddPersonScreen.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _permissionDenied = false;
  List<People> _contacts = [];
  // late List<Contact> contactsList;
  List<People> filteredList = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    fetchContacts().then((var contacts) {
      setState(() {
        if (contacts == null) {
          _permissionDenied = true;
        } else {
          _contacts = People.listFromContacts(contacts);
          filteredList = _contacts;
          fetchCustomContacts();
          fetchNotes();

          // _contacts = contacts;

          // customContacts = getPeople();
          searchController.addListener(() {
            filterList();
          });
        }
      });
    });

  }


  void filterList() {
    List<People> tempList = [];
    tempList.addAll(_contacts.where((person) => person.name.toLowerCase().contains(searchController.text.toLowerCase())));
    setState(() {
      filteredList = tempList;
    });
  }

  Future<void> fetchNotes() async {
    Map notesList = await getNotes();
    People selectedPerson(String id) => _contacts.firstWhere((person) => person.id == id);

    if(notesList.isNotEmpty) {
      notesList.forEach((k,v) {
        print(k);
        print(v);
        selectedPerson(k).notes += v;
    } );
    }
  }

  Future<void> fetchCustomContacts() async {
    List<People> customContacts = await getPeople();
    for (var person in customContacts) {
      _contacts.add(person);
      setState(() {

      });

    }
  }



  @override
  Widget build(BuildContext context) {
    if (_permissionDenied) return const Center(child: Text('Permission denied'));
    if (_contacts.isEmpty) return const Center(child: CircularProgressIndicator());
    // Color fabColor = Theme.of(context).floatingActionButtonTheme.backgroundColor!;
    filteredList.sort((a, b) => a.name.compareTo(b.name));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0x333333),
        title: Center(child: Text(widget.title)),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(

                textCapitalization: TextCapitalization.sentences,
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search',
                  labelStyle: TextStyle(
                    color: Theme.of(context).floatingActionButtonTheme.backgroundColor, // Color for the label text
                  ),
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(

                itemCount: filteredList.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ViewPersonScreen(person: filteredList[index],))
                      );
                    },
                    child: ListTile(
                      trailing: filteredList[index].notes.length > 0 ? Icon(Icons.list) : null,
                      // tileColor: filteredList[index].notes.length > 0 ? Colors.white12 : Theme.of(context).cardColor,
                      leading: CircleAvatar(
                        backgroundImage: getImage(index), // Replace with AssetImage if you have a local image
                        // If you want a different shape or size, you can use a different widget like Image or Container
                      ),
                      title: Text(filteredList[index].name, style: const TextStyle(fontSize: 18),),

                    ),
                  );
                }
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newPerson = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPersonScreen())
          );
          if(newPerson is People) {
            _contacts.add(newPerson);
          }
          setState(() {

          });
        },
        tooltip: 'Add Person',
        child: const Icon(Icons.add),
        // backgroundColor: Colors.blue,
      ),
    );
  }
  onGoBack(dynamic val) {
    setState(() {});
  }

  getImage(index) {
    if (filteredList[index].thumbnail != null) {
      return MemoryImage(filteredList[index].thumbnail!);
    }
    return const AssetImage('assets/contact.png');
  }
}