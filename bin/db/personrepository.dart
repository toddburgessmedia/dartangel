import 'package:postgres/postgres.dart';
import 'dart:async';
import '../model/person.dart';

class PersonRepository {

  Future<Set<Person>> getAllPersons() async {

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

    await connection.transaction((connection) async {
      var result = await connection.execute('DELETE FROM fun WHERE my_id=$id');
    });

    await connection.close();
  }

  Future<Person> getPerson(int id) async {
    var connection = PostgreSQLConnection("localhost", 5432, "todd",
        username: "dart", password: "dart");
    await connection.open();

    List<List<dynamic>> results = await connection.query('SELECT * FROM fun WHERE my_id=$id');
    await connection.close();

    return Person.fromSQL(results[0]);
  }
  
  void insertPerson(Person person) async {
    var connection = PostgreSQLConnection("localhost", 5432, "todd",
        username: "dart", password: "dart");
    await connection.open();

    var name = person.name;
    var colour = person.colour;

    await connection.transaction((connection) async {
      var result = await connection.execute('insert into fun values(nextval(\'fun_my_id_seq\'),\'$name\',\'$colour\');');
    });

    await connection.close();
  }

  void updatePerson(Person person) async {
    var connection = PostgreSQLConnection("localhost", 5432, "todd",
        username: "dart", password: "dart");
    await connection.open();

    var id = person.id;
    var name = person.name;
    var colour = person.colour;

    await connection.transaction((connection) async {
      var result = await connection.execute('update fun set name=\'$name\', colour=\'$colour\' WHERE my_id=$id;');
    });

    await connection.close();

  }

}

