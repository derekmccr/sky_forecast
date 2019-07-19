import 'package:sky_forecast/Models/location_database_model.dart';

class MockLocation extends Location{
  static final List<Location> items = [
    Location(
      id: 1,
      name: "Orlando",
      locId: 4167147,
    ),
    Location(
      id: 2,
      name: "Los Angles",
      locId: 5368361,
    ),
    Location(
      id: 3,
      name: "Tampa",
      locId: 4174757,
    )
  ];

  static List<Location> fetchAll() {
    return MockLocation.items;
  }
}