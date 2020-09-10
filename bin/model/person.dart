
class Person {
  int id;
  String name;
  String colour;

  Person({this.id, this.name, this.colour});

  factory Person.fromSQL(List<dynamic> row) {
    return Person(id: row[0], name: row[1], colour: row[2]);
  }

  Map<String,Object> toJson() => {'id': id, 'name': name, 'colour': colour};

}
