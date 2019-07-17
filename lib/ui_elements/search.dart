import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import '../Models/location_search_model.dart';
import 'searched_location_page.dart';

class AutoComplete extends StatefulWidget {
  @override
  _AutoCompleteState createState() => new _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {
  GlobalKey<AutoCompleteTextFieldState<Places>> key = new GlobalKey();

  AutoCompleteTextField searchTextField;

  TextEditingController controller = new TextEditingController();

  _AutoCompleteState();

  void _loadData() async {
    await PlacesViewModel.loadPlaces();
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Search"),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Column(children: <Widget>[
                searchTextField = AutoCompleteTextField<Places>(
                  decoration: InputDecoration(
                    suffixIcon: Container(
                      width: 85.0,
                      height: 60.0,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                    filled: true,
                    hintText: "Search Location",
                    hintStyle: TextStyle(color: Colors.black)
                  ),
                  itemSubmitted: (item) {
                    setState(() => searchTextField.textField.controller.text = item.name);
                  },
                  clearOnSubmit: false,
                  key: key,
                  suggestions: PlacesViewModel.places,
                  itemBuilder: (context, item) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(
                              builder: (context) => SearchedLocationPage(item),
                            )
                        );
                      },
                      child: _itemCard(item),
                    );
                  },
                  itemSorter: (a, b) {
                    return a.name.compareTo(b.name);
                  },
                  itemFilter: (item, query) {
                    return item.name.toLowerCase().startsWith(query.toLowerCase());
                  }
                ),
              ]),
          ])
        )
    );
  }

  Widget _itemCard(Places item){
    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(item.name),
          Padding(
            padding: EdgeInsets.all(15.0),
          ),
          Text(item.country)
        ],
      ),
    );
  }
}