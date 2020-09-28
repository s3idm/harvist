import 'package:flutter/material.dart';
import 'package:harvest/screens/users/commen/store.dart';
import 'package:harvest/screens/users/vendor/recievedOrders.dart';
import 'package:harvest/util/applocale.dart';

import 'myProducts.dart';

class Vendor extends StatefulWidget {

  @override
  _VendorState createState() => _VendorState();
}

class _VendorState extends State<Vendor>with SingleTickerProviderStateMixin {
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
    return Scaffold(
      backgroundColor: Color(0xfff0f2f5),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                StorePage(),
                MyProducts(),
                ReceivedOrders(),
              ],
            ),
          ),
          Container(
            height: 40,
            color: Colors.white,
            child: TabBar(
              labelColor: Colors.green[900],
              controller: tabController,
              isScrollable: false,
              unselectedLabelColor: Colors.greenAccent[700],
              indicatorColor: Colors.red,
              labelStyle: TextStyle(fontWeight: FontWeight.bold,fontSize: 14,fontFamily: 'TajawalRegular'),
              tabs: [
                Row(
                  children: [
                    Text(lang(context, 'store')),
                    Icon(Icons.store)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
                Row(
                  children: [
                    Text(lang(context, 'myPosts')),
                    Icon(Icons.add_box)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
                Row(
                  children: [
                    Text(lang(context, 'orders')),
                    Icon(Icons.format_list_numbered_rtl,)
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
