import 'package:flutter/material.dart';

//TODO: layout


//page for create contact form, data will be sent to local database
class LocationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //want appBar to be transparent and share background of whole page, thus need for use of stack
    return new Stack(
      children: <Widget>[
        new Container(
          height: double.infinity,
          width: double.infinity,
          //this decorations sets background of full page
          decoration: new BoxDecoration(
            color: Colors.blueGrey,
          ),
        ),
        new Scaffold(
            backgroundColor: Colors.transparent,
            appBar: new AppBar(
              title: new Text("Weather"),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
            ),
            body: new Center(
                child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Expanded(
                        //this column will hold current weather for location
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Text('Orlando', style: new TextStyle(fontSize: 32.0)),
                            new Text("Rain", style: new TextStyle(fontSize: 20.0)),
                            new Text("72°F"),
                            new Image.network("https://openweathermap.org/img/w/01d.png"),
                            new Text("May 13, 2019"),
                            new Text("1:00 PM"),
                            new IconButton(
                                icon: new Icon(Icons.refresh),
                                tooltip: 'Refresh',
                                onPressed: () {

                                }
                            ),
                            /*Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new Column(
                          children: <Widget>[
                            new Text('Orlando'),
                            new Text("Rain", style: new TextStyle(fontSize: 32.0)),
                            new Text("72°F"),
                            new Image.network("https://openweathermap.org/img/w/01d.png"),
                            new Text("May 13, 2019"),
                            new Text("1:00 PM"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: new IconButton(
                          icon: new Icon(Icons.refresh),
                          tooltip: 'Refresh',
                          onPressed: () {

                          }
                        ),
                      ),*/
                          ],
                        ),
                      ),
                      //safe area ensures bottom wont be affected by phone screen obstructions
                      new SafeArea(
                        minimum: EdgeInsets.all(8.0),
                        child: new Container(
                          height: 200.0,
                          //TODO: these cards will be housed by list builder once api connection established
                          //cards will house future forecast for location
                          child: new Card(
                            child: new Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new Text("Orlando", style: new TextStyle(color: Colors.black)),
                                  new Text("Rain", style: new TextStyle(color: Colors.black, fontSize: 24.0)),
                                  new Text("72°F",  style: new TextStyle(color: Colors.black)),
                                  new Image.network("https://openweathermap.org/img/w/01d.png"),
                                  new Text("May 14, 2019", style: new TextStyle(color: Colors.black)),
                                  new Text("1:00 PM", style: new TextStyle(color: Colors.black)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ]
                )
            )
        )
      ],
    );
    /*return new Scaffold(
      backgroundColor: Colors.blueGrey,
      body: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            new Expanded(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new Column(
                      children: <Widget>[
                        new Text('Orlando'),
                        new Text("Rain", style: new TextStyle(fontSize: 32.0)),
                        new Text("72°F"),
                        new Image.network("https://openweathermap.org/img/w/01d.png"),
                        new Text("May 13, 2019"),
                        new Text("1:00 PM"),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: new IconButton(
                      icon: new Icon(Icons.refresh),
                      tooltip: 'Refresh',
                      onPressed: () {

                      }
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              child: new Padding(
                padding: const EdgeInsets.all(8.0),
                child: new Container(
                  height: 200.0,
                  child: new Card(
                    child: new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text("Orlando", style: new TextStyle(color: Colors.black)),
                          new Text("Rain", style: new TextStyle(color: Colors.black, fontSize: 24.0)),
                          new Text("72°F",  style: new TextStyle(color: Colors.black)),
                          new Image.network("https://openweathermap.org/img/w/01d.png"),
                          new Text("May 14, 2019", style: new TextStyle(color: Colors.black)),
                          new Text("1:00 PM", style: new TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]
        )
      )
    );*/
  }
}
