import 'dart:ui';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:fix_it/widgets/util.dart';
import 'package:flutter/material.dart';
import '../applocale.dart';
import '../database.dart';
import 'animation.dart';


class LogIn extends StatefulWidget {

  final PageController  pageController ;

  const LogIn({@required this.pageController});

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  String  _cCode ,_phone ;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size ;

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          top: size.height*.24,
          child: FadeX(
            delay: 0.0,
            child: BlurContainer(size: size),
          ),
        ),
        Positioned(
          top: size.height*.4,
          left: size.width*.1,
          child: FadeX(
            delay: 0.2,
            child: Container(
              height: 45,
              width: 50,
              decoration: containerBorders(),
              child: CountryCodePicker(
                onChanged: (code){
                  _cCode = code.dialCode ;
                  print(_cCode);
                },
                showFlag: false,
                hideSearch: true,
                textStyle: TextStyle(color: Colors.green,fontSize: 12),
                initialSelection: 'EG',
                favorite: ['SA','EG','AE','SY','OM','MC','KW','JO','IR','IQ','PS','QA','BH','YE','TN','DZ','LB','LY'],
                showFlagDialog: true,
                comparator: (a, b) => b.name.compareTo(a.name),
                onInit: (code) {
                  _cCode = code.dialCode ;
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: size.height*.4,
          right: size.width*.1,
          child: Container(
            width: size.width*.8-55,
            child: FadeX(
              delay: 0.0,
              child: MyTextField(
                size: size,
                label: lang(context, 'phone'),
                textInputType: TextInputType.emailAddress,
                onChanged: (phone){
                  _phone = phone ;
                },
              ),
            ),
          ),
        ),
        Positioned(
          top: size.height*.5,
          child: FadeX(
            delay: 0.3,
            child: Button(
              title: lang(context, 'login'),
              hasBorders: true ,
              onPressed: (){
                DatabaseService().signUpInWithPhone(context: context ,phone: _phone ,cCode: _cCode, signInOrUp: SignInUp.LogIn) ;
              },
            ),
          ),
        ),
        Positioned(
          top: size.height*.6,
          child: FadeX(
            delay: 0.5,
            child: Button(
              title: lang(context, 'newAcc'),
              hasBorders: false ,
              onPressed: (){
                widget.pageController.animateToPage(1, duration: Duration(milliseconds: 250 ), curve: Curves.ease) ;
              },
            ),
          ),
        ),
      ],
    );
  }
}
