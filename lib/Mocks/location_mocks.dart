import '../API/location_model.dart';

class MockLocation extends Location{
  static final List<Location> items = [
    Location(
      id: 1,
      name: "Orlando",
      freq: 5,
    ),
    Location(
      id: 2,
      name: "Los Angles",
      freq: 8,
    ),
    Location(
      id: 3,
      name: "Tampa",
      freq: 10,
    )
  ];

  static List<Location> fetchAll() {
    return MockLocation.items;
  }
}