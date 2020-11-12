import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:smart_stadium/pages/user_auth/login.dart';

class SplashPage extends StatefulWidget {

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin{

  Animation animation;
  AnimationController controller;


  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/stadium_icon.png', width: 150, height: 150,),
                ],)
          ),
        )
    );
  }


  bool _initialized = false;
  bool _error = false;

  void initializeFlutterFire() async {
    try{
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch(e){
      setState(() {
        _error = true;
      });
    }
  }


  @override
  void initState() {
    initializeFlutterFire();
    super.initState();

    // Initialize animation
    controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();

    countDown();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void countDown() {
    var _duration = new Duration(milliseconds: 2000);
    new Future.delayed(_duration, pushLoginPage);
  }

  void pushLoginPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return Scaffold(
        body: LogInPage(),
      );
    }));
  }

}
