import 'package:flutter_contacts/flutter_contacts.dart';

Future fetchContacts() async {
  if (!await FlutterContacts.requestPermission(readonly: true)) {
    return null;
  } else {
    final contacts = await FlutterContacts.getContacts(withPhoto: true);
    return contacts;
  }
}