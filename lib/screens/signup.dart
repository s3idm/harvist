import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:harvest/util/util.dart';
import 'package:harvest/util/applocale.dart';
import 'package:harvest/util/database.dart';
import 'package:harvest/screens/animation.dart';
import 'dart:ui';




class SignUp extends StatefulWidget {

  final PageController  pageController ;

  SignUp({@required this.pageController});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _name , _phone ,_cCode , _accountTypeSelected , errorMSG ;
  AccType _accType ;


  Future signUpWithPhone({String name ,phone,accType,cCode }) async {
    loading = false ;
    String _token ,errorMsg ;
    FirebaseAuth auth = FirebaseAuth.instance ;
    auth.verifyPhoneNumber(
      phoneNumber: '$cCode$phone',
      timeout: Duration(seconds: 120),
      verificationCompleted: (AuthCredential credential) async {
        var result = await auth.signInWithCredential(credential);
        if (result.user != null){
          DatabaseService().createNewClient(phone: phone,name: name,accType: accType,cCode: cCode,uid: result.user.uid);
          Navigator.pop(context);
        }
      },
      verificationFailed:(FirebaseAuthException authException){
        print(authException.code);
        setState(() {
          if(authException.code == 'invalid-phone-number' )
          errorMSG = lang(context, 'phoneNotCorrect');
          else {
            errorMSG = lang(context, 'checkConnection');
          }
        });
      },
      codeSent: (String verificationCode ,[int forceResendToken] ){
        showModal(
          context: context ,
          builder: (context){
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.green[100],
              title: Center(child: Text(lang(context, 'validation'),style: TextStyle(color: Colors.green),)),
              content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState){
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      MyTextField(
                        size: Size(300,40),
                        onChanged: (val){_token = val ;},
                        textInputType: TextInputType.number,
                        label: lang(context, 'validationKey'),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(errorMsg ?? '',style: TextStyle(color: Colors.red,fontSize: 14),),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Button(
                            hasBorders: true,
                            title: lang(context, 'cancel'),
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),
                          Button(
                            hasBorders: true,
                            title: lang(context, 'checkKey'),
                            onPressed: () async {
                              setState(()  {
                                loading = true;
                              });
                              try{
                                AuthCredential credential =  PhoneAuthProvider.credential(verificationId: verificationCode , smsCode: _token);
                                var result = await auth.signInWithCredential(credential);
                                if (result.user != null){
                                  await DatabaseService().createNewClient(phone: phone,name: name,accType: accType,cCode: cCode,uid: result.user.uid);
                                  DatabaseService().addPhone(phone: phone,cCode: cCode);
                                  Navigator.pop(context);
                                }
                              }
                              catch (ex){
                                print(ex);
                                setState((){
                                  errorMsg = lang(context, 'ensureKey');
                                  loading =false;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                      loading == true ?
                      CircularProgressIndicator():
                      SizedBox(),
                    ],
                  );
                },
              ),
            );
          },
        );
      } ,
      codeAutoRetrievalTimeout: (codeRetrieval){
        print(codeRetrieval);
      },
    );
  }

  void formValidation () async {
    final alreadyRegistered = await  DatabaseService().alreadyRegistered(phone:_phone);

    if(_name == null || _phone == null || _accType == null ){
      setState(() {
        errorMSG = lang(context, 'formErrors') ;
      });
    }else if(alreadyRegistered == true ) {
     setState(() {
       errorMSG = lang(context, 'isRegistered');
     });
    }
    else{
      setState(() {
        errorMSG = '';
      });
      signUpWithPhone(phone: _phone ,accType: _accType,cCode: _cCode,name: _name,) ;
    }
  }


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
          top: size.height*.25,
          child: Text(errorMSG ?? '',style: TextStyle(fontSize: 15,color: Colors.greenAccent),textAlign: TextAlign.center,
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
            child: MyCountryCode(
              onChanged: (code){
                _cCode = code.dialCode ;
              },
              onInit: (code) {
                _cCode = code.dialCode ;
              },
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
                formValidation();
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

