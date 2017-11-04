import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'dart:convert';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'MyZIS',
      theme: new ThemeData(
        primarySwatch: Colors.amber,
      ),
      home: new MyHomePage(title: 'MyZIS'),
      routes: <String, WidgetBuilder> {
        '/USBlogPage': (BuildContext context) => new USBlogPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        centerTitle: true,
        title: new Text(widget.title),
      ),
      body: new GridView.count(
        padding: const EdgeInsets.all(20.0),
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        children: <Widget>[
          new HomeCard(
            text: 'Announcements',
            route: '/USBlogPage',
          ),
          new HomeCard(
            text: 'ATAC',
          ),
          new HomeCard(
            text: 'Lion\'s Journal',
          ),
          new HomeCard(
            text: 'Schedule',
          ),
          new HomeCard(
            text: 'Clubs',
          ),
          new HomeCard(
            text: 'Calendar',
          ),
          new HomeCard(
            text: 'ETC',
          ),
          new HomeCard(
            text: 'Settings',
          ),
        ],
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard({
    Key key,
    this.text,
    this.route,
    this.textSize: 18.0,
    this.cardColor: const Color(0xFF005A84),
    this.textColor: Colors.white,
  }) : super(key: key);

  final Color cardColor;
  final Color textColor;
  final String text;
  final double textSize;
  final String route;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route == null ? "/" : route);
      },
      child: new Card(
        color: cardColor,
        child: new Column(
          children: <Widget>[
            new Text(text, style: new TextStyle(fontWeight: FontWeight.bold, color: textColor, fontSize: textSize)),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }
}

class USBlogPage extends StatefulWidget {
  USBlogPage({Key key}) : super(key: key);

  static const String routeName = "/USBlogPage";

  @override
  _USBlogPageState createState() => new _USBlogPageState();
}


class _USBlogPageState extends State<USBlogPage> {
  List data;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Announcements"),
      ),
      body: new ListView.builder(
        padding: new EdgeInsets.only(bottom: 20.0, top: 0.0, left: 8.0, right: 8.0),
        itemCount: data == null ? 0 : data.length,

        itemBuilder: (BuildContext context, int index) {
            //Fetches complete post
            return new Card(
              child: new Column(
                children: <Widget>[
                  new Padding(
                    padding: new EdgeInsets.only(top: 4.0, left: 8.0),
                    child: new Text(
                      data[index]['title']['rendered'].replaceAll(new RegExp(r'<p>|</p>|\[.*\]|\&.*;'), ''),
                      style: new TextStyle(fontWeight: FontWeight.bold,color: new Color(0xFF005A84)),
                    ),
                  ),
                  //TODO Insert Date and Author
                  new Padding(
                    padding: new EdgeInsets.all(8.0),
                    child: new Text(
                      data[index]['content']['rendered'].toString().replaceAll(new RegExp(r'<p>|</p>|\&.*;'), '').replaceAll(new RegExp(r'.\[.*\]'), '...'),
                      style: new TextStyle(color: new Color(0xFF005A84)),
                    ),
                  ),
                ],
              ),
            );
        },
      ),
    );
  }

  fetch_posts() async{
    var httpClient = createHttpClient();
    var response = await httpClient.get("https://blogs.zis.ch/us/wp-json/wp/v2/posts");
    setState((){
      data = JSON.decode(response.body);
    });
  }

  @override
  void initState() {
    fetch_posts();
  }
}
