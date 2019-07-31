import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import '../Models/location_search_model.dart';
import 'searched_location_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => new _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  GlobalKey<AutoCompleteTextFieldState<Places>> key = new GlobalKey();

  AutoCompleteTextField searchTextField;

  TextEditingController controller = new TextEditingController();

  _SearchPageState();

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
          title: Text("Search", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: Center(
          child: Column(
            children: <Widget>[
              Column(children: <Widget>[
                searchTextField = AutoCompleteTextField<Places>(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 20.0),
                    filled: true,
                    hintText: "Search City",
                    hintStyle: TextStyle(color: Colors.white)
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
                              builder: (context) => SearchedLocationPage(place: item,),
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
          Text(item.name, style: TextStyle(color: Colors.white)),
          Padding(
            padding: EdgeInsets.all(15.0),
          ),
          Text(item.country, style: TextStyle(color: Colors.white))
        ],
      ),
    );
  }
}