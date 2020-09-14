import '../database.dart';
import 'package:flutter/material.dart';


class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red ,
      body: Center(
        child: RaisedButton(
          onPressed: (){DatabaseService().signOut();},
          child: Text('Sign Out'),
          color: Colors.white,
        ),
      ),
    );
  }
}
