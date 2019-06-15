import 'package:flutter/material.dart';
import '../util/utils.dart' as util;
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {


  String cityEntered;
  Future goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new ChangeCity();
    }));
    if (results != null && results.containsKey('enter')) {
      cityEntered = results['enter'];
      updateTempWidget(cityEntered);
    }
  }

  void showStuff() async {
    Map data = await getWeather(util.appId, util.defaultCity);
    print(data.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("TempCheck"),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.search),
              onPressed: () {
                goToNextScreen(context);
              })
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
              child: new Image.asset(
            'images/one1.jpg',
            width: 490.0,
            fit: BoxFit.fill,
            height: 1200.0,
          )),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text(
              '${cityEntered == null ? util.defaultCity : cityEntered}',
              style: cityStyle(),
            ),
          ),
          new Container(
              alignment: Alignment.topLeft,
              child: new Image.asset('images/light_rain.png')),
          new Container(
            margin: const EdgeInsets.fromLTRB(190.0, 380.0, 0.0, 0.0),
            child: updateTempWidget(cityEntered),
          )
        ],
      ),
      drawer: new Drawer(
        child: new Container(
          color: Colors.black,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text(
                "Handcrafted with ❤️ by antew",
                style: new TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String apiUrl =
        "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=metric";

    http.Response response = await http.get(apiUrl);

    return json.decode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
        future: getWeather(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
                child: new Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                new ListTile(
                  title: new Text(
                    "${content['main']['temp'].toString()}°C",
                    style: tempStyle(),
                  ),
                  subtitle: new ListTile(
                    title: new Text(
                      "Humidity:  ${content['main']['humidity'].toString()}%\n"
                         "Min: ${content['main']['temp_min']}°C\n"
                           "Max: ${content['main']['temp_max']}°C",
                           style: otherStyle(),
                    ),
                  ),
                ),
                
              ],
            ));
          } else {
            return new Container();
          }
        });
  }
}

TextStyle cityStyle() {
  return new TextStyle(
      color: Colors.white, 
      fontSize: 30.9, 
      fontStyle: FontStyle.italic);
}

TextStyle tempStyle() {
  return new TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 52.9);
}

TextStyle otherStyle() {
  return new TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.w500,
      fontSize: 20.9);
}



class ChangeCity extends StatelessWidget {
  var cityFieldController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.black,
        title: new Text("Search City"),
        centerTitle: true,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              'images/white_snow.png',
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(
                  decoration: new InputDecoration(hintText: 'Enter City'),
                  controller: cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),
              new ListTile(
                title: new FlatButton(
                  onPressed: () {
                    Navigator.pop(context, {'enter': cityFieldController.text});
                  },
                  color: Colors.black,
                  child: new Text(
                    'Get Weather',
                    style: new TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
