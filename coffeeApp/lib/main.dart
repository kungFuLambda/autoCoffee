import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Auto Coffee',
      theme: ThemeData(
      
        primarySwatch: Colors.brown,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Auto Coffee'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Timer _timer;
  int _start = 90;


  int makeCoffeRequest() {
    String message = "error";
    Socket.connect("192.168.0.53", 6565).then((socket){
      socket.write("make coffee");
      print("request made");
      socket.listen((event) {
        message = utf8.decode(event);
      });
      if (message == "error"){
        return -1;
      }
      return 0;
  } );

  }
  void startTimer() {
  const oneSec = const Duration(seconds: 1);
  _timer = new Timer.periodic(
    oneSec,
    (Timer timer) {
      if (_start == 0) {
        _start=90;
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    },
  );
}
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm coffee'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text('Are you sure you want a cup?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Confirm Espresso'),
              onPressed: () {
                var err = makeCoffeRequest();
                if (err == 0){startTimer();}
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: 
        Column(
        
                  children: [Container(
                    margin: EdgeInsets.all(30),
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(color:Colors.green,shape: BoxShape.circle),
            child:IconButton(
              color: Colors.brown,
              iconSize: 200,
              icon: Icon(Icons.local_drink),
              onPressed: _showMyDialog,
              highlightColor: Colors.red,
          ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
  Text(_start.toString(),style: TextStyle(fontSize: 90),
  ),                  ])));
  }
}
