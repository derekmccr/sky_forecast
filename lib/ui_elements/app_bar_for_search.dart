import 'package:flutter/material.dart';
import '../Models/location_search_model.dart';
import '../Services/database_helper.dart';
import 'settings.dart';


class SearchedAppBarWidget extends StatefulWidget implements PreferredSizeWidget{
  final Places item;
  SearchedAppBarWidget({Key key, this.item}): preferredSize = Size.fromHeight(56.0), super(key: key);

  @override
  final Size preferredSize;

  @override
  _SearchedAppBarWidgetState createState() => _SearchedAppBarWidgetState();
}

class _SearchedAppBarWidgetState extends State<SearchedAppBarWidget> {
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
        removePlace();
      }
      else {
        _isSaved = true;
        savePlace();
      }
    });
  }

  loadState() async{
    _isSaved = await db.searchLocation(widget.item.id);
  }

  removePlace() async{
    var remove = await db.deletePlace(widget.item.id);
    if(remove == 1){
      print("place deleted");
    }
  }

  savePlace() async{
    var save = await db.savePlace(widget.item);
    if(save != 0){
      print("place added");
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
          icon: (_isSaved ? Icon(Icons.bookmark, color: const Color(0xFF1EB980)) : Icon(Icons.bookmark_border)),
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