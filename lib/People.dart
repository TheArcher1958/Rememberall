import 'dart:typed_data';

import 'package:flutter_contacts/contact.dart';

class People {
  final Contact? contact;
  final String name;
  final String number;
  final Uint8List? thumbnail;
  List<dynamic> notes;
  final String id;

  People(this.name, this.number, this.notes, this.id, this.thumbnail, {this.contact});

  People fromContact(Contact contact) {
    return People(contact.displayName, contact.phones[0].number, [], contact.id, contact.thumbnail, contact: contact);
  }

  // bool operator > (People other) {
  //   return (other.name > name);
  // }

  static List<People> listFromContacts(List<Contact> contacts) {
    List<People> people = [];
    var phone = "";
    for (var contact in contacts) {
      print(contact.displayName);
      if (contact.phones.length == 0) {
        phone = "";
      } else {
        phone = contact.phones[0].number;
      }
      people.add(People(contact.displayName, phone, [], contact.id, contact.thumbnail, contact: contact));

    }
    return people;
  }
}

class Note {
  final String text;
  DateTime date = DateTime.now();

  Note(this.text);

  setDate(newDate) {
    date = newDate;
  }
}