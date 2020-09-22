import 'package:flutter/material.dart';
import 'package:harvest/util/applocale.dart';
import 'productsTaps.dart';


class Meats extends StatefulWidget {


  @override
  _MeatsState createState() => _MeatsState();
}

class _MeatsState extends State<Meats> with SingleTickerProviderStateMixin{
  TabController tabController ;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }
  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 40,
          color: Colors.white,
          margin: EdgeInsets.fromLTRB(0, 1.5, 0, 0),
          child: TabBar(
            labelColor: Colors.green[800],
            controller: tabController,
            unselectedLabelColor: Colors.greenAccent[700],
            labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,fontFamily: 'TajawalRegular'),
            indicatorColor: Colors.green[400],
            tabs: [
              Text(lang(context, 'seafood')),
              Text(lang(context, 'meats')),
              Text(lang(context, 'milk')),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              SeaFood(),
              MeatAndChick(),
              Milk(),
            ],
          ),
        )
      ],
    );
  }
}
