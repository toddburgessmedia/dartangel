import 'package:postgres/postgres.dart';
import 'dart:convert';
import 'dart:async';
import '../model/person.dart';

class PersonRepository {

  Future<Set<Person>> getPersons() async {

    var persons = <Person>{};

    var connection = PostgreSQLConnection("localhost", 5432, "todd",
        username: "dart", password: "dart");
    await connection.open();

    List<List<dynamic>> results = await connection.query('SELECT * FROM fun');
    results.forEach((row) => persons.add(Person.fromSQL(row)));

    await connection.close();

    return persons;


  }

  void deletePerson(int id) async {
    var connection = PostgreSQLConnection("localhost", 5432, "todd",
        username: "dart", password: "dart");
    await connection.open();

    await connection.execute('DELETE FROM fun WHERE my_id=$id').then((value) => connection.close());

    // await connection.close();

  }


}

