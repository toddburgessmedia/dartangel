import 'package:postgres/postgres.dart';
import 'dart:async';
import '../model/person.dart';

class PersonRepository {

  Future<Set<Person>> getAllPersons() async {

    var persons = <Person>{};

    PostgreSQLConnection connection = await openConnection();

    List<List<dynamic>> results = await connection.query('SELECT * FROM fun');
    results.forEach((row) => persons.add(Person.fromSQL(row)));

    await closeConnection(connection);
    return persons;
  }

  Future closeConnection(PostgreSQLConnection connection) async {
    await connection.close();
  }

  Future<PostgreSQLConnection> openConnection() async {
    var connection = PostgreSQLConnection("localhost", 5432, "todd",
        username: "dart", password: "dart");
    await connection.open();
    return connection;
  }

  void deletePerson(int id) async {
    PostgreSQLConnection connection = await openConnection();

    await connection.transaction((connection) async {
      var result = await connection.execute('DELETE FROM fun WHERE my_id=$id');
    });

    await closeConnection(connection);
  }

  Future<Person> getPerson(int id) async {
    PostgreSQLConnection connection = await openConnection();

    List<List<dynamic>> results = await connection.query('SELECT * FROM fun WHERE my_id=$id');
    await closeConnection(connection);

    return Person.fromSQL(results[0]);
  }
  
  void insertPerson(Person person) async {
    PostgreSQLConnection connection = await openConnection();

    var name = person.name;
    var colour = person.colour;

    await connection.transaction((connection) async {
      var result = await connection.execute('insert into fun values(nextval(\'fun_my_id_seq\'),\'$name\',\'$colour\');');
    });

    await closeConnection(connection);
  }

  void updatePerson(Person person) async {
    PostgreSQLConnection connection = await openConnection();

    var id = person.id;
    var name = person.name;
    var colour = person.colour;

    await connection.transaction((connection) async {
      var result = await connection.execute('update fun set name=\'$name\', colour=\'$colour\' WHERE my_id=$id;');
    });

    await closeConnection(connection);

  }

}

