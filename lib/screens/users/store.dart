import 'package:harvest/screens/products/fruits.dart';
import 'package:harvest/screens/products/meats.dart';
import 'package:harvest/screens/products/vegetables.dart';
import 'package:flutter/material.dart';
import 'package:harvest/util/applocale.dart';

class StorePage extends StatefulWidget {
  @override
  _StorePageState createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> with SingleTickerProviderStateMixin{
  TabController clientTabController ;

  @override
  void initState() {
    clientTabController = TabController(length: 3, vsync: this);
    super.initState();
  }
  @override
  void dispose() {
    clientTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size ;
    return Container(
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              Container(
                height: 40,
                color: Colors.white,
                child: TabBar(
                  labelColor: Colors.green[900],
                  controller: clientTabController,
                  unselectedLabelColor: Colors.greenAccent[700],
                  indicatorColor: Colors.red,
                  labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,fontFamily: 'TajawalRegular'),
                  tabs: [
                    Text(lang(context, 'fruits')),
                    Text(lang(context, 'vegetables')),
                    Text(lang(context, 'meat')),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  controller: clientTabController,
                  children: [
                    Fruits(),
                    Vegetables(),
                    Meats(),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: 60,
              child: RawMaterialButton(
                elevation: 5,
                shape: StadiumBorder(),
                onPressed: (){},
                fillColor: Colors.green[500],
                child: Icon(Icons.local_grocery_store,color: Colors.white,size: 18,),
              ),
            ),
          )
        ],
      ),
    );
  }
}
