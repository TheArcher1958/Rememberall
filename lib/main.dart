import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:remembrall/HomePage.dart';
import 'package:remembrall/Requests/GetContacts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('us');
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: const MyHomePage(title: 'Contacts'),
    darkTheme: ThemeData(
    brightness: Brightness.dark,
    /* dark theme settings */
  ),
    themeMode: ThemeMode.dark,
    debugShowCheckedModeBanner: false,
  ));
}
// void main() => runApp(
//
// );

class FlutterContactsExample extends StatefulWidget {
  @override
  _FlutterContactsExampleState createState() => _FlutterContactsExampleState();
}

class _FlutterContactsExampleState extends State<FlutterContactsExample> {
  List<Contact>? _contacts;
  bool _permissionDenied = false;

  @override
  void initState() {
    super.initState();
    fetchContacts().then((var contacts) {
      setState(() {
        if (contacts == null) {
          _permissionDenied = true;
        } else {
          _contacts = contacts;
        }
      });
    });

  }

  // Future _fetchContacts() async {
  //   if (!await FlutterContacts.requestPermission(readonly: true)) {
  //     setState(() => _permissionDenied = true);
  //   } else {
  //     final contacts = await FlutterContacts.getContacts();
  //     setState(() => _contacts = contacts);
  //   }
  // }

  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('flutter_contacts_example')),
          body: _body(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              // index = (index + 1) % customizations.length;
            });
          },
          // foregroundColor: Colors.,
          // backgroundColor: customizations[index].$2,
          // shape: customizations[index].$3,
          child: const Icon(Icons.add),
        ),
      )
  );


  Widget _body() {
    if (_permissionDenied) return Center(child: Text('Permission denied'));
    if (_contacts == null) return Center(child: CircularProgressIndicator());
    return ListView.builder(
        itemCount: _contacts!.length,
        itemBuilder: (context, i) => ListTile(
            title: Text(_contacts![i].displayName),
            onTap: () async {
              final fullContact =
              await FlutterContacts.getContact(_contacts![i].id);
              await Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => ContactPage(fullContact!)));
            }));
  }
}

class ContactPage extends StatelessWidget {
  final Contact contact;
  ContactPage(this.contact);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(contact.displayName)),
      body: Column(children: [
        Text('First name: ${contact.name.first}'),
        Text('Last name: ${contact.name.last}'),
        Text(
            'Phone number: ${contact.phones.isNotEmpty ? contact.phones.first.number : '(none)'}'),
        Text(
            'Email address: ${contact.emails.isNotEmpty ? contact.emails.first.address : '(none)'}'),
      ]));
}