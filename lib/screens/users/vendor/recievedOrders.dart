import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harvest/util/applocale.dart';
import 'package:harvest/util/database.dart';
import 'package:harvest/util/util.dart';
import 'package:provider/provider.dart';


class ReceivedOrders extends StatefulWidget {
  @override
  _ReceivedOrdersState createState() => _ReceivedOrdersState();
}

class _ReceivedOrdersState extends State<ReceivedOrders> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size ;
    final User user = Provider.of<User>(context);
    return StreamBuilder<List<Order>>(
      stream: DatabaseService(uid: user.uid).getReceivedOrders,
      builder: (context, snap) {
        if(snap.hasData){
          if(snap.data.length != 0 ){
            return Stack(
              alignment: Alignment.center,
              children: [
                ListView.builder(
                  itemCount: snap.data.length ?? [],
                  itemBuilder: (context,index){
                    return Stack(
                      children: [
                        Container(
                          width: size.width,
                          height: 80,
                          margin: EdgeInsets.fromLTRB(8, 4, 30, 4),
                          decoration: containerRadius(radius: 10),
                        ),
                        Positioned(
                          right: 5,
                          child: Container(
                            width: 80,
                            height: 80,
                            child: Image.network(snap.data[index].url,),
                          ),
                        ),
                        Positioned(
                          right: 100,
                          top: 15,
                          child: Text(
                            langCode(context) == 'ar' ?
                            snap.data[index].nameAR : snap.data[index].nameEN ?? '',
                            style: TextStyle(color: Colors.green[800],fontWeight: FontWeight.bold),
                            textAlign: langCode(context) == 'ar' ?TextAlign.right :TextAlign.left,
                          ),
                        ),
                        Positioned(
                          right: 100,
                          top: 50,
                          child: Text('${snap.data[index].quantity}',
                            style: TextStyle(color: Colors.green[800]),
                            textAlign: langCode(context) == 'ar' ?TextAlign.right :TextAlign.left,
                          ),
                        ),
                        Positioned(
                          right: 140,
                          top: 50,
                          child: Text('kgm',
                            style: TextStyle(color: Colors.green[800]),
                            textAlign: langCode(context) == 'ar' ?TextAlign.right :TextAlign.left,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],
            );
          }else{
            return Text(lang(context, 'noPosts'),
              style: TextStyle(color: Colors.green[800],fontWeight: FontWeight.bold),
            );
          }
        }else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );

  }
}
