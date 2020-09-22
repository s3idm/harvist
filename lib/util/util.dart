import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:harvest/screens/users/commen/maps.dart';
import 'dart:ui';
import 'package:harvest/util/applocale.dart';



bool loading = false ;

enum SignInUp{
  LogIn,
  SignUp,
}

enum AccType {
  client,
  delivery,
  farmer,
}

class Product{
  final String nameAR,nameEN , url;
  Product({this.nameAR, this.nameEN, this.url});
}

class Posts{
  final String nameAR,nameEN , url ,currency,price,type,vendorUID , postUID ;
  Posts({this.postUID, this.currency, this.price, this.type, this.vendorUID,this.nameAR, this.nameEN, this.url});
}


class Users {
  final String name ,uid , phone , cCode  ,accType ;
  Users({this.name, this.uid, this.phone, this.cCode, this.accType});
}


class MyTextField extends StatelessWidget {
  const MyTextField ({ @required this.size, this.label, this.textInputType, this.obscure, this.onChanged, this.preWidget });

  final Size size;
  final String label ;
  final TextInputType textInputType ;
  final bool obscure ;
  final Function onChanged ;
  final Widget preWidget ;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width*.8,
      height: 45,
      child: TextField(
        onChanged: onChanged ,
        cursorColor: Colors.green,
        style: TextStyle(color: Colors.green),
        textAlign: TextAlign.center,
        keyboardType: textInputType,
        obscureText: obscure ?? false,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.green,fontSize: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(width: 1,color: Colors.green),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50),
            borderSide: BorderSide(width: 1,color: Colors.green),
          ),
          border: InputBorder.none
        ),
      ),
    );
  }
}


class Button extends StatelessWidget {
  const Button({ this.onPressed, this.title, this.hasBorders}) ;

  final Function onPressed;
  final String title ;
  final bool hasBorders;

  @override
  Widget build(BuildContext context) {
    return OutlineButton(
      onPressed: onPressed,
      child: Text(title,textAlign: TextAlign.center,),
      shape: StadiumBorder(),
      textColor: hasBorders ? Colors.green[600] : Colors.greenAccent,
      splashColor: Colors.black45,
      borderSide: hasBorders ? BorderSide(width: 1.2,color: Colors.green) : BorderSide.none,
      highlightedBorderColor: Colors.white,
    );
  }
}


BoxDecoration containerBorders(){
  return BoxDecoration(
    border: Border.all(color: Colors.green,width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(50),),
  );
}
BoxDecoration containerRadius({double radius,Color color}){
  return BoxDecoration(
    color: Colors.white,
    boxShadow: [BoxShadow(color: Colors.black.withOpacity(.12),offset: Offset(3, 3),blurRadius: 3,spreadRadius: 2)],
    borderRadius: BorderRadius.all(Radius.circular(radius),
    ),
  );
}

class BlurContainer extends StatelessWidget {

  BlurContainer({   @required this.size,}) ;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5.0,sigmaY: 5.0),
        child: Container(
          width: size.width*.9,
          height: size.height*.55,
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}

class MyCountryCode extends StatelessWidget {
  final Function onChanged , onInit;
  const MyCountryCode({this.onChanged, this.onInit});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      width: 50,
      decoration: containerBorders(),
      child: CountryCodePicker(
        onChanged: onChanged,
        showFlag: false,
        hideSearch: true,
        textStyle: TextStyle(color: Colors.green,fontSize: 12),
        initialSelection: 'EG',
        favorite: ['SA','EG','AE','SY','OM','MC','KW','JO','IR','IQ','PS','QA','BH','YE','TN','DZ','LB','LY'],
        showFlagDialog: true,
        comparator: (a, b) => b.name.compareTo(a.name),
        onInit: onInit,
      ),
    );
  }
}



class ProductsList extends StatelessWidget {

  final String title, selectedProduct;
  final List<Product> productList;
  final Function onChanged;
  const ProductsList({this.title, this.productList, this.onChanged, this.selectedProduct});


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .9,
          decoration: containerRadius(radius: 50, color: Colors.white),
          child: Center(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                items: productList.map((Product product) {
                  return DropdownMenuItem<String>(
                    value: langCode(context) == 'ar' ? product.nameAR : product.nameEN,
                    child: Center(child: Text(langCode(context) == 'ar' ? product.nameAR : product.nameEN,
                      style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
                icon: Padding(
                  padding: EdgeInsets.only(right: 8),
                  child: Icon(Icons.arrow_drop_down, color: Colors.green,),
                ),
                hint: Center(
                    child: selectedProduct == null ? Text(title, style: TextStyle(color: Colors.green[400]), textAlign: TextAlign.right,)
                    : Text(selectedProduct, style: TextStyle(color: Colors.green[800]), textAlign: TextAlign.right,)),
                isExpanded: true,
                autofocus: false,
              ),
            ),
          ),
        ),
      ],
    );
  }
}


class MyGridView extends StatelessWidget {
  const MyGridView({@required this.products,}) ;

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size ;
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,childAspectRatio: 1.5),
        itemCount: products.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: GestureDetector(
              onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ResultsInMaps(product: products[index].nameEN )));
              },
              child: Stack(
                alignment: Alignment.topCenter,
                overflow: Overflow.visible,
                children: [
                  Container(
                    height: size.height*.2,
                    width: size.width*.45,
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                        height: size.height*.12,
                        width: size.width*.45,
                        decoration: containerRadius(color: Colors.greenAccent[100],radius: 10)
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Container(
                      height: size.width*.22,
                      width: size.width*.22,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(products[index].url),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 15,
                    child: Text(
                      langCode(context) == 'ar' ?
                      products[index].nameAR : products[index].nameEN,
                      style: TextStyle(fontSize:13,color: Colors.green[800],fontWeight: FontWeight.bold),textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }
}
