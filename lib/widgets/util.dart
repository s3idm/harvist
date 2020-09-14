import 'package:flutter/material.dart';
import 'dart:ui';

Color kDarkBackground = Color(0xff252427);


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
      textColor: hasBorders ? Colors.green : Colors.greenAccent,
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
            borderRadius: BorderRadius.circular(20)

          ),
        ),
      ),
    );
  }
}

