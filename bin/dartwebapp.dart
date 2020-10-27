import 'dart:convert';

import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:angel_mustache/angel_mustache.dart';

import 'db/personrepository.dart';

import 'package:file/local.dart';

import 'model/person.dart';


void main(List<String> arguments) async {

  var fs = LocalFileSystem();

  const port = 8888;
  const hostname = 'localhost';
  var app = Angel();
  var http = AngelHttp(app);
  await app.configure(mustache(fs.directory('.'),fileExtension: '.html'));

  // default route
  app.get('/', (req, res) => res.write('Hello, World!'));

  // list action route
  app.get('/list', (req, res) async {
    var repo = PersonRepository();
    var persons = await repo.getAllPersons();
    var jsonRaw = persons.map((e) => e.toJson()).toList();
    var jsonData = { 'people' : jsonRaw };

    await res.render('list',jsonData);
    });

  // delete route
  app.post('/delete', (req, res) async {
    await req.parseBody();
    var id = int.parse(req.bodyAsMap['id'] as String);
    print('id $id');

    var repo = PersonRepository();
    repo.deletePerson(id);
    await res.render('delete',null);
  });

  // create new person route
  app.post('/add/:action', (req, res) async {
    await req.parseBody();
    var action = req.params['action'] ?? 'submitform' ;
    if (action == 'needform') {
      await res.render('add', null);
    } else {
      var personname = req.bodyAsMap['personname'] as String;
      var personcolour = req.bodyAsMap['personcolour'] as String;

      var person = Person(name: personname, colour: personcolour);
      var repo = PersonRepository();
      repo.insertPerson(person);

      await res.render('personadded', person.toJson());
    }

  });

  // update person route
  app.post('/update/:action', (req, res) async {
    await req.parseBody();
    var action = req.params['action'] ?? 'submitform' ;

    var repo = PersonRepository();
    if (action == 'needform') {
      var id = int.parse(req.bodyAsMap['id'] as String);
      var person = await repo.getPerson(id);
      await res.render('update',person.toJson());
    } else {
      var id = int.parse(req.bodyAsMap['id'] as String);
      var name = req.bodyAsMap['personname'] as String;
      var colour = req.bodyAsMap['personcolour'] as String;
      var person = Person(id: id,name: name,colour: colour);

      await repo.updatePerson(person);
      await res.render('personupdated',person.toJson());
    }
  });

  // fire up the server
  print('Starting web server on port $port');
  await http.startServer(hostname, port);

}
