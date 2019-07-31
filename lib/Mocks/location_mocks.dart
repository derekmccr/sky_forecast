import 'package:sky_forecast/Models/location_database_model.dart';

class MockLocation extends Location{
  static final List<Location> items = [
    Location(
      id: 4167147,
      name: "Orlando",
    ),
    Location(
      id: 5368361,
      name: "Los Angles",
    ),
    Location(
      id: 4174757,
      name: "Tampa",
    )
  ];

  static List<Location> fetchAll() {
    return MockLocation.items;
  }
}