import 'package:flutter/material.dart';
import 'package:harvest/screens/users/commen/maps.dart';
import 'package:harvest/util/util.dart';
import 'package:harvest/util/applocale.dart';
import 'package:harvest/util/database.dart';


class Fruits extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size ;
    return StreamBuilder<List<Product>>(
      stream: DatabaseService().fruitsStream,
      builder: (context, snapshot) {
        if(snapshot.hasData){
          return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.5),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> ResultsInMaps(product: snapshot.data[index].nameEN )));
                    },
                    child: Stack(
                      alignment: Alignment.topCenter,
                      overflow: Overflow.visible,
                      children: [
                        Container(
                          height: size.width*.2,
                          width: size.width*.45,
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            height: size.width*.2,
                            width: size.width*.45,
                            decoration: containerRadius(color: Colors.white,radius: 10)
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: Container(
                            height: size.width*.22,
                            width: size.width*.22,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: NetworkImage(snapshot.data[index].url),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 15,
                          child: Text(
                            langCode(context) == 'ar' ?
                            snapshot.data[index].nameAR : snapshot.data[index].nameEN,
                            style: TextStyle(fontSize:13,color: Colors.green[800],fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                        ),
                      ],
                    ),
                  ),
                );
              }
          );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }
}
