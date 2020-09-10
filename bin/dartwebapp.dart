import 'dart:convert';

import 'package:angel_framework/angel_framework.dart';
import 'package:angel_framework/http.dart';
import 'package:angel_mustache/angel_mustache.dart';

import 'db/personrepository.dart';

import 'package:file/local.dart';


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
    print('list db');
    var repo = PersonRepository();
    var persons = await repo.getPersons();
    var jsonRaw = persons.map((e) => e.toJson()).toList();
    var jsonData = { 'people' : jsonRaw };

    await res.render('list',jsonData);
    });

  app.post('/delete', (req, res) async {
    print('delete');
    var id = req.queryParameters['id'];
    print('id $id');
  });

  print('Starting web server on port $port');
  await http.startServer(hostname, port);

}
