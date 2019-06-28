class Location{
  final String name;
  final int freq;
  final int id;

  Location({this.id, this.name, this.freq});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "freq": freq,
    };
  }

  /*Note.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
  }*/

  Location.fromMap(Map<String, dynamic> map) {
    id = "id";
    name = "name";
    freq = "freq";
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Location{id: $id, name: $name, freq: $freq}';
  }
}