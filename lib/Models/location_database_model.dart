class Location{
  final String name;
  final int id;
  final int locId;

  Location({this.id, this.name, this.locId});

  factory Location.fromMap(Map<String, dynamic> json) => new Location(
    id: json["id"],
    name: json["name"],
    locId: json["locId"]
  );

  Map<String, dynamic> toMap() => {
    "locId": locId,
    "name": name,
  };

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return "Location{id: $id, name: $name}";
  }
}