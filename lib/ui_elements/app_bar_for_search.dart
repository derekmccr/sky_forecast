import 'package:flutter/material.dart';
import '../Models/location_search_model.dart';
import '../Models/location_database_model.dart';
import '../Services/database_helper.dart';
import 'settings.dart';

class SearchedAppBarWidget extends StatefulWidget {
  final Places item;
  SearchedAppBarWidget({Key key, this.item});

  @override
  _SearchedAppBarWidgetState createState() => _SearchedAppBarWidgetState();
}

class _SearchedAppBarWidgetState extends State<SearchedAppBarWidget> {
  final DatabaseHelper db = DatabaseHelper();
  var _isSaved;

  @override
  void initState() {
    super.initState();

    _isSaved = db.searchLocation(widget.item.id);
  }

  void _toggleSaved() {
    setState(() {
      if (_isSaved) {
        _isSaved = false;
        db.deleteLocation(widget.item.id);
      }
      else {
        _isSaved = true;
        Location save = new Location(
          locId: widget.item.id,
          name: widget.item.name,
        );
        db.saveLocation(save);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
          icon: Icon(Icons.home, color: const Color(0xFF1EB980)),
          onPressed: (){
            Navigator.of(context).popUntil((route) => route.isFirst);
          }
      ),
      title: Text("Weather", style: TextStyle(fontWeight: FontWeight.bold)),
      actions: <Widget>[
        IconButton(
          icon: (_isSaved ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border)),
          onPressed: _toggleSaved,
        ),
        IconButton(
          icon: Icon(Icons.more_vert, color: const Color(0xFF1EB980)),
          onPressed: (){
            Navigator.push(context,
              MyCustomRoute(builder: (context) => SettingsPage()),
            );
          },
        )
      ],
    );
  }
}

//this class ONLY controls animation between pages
//NO NEED FOR FURTHER MODIFICATION
class MyCustomRoute<T> extends MaterialPageRoute<T> {
  MyCustomRoute({WidgetBuilder builder, RouteSettings settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (settings.isInitialRoute) return child;
    // Fades between routes. (If you don't want any animation,
    // just return child.)
    return new FadeTransition(opacity: animation, child: child);
  }
}