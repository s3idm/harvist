import 'package:flutter/material.dart';
import 'animation.dart';
import 'dart:ui';
import 'login.dart';
import 'signup.dart';



class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> with SingleTickerProviderStateMixin{

  PageController pageController =  PageController() ;
  List logoList = ['H','A','R','V','E','S','T'];
  TabController tabController ;


  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size ;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/back1.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              top: 50,
              child: Container(
                width: size.width,
                height: size.height*.2,
                child: Center(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: logoList.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context , index){
                      return FadeY(
                        delay: index.toDouble()/2,
                        child: Text(logoList[index],
                          style: TextStyle(color: Colors.green.withOpacity(1),fontSize: 70,fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            PageView(
              controller: pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                LogIn(pageController: pageController),
                SignUp(pageController: pageController),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



