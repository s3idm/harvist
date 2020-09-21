import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:harvest/screens/users/addProduct.dart';
import 'package:harvest/util/applocale.dart';
import 'package:harvest/util/database.dart';
import 'package:harvest/util/util.dart';
import 'package:provider/provider.dart';



class MyProducts extends StatefulWidget {
  @override
  _MyProductsState createState() => _MyProductsState();
}

class _MyProductsState extends State<MyProducts> {

  showBottomSheet(){
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context){
        return AddProduct();
      },
    );
  }

  String selectedProduct, productType , currency;
  int index ;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size ;
    final User user = Provider.of<User>(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        StreamBuilder<List>(
            stream: DatabaseService(uid: user.uid).getPostsUID,
            builder: (context, postsUID) {
              if(postsUID.hasData){
                if(postsUID.data.length != 0 ){
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ListView.builder(
                        itemCount: postsUID.data.length ?? [],
                        itemBuilder: (context,index){
                          return StreamBuilder<Posts>(
                              stream: DatabaseService(uid: postsUID.data[index]).getPostedProducts,
                              builder: (context, post) {
                                if(post.hasData){
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
                                          child: Image.network(post.data.url,),
                                        ),
                                      ),
                                      Positioned(
                                        right: 100,
                                        top: 15,
                                        child: Text(
                                          langCode(context) == 'ar' ?
                                          post.data.nameAR : post.data.nameEN ?? '',
                                          style: TextStyle(color: Colors.green[800],fontWeight: FontWeight.bold),
                                          textAlign: langCode(context) == 'ar' ?TextAlign.right :TextAlign.left,
                                        ),
                                      ),
                                      Positioned(
                                        right: 100,
                                        top: 50,
                                        child: Text('${post.data.price}',
                                          style: TextStyle(color: Colors.green[800]),
                                          textAlign: langCode(context) == 'ar' ?TextAlign.right :TextAlign.left,
                                        ),
                                      ),
                                      Positioned(
                                        right: 140,
                                        top: 50,
                                        child: Text('${lang(context, '${post.data.currency}')}',
                                          style: TextStyle(color: Colors.green[800]),
                                          textAlign: langCode(context) == 'ar' ?TextAlign.right :TextAlign.left,
                                        ),
                                      ),
                                      Positioned(
                                        left: 5,
                                        top: 20,
                                        child: IconButton(
                                          icon: Icon(Icons.delete,size: 18,color: Colors.green[900],),
                                          onPressed: (){
                                            DatabaseService(uid: user.uid).deletePost(post.data.postUID) ;
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }else{
                                  return Center(child: CircularProgressIndicator());
                                }
                              }
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
          }
        ),
        Positioned(
          bottom: 8,
          child: Container(
            width: 60,
            child: RawMaterialButton(
              elevation: 5,
              shape: StadiumBorder(),
              onPressed: (){
                setState(() {
                  showBottomSheet();
                });
              },
              fillColor: Colors.green[500],
              child: Icon(Icons.add_box,color: Colors.white,size: 18,),
            ),
          ),
        ),
      ],
    );
  }
}




