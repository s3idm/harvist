import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fix_it/applocale.dart';
import 'package:fix_it/widgets/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

bool loading = false ;

enum SignInUp{
  LogIn,
  SignUp,
}

class DatabaseService {

  FirebaseAuth auth = FirebaseAuth.instance ;
  CollectionReference clients = FirebaseFirestore.instance.collection('clients');

  Future createNewClient({String name ,phone,accType,cCode,uid})async{
    return await clients.doc(uid).set({
      'Name'    :name,
      'Phone'   : phone ,
      'CCode'   : cCode,
      'AccType' : accType.toString(),
      'UID'     : uid,
    });
  }

//sign out ***************************************************
  signOut()async{
    await auth.signOut();
  }

//User State *************************************************
  Stream<User> get userState {
    return auth.authStateChanges() ;
  }

//Phone verification *******************************************
  Future signUpInWithPhone({String name ,phone,accType,cCode ,SignInUp signInOrUp , BuildContext context}) async {
    loading = false ;
    String _token  , errorMsg;
    auth.verifyPhoneNumber(
      phoneNumber: '$cCode$phone',
      timeout: Duration(seconds: 120),
      verificationCompleted: (AuthCredential credential) async {

        if(signInOrUp == SignInUp.LogIn ){
          var result = await auth.signInWithCredential(credential) ;
          if (result.user != null){
            Navigator.pop(context);
          }
        }
        else if(signInOrUp == SignInUp.SignUp){
          var result = await auth.signInWithCredential(credential);
          if (result.user != null){
            createNewClient(phone: phone,name: name,accType: accType,cCode: cCode,uid: result.user.uid);
            Navigator.pop(context);
          }
        }
      },
      verificationFailed:(FirebaseAuthException authException){
        errorMsg = authException.message ;
        print(authException.message) ;
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
                                if(signInOrUp == SignInUp.LogIn){
                                  AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationCode , smsCode: _token);
                                  var result = await auth.signInWithCredential(credential);
                                  if (result.user != null){
                                    Navigator.pop(context);
                                  }
                                }
                                else if(signInOrUp == SignInUp.SignUp){
                                  AuthCredential credential =  PhoneAuthProvider.credential(verificationId: verificationCode , smsCode: _token);
                                  var result = await auth.signInWithCredential(credential);
                                  if (result.user != null){
                                    createNewClient(phone: phone,name: name,accType: accType,cCode: cCode,uid: result.user.uid);
                                    Navigator.pop(context);
                                  }
                                }
                              }
                              catch (ex){
                                print(ex);
                                setState((){
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
    return errorMsg ;
  }

}