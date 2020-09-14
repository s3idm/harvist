import 'dart:ui';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:fix_it/widgets/util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../applocale.dart';
import '../database.dart';
import 'animation.dart';



enum AccType {
  client,
  delivery,
  farmer,
}

class SignUp extends StatefulWidget {

  final PageController  pageController ;

  const SignUp({@required this.pageController});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _name , _phone ,_cCode , _accountTypeSelected ;
  AccType _accType ;

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
            reversed: true,
            child: BlurContainer(size: size),
          ),
        ),
        Positioned(
          top: size.height*.3,
          child: FadeX(
            delay: 0.0,
            reversed: true,
            child: MyTextField(
              size: size,
              label: lang(context, 'name'),
              textInputType: TextInputType.name,
              onChanged: (nameVal){
                _name = nameVal ;
              },
            ),
          ),
        ),
        Positioned(
          top: size.height*.4,
          left: size.width*.1,
          child: FadeX(
            delay: 0.5,
            reversed: true,
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
          child: FadeX(
            delay: 0.3,
            reversed: true,
            child: Container(
              width: size.width*.8-55,
              child: MyTextField(
                size: size,
                label: lang(context, 'phone'),
                textInputType: TextInputType.phone,
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
            delay: 0.5,
            reversed: true,
            child: Container(
              height: 45,
              width: size.width*.8,
              decoration: containerBorders(),
              child: Center(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    items: <String>[lang(context, 'client'), lang(context, 'delivery'), lang(context, 'farmer'),].map((String accountType) {
                      return DropdownMenuItem<String>(
                        value: accountType,
                        child: Center(child: Text(accountType, style: TextStyle(color: Colors.green[800], fontWeight: FontWeight.bold),),),
                      );
                    }).toList(),
                    onChanged: (String accountType) {
                      setState(() {
                        _accountTypeSelected = accountType;
                        if      (_accountTypeSelected == lang(context, 'client' ))
                          _accType = AccType.client;
                        else if (_accountTypeSelected == lang(context,'delivery'))
                          _accType = AccType.delivery;
                        else if (_accountTypeSelected == lang(context, 'farmer' ))
                          _accType = AccType.farmer;
                      });
                    },
                    icon: Padding( padding: EdgeInsets.only(right: 8),child: Icon(Icons.arrow_drop_down, color: Colors.greenAccent,),),
                    hint: Center(child: _accountTypeSelected == null
                      ?Text(lang(context, 'accType'),style: TextStyle(color: Colors.greenAccent),textAlign: TextAlign.right,)
                      :Text('$_accountTypeSelected',style: TextStyle(color: Colors.green),textAlign: TextAlign.right,)),
                    isExpanded: true,
                    autofocus: false,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: size.height*.6,
          child: FadeX(
            delay: 0.7,
            reversed: true,
            child: Button(
              title: lang(context, 'signup'),
              hasBorders: true ,
              onPressed: (){
                DatabaseService().signUpInWithPhone(context: context ,phone: _phone ,accType: _accType,cCode: _cCode,name: _name, signInOrUp: SignInUp.SignUp) ;
              },
            ),
          ),
        ),
        Positioned(
          top: size.height*.7,
          child: FadeX(
            delay: 0.8,
            reversed: true,
            child: Button(
              title: lang(context, 'currentAcc'),
              hasBorders: false ,
              onPressed: (){
                if(widget.pageController.page == 1)
                  widget.pageController.animateToPage(0, duration: Duration(milliseconds: 300), curve: Curves.decelerate);
              },
            ),
          ),
        ),
      ],
    );
  }
}

