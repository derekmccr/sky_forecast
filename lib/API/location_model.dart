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

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Location{id: $id, name: $name, freq: $freq}';
  }
}