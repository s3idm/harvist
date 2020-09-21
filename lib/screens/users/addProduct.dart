import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:harvest/util/applocale.dart';
import 'package:harvest/util/database.dart';
import 'package:harvest/util/util.dart';
import 'package:provider/provider.dart';


class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String selectedProduct, productType , currency , price , _currency;
  int index ;
  Product postedProduct ;



  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size ;
    final User user = Provider.of<User>(context) ;

    buildExtra(BuildContext context ){
      switch (index){
        case 0 :
          return FutureBuilder<List<Product>>(
              future: DatabaseService().getFruits(),
              builder: (context, snapshot) {
                return ProductsList(
                  title: lang(context, 'fruits'),
                  productList: snapshot.data ?? [],
                  onChanged: (String product) {
                    setState(() {
                      selectedProduct = product ;
                      snapshot.data.forEach((element) {
                        if(element.nameEN == product  || element.nameAR == product){
                          postedProduct = element ;
                        }
                      });
                    });
                  },
                  selectedProduct: selectedProduct,
                );
              }
          ) ;
        case 1 :
          return FutureBuilder<List<Product>>(
              future: DatabaseService().getVegetables(),
              builder: (context, snapshot) {
                return ProductsList(
                  title: lang(context, 'vegetables'),
                  productList: snapshot.data ?? [],
                  onChanged: (String product) {
                    setState(() {
                      selectedProduct = product ;
                      snapshot.data.forEach((element) {
                        if(element.nameEN == product  || element.nameAR == product){
                          postedProduct = element ;
                        }
                      });
                    });
                  },
                  selectedProduct: selectedProduct,
                );
              }
          );
        case 2:
          return FutureBuilder<List<Product>>(
              future: DatabaseService().getMeatChicken(),
              builder: (context, snapshot) {
                return ProductsList(
                  title: lang(context, 'meats'),
                  productList: snapshot.data ?? [],
                  onChanged: (String product) {
                    setState(() {
                      selectedProduct = product ;
                      snapshot.data.forEach((element) {
                        if(element.nameEN == product  || element.nameAR == product){
                          postedProduct = element ;
                        }
                      });
                    });
                  },
                  selectedProduct: selectedProduct,
                );
              }
          );
        case 3:
          return FutureBuilder<List<Product>>(
              future: DatabaseService().getSeafood(),
              builder: (context, snapshot) {
                return ProductsList(
                  title: lang(context, 'seafood'),
                  productList: snapshot.data ?? [],
                  onChanged: (String product) {
                    setState(() {
                      selectedProduct = product ;
                      snapshot.data.forEach((element) {
                        if(element.nameEN == product  || element.nameAR == product){
                          postedProduct = element ;
                        }
                      });
                    });
                  },
                  selectedProduct: selectedProduct,
                );
              }
          );
        case 4:
          return FutureBuilder<List<Product>>(
              future: DatabaseService().getMilk(),
              builder: (context, snapshot) {
                return ProductsList(
                  title: lang(context, 'milk'),
                  productList: snapshot.data ?? [],
                  onChanged: (String product) {
                    setState(() {
                      selectedProduct = product ;
                      snapshot.data.forEach((element) {
                        if(element.nameEN == product  || element.nameAR == product){
                          postedProduct = element ;
                        }
                      });
                    });
                  },
                  selectedProduct: selectedProduct,
                );
              }
          );
        default :
          return SizedBox();
      }
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipPath(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0,sigmaY: 5.0),
            child: Container(
              width: size.width,
              decoration: containerRadius(radius: 15).copyWith(color: Colors.white.withOpacity(.25)),
            ),
          ),
        ),
        Positioned(
          top: 50,
          child: Container(
            width: size.width*.9,
            decoration: containerRadius(radius: 50,color: Colors.white),
            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Center(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  items: <String>[
                    lang(context, 'fruits'),
                    lang(context, 'vegetables'),
                    lang(context, 'meats'),
                    lang(context, 'seafood'),
                    lang(context, 'milk'),
                  ].map((String productType) {
                    return DropdownMenuItem<String>(
                      value: productType,
                      child: Center(child: Text(productType, style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold,fontSize: 14),),),
                    );
                  }).toList(),
                  onChanged: (selected){
                    setState(() {
                      selectedProduct = null ;
                      productType = selected ;
                      if(selected == lang(context, 'fruits'))
                        index = 0 ;
                      if(selected == lang(context, 'vegetables'))
                        index = 1 ;
                      if(selected == lang(context, 'meats'))
                        index = 2 ;
                      if(selected == lang(context, 'seafood'))
                        index = 3 ;
                      if(selected == lang(context, 'milk'))
                        index = 4 ;
                    });
                  },
                  icon: Padding( padding: EdgeInsets.only(right: 8),child: Icon(Icons.arrow_drop_down, color: Colors.green,),),
                  hint: Center(child: productType == null
                      ?Text(lang(context, 'productType'),style: TextStyle(color: Colors.green[400]),textAlign: TextAlign.right,)
                      :Text(productType,style: TextStyle(color: Colors.green[800]),textAlign: TextAlign.right,)),
                  isExpanded: true,
                  autofocus: false,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 110,
          child: buildExtra(context),
        ),
        selectedProduct != null ?
        Positioned(
          top: 170,
          width: size.width*.9,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: size.width*.43,
                decoration: containerRadius(radius: 50,color: Colors.white),
                padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                child: Center(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      items: <String>[
                        lang(context, 'EGP'),
                        lang(context, 'SR'),
                        lang(context, 'AED'),
                        lang(context, 'dollar'),
                      ].map((String currency) {
                        return DropdownMenuItem<String>(
                          value: currency,
                          child: Center(child: Text(currency,
                            style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold,fontSize: 14),),
                          ),
                        );
                      }).toList(),
                      onChanged: (selected){
                        setState(() {
                          currency = selected ;
                          if(selected == lang(context, 'EGP'))_currency = 'EGP' ;
                          if(selected == lang(context, 'SR'))_currency = 'SR' ;
                          if(selected == lang(context, 'AED'))_currency = 'AED' ;
                          if(selected == lang(context, 'dollar'))_currency = 'dollar' ;
                        });
                      },
                      icon: Padding( padding: EdgeInsets.only(right: 8),child: Icon(Icons.arrow_drop_down, color: Colors.green,),),
                      hint: Center(child: currency == null
                          ?Text(lang(context, 'currency'),style: TextStyle(color: Colors.green[400]),textAlign: TextAlign.right,)
                          :Text(currency,style: TextStyle(color: Colors.green[800]),textAlign: TextAlign.right,)),
                      isExpanded: true,
                      autofocus: false,
                    ),
                  ),
                ),
              ),
              Container(
                width: size.width*.43,
                padding: EdgeInsets.symmetric(horizontal: 8),
                decoration: containerRadius(color: Colors.white,radius: 50),
                child: TextField(
                  onChanged: (val){
                    price = val ;
                  },
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.green[700]),
                  cursorColor: Colors.red,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: lang(context, 'price'),
                    hintStyle: TextStyle(color: Colors.green[400]),
                    enabledBorder:InputBorder.none,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ) :
        SizedBox(),
        Positioned(
          bottom: 50,
          child: Container(
            child: RawMaterialButton(
              elevation: 5,
              shape: StadiumBorder(),
              onPressed: ()async{
                if(productType != null && price != null && postedProduct != null) {
                  await DatabaseService().addProductPost(
                    type: productType,
                    currency: _currency ,
                    price: price,
                    vendorUID: user.uid,
                    nameEN: postedProduct.nameEN,
                    nameAR: postedProduct.nameAR,
                    url: postedProduct.url,
                    postUID: '${user.uid}${postedProduct.nameEN}'
                  );
                  Navigator.pop(context);
                }
              },
              fillColor: Colors.green[500],
              child: Image.asset('assets/chick.png',scale: 2,)
            ),
          ),
        ),
      ],
    );
  }

}

