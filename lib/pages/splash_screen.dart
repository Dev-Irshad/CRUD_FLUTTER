import 'dart:async';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

import '../global.dart';
import '../main.dart';



class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {

// Here you can write your code

      Navigator.push(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: AuthenticationWrapper(),
        ),
      );

    });
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: baseColor,
      body: Center(child:
      Container(
        height: 50,
        child: LoadingIndicator(indicatorType: Indicator.lineScale, color: Colors.white,

        ),
      )

      ),
    ),
    );
  }
}
