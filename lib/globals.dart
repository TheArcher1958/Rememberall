// import 'People.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:math';
import 'People.dart';
People NullPerson = People('Null', 'Null', [], 'Null', null);
List<People> contacts = [];



addContact (person) {
  contacts.add(person);
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();
String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

firstSave(data) async {
//   // Get a location using getDatabasesPath
//   var databasesPath = await getDatabasesPath();
//   String path = '${databasesPath}demo.db';
//
// // open the database
//   Database database = await openDatabase(path, version: 1,
//   onCreate: (Database db, int version) async {
//   await db.execute(
//       'CREATE TABLE Contacts (id TEXT, name TEXT, phone TEXT, contact TEXT)');
//   await db.close();
}