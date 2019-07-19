class Location{
  final String name;
  final int id;
  final int locId;

  Location({this.id, this.name, this. locId});

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "locId": locId,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return "Location{id: $id, name: $name, locId: $locId}";
  }
}