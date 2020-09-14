import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fix_it/screens/home.dart';
import 'package:fix_it/screens/landing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'applocale.dart';
import 'database.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: DatabaseService().userState,
      child: MaterialApp(
        title: 'Harvest',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'TajawalRegular',
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        supportedLocales: [Locale('ar' , ''), Locale('en' , ''),],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          AppLocale.delegate
        ],
        localeResolutionCallback: (currentLocale , supportedLocales){
          if(currentLocale != null ){
            for(Locale locale in supportedLocales ){
              if(locale.languageCode == currentLocale.languageCode)
                return currentLocale ;
            }
          }
          if(supportedLocales.contains(currentLocale )){
            return currentLocale ;
          }
          else return  supportedLocales.first;
        },
        home: Wrapper(),
      ),
    );
  }
}


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final userState =  Provider.of<User>(context) ;

    if(userState == null ) return Landing();
    if(userState != null ) return Home() ;
    return Container();
  }
}