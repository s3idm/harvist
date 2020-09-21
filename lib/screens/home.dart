import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harvest/screens/users/clients.dart';
import 'package:harvest/screens/users/delivery.dart';
import 'package:harvest/screens/users/vendor.dart';
import 'package:harvest/util/util.dart';
import 'package:provider/provider.dart';
import 'package:harvest/util/database.dart';

class HomeWrapper extends StatefulWidget {
  @override
  _HomeWrapperState createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context) ;
    return FutureBuilder<Users>(
      future: DatabaseService().getAccType(user.uid),
      builder: (context, snapshot) {
        return Scaffold(
          backgroundColor: Color(0xffF0F2F5),
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(40),
            child: AppBar(
              backgroundColor: Colors.green[400],
              title: Text('Harvest'),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(Icons.exit_to_app,size: 16),
                  onPressed: (){
                    DatabaseService().signOut();
                  },
                )
              ],
            ),
          ),
          body: snapshot.hasData ?
          snapshot.data.accType == AccType.client.toString()     ? Clients()
          : snapshot.data.accType == AccType.delivery.toString() ? Delivery()
          : Vendor()
          : Center(child: CircularProgressIndicator()),
        );
      }
    );
  }

}
