import 'package:flutter/material.dart';
import 'package:harvest/util/util.dart';
import 'package:harvest/util/database.dart';


class Fruits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: DatabaseService().fruitsStream,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return MyGridView(products: snapshot.data);
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}

class MeatAndChick extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: DatabaseService().meatChickenStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyGridView(products: snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class Milk extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: DatabaseService().milkStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyGridView(products: snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class SeaFood extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: DatabaseService().seafoodStream,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return MyGridView(products: snapshot.data);
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}


class Vegetables extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Product>>(
      stream: DatabaseService().vegetablesStream,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return MyGridView(products: snapshot.data);
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

