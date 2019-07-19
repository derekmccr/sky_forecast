import 'package:flutter/material.dart';
import '../Models/location_database_model.dart';
import '../Models/location_search_model.dart';
import '../Services/database_helper.dart';

class SavedWidget extends StatefulWidget {
  final Places item;
  SavedWidget({Key key, this.item});

  @override
  _SavedWidgetState createState() => _SavedWidgetState();
}

class _SavedWidgetState extends State<SavedWidget> {
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
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(0),
          child: IconButton(
            icon: (_isSaved ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border)),
            onPressed: _toggleSaved,
          ),
        ),
      ],
    );
  }
}