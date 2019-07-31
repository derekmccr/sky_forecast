import 'package:flutter/material.dart';
import '../Models/location_database_model.dart';
import '../Services/database_helper.dart';
import 'settings.dart';

//builds stateful widget for appBar to implement saved location button for saved_location_page
class SavedAppBarWidget extends StatefulWidget implements PreferredSizeWidget{
  final Location item;
  SavedAppBarWidget({Key key, this.item}): preferredSize = Size.fromHeight(56.0), super(key: key);

  @override
  final Size preferredSize;

  @override
  _SavedAppBarWidgetState createState() => _SavedAppBarWidgetState();
}

class _SavedAppBarWidgetState extends State<SavedAppBarWidget> {
  final db = DatabaseHelper.instance;
  bool _isSaved = false;

  @override
  void initState() {
    super.initState();

    loadState();
  }

  void _toggleSaved() {
    setState(() {
      if (_isSaved) {
        _isSaved = false;
        removeLocation();
      }
      else {
        _isSaved = true;
        saveLocation();
      }
    });
  }

  loadState() async{
    _isSaved = await db.searchLocation(widget.item.locId);
  }

  removeLocation() async{
    var remove = await db.deleteLocation(widget.item.id);
    if(remove == 1){
      print("location deleted");
    }
  }

  saveLocation() async{
    var save = await db.saveLocation(widget.item);
    if(save != 0){
      print("location added");
    }
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
          icon: (_isSaved ? Icon(Icons.bookmark, color: const Color(0xFF1EB980)) : Icon(Icons.bookmark_border, color: const Color(0xFF1EB980))),
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