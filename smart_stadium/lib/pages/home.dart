import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_stadium/pages/user_auth/login.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class HomePage extends StatefulWidget {

  HomePage({Key key}):super(key: key);

  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Toast.show('Signed out', context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInPage()));
  }

  @override
  Widget build(BuildContext context) {

    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    CollectionReference users = fireStore.collection('User');
    CollectionReference reservations = fireStore.collection('Reservation');

    // if(_error){
    //   return FirebaseError();
    // }

    // if (!_initialized){
    //   return Loading();
    // }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child:
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  // Logo and sign out button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 15, bottom: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              // Logo
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  // Logo
                                  Image.asset(
                                    'assets/images/stadium_icon.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.contain,
                                  ),
                                  FlatButton(
                                      onPressed: _signOut,
                                      child: Text(
                                        'Sign out',
                                        style: TextStyle(color: Theme.of(context).primaryColor),
                                      )
                                  )
                                ],
                              ),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Cloud Firestore test
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Collection \'Reservation\':', style: TextStyle(color: Theme.of(context).primaryColor),),
                      FutureBuilder<QuerySnapshot>(
                        future: reservations.get(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return LinearProgressIndicator();
                          return Row(
                            children: [
                              Text('Document ID: ', style: TextStyle(color: Theme.of(context).primaryColor),),
                              Text(snapshot.data.docs[0].id, style: TextStyle(color: Theme.of(context).primaryColor),),
                            ],
                          );
                        },
                      ),
                    ],
                  ),

                  // Current User
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current User:', style: TextStyle(color: Theme.of(context).primaryColor),),
                      Text('uid: ${FirebaseAuth.instance.currentUser.uid}', style: TextStyle(color: Theme.of(context).primaryColor),),
                      Text('email: ${FirebaseAuth.instance.currentUser.email}', style: TextStyle(color: Theme.of(context).primaryColor),),
                    ],
                  ),

                  // Bottom button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // Call button
                      RoundButton(Icons.call, null),
                      // Video call button
                      RoundButton(Icons.video_call, null),
                      // Report button
                      RoundButton(Icons.equalizer, null),
                      // User button
                      RoundButton(Icons.person, null),
                    ],
                  ),
                ],
              ),
            )
      )
    );
  }
}


class RoundButton extends StatelessWidget {

  final IconData icon;
  final GestureTapCallback onPressed;

  RoundButton(this.icon, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      shape: CircleBorder(),
      color: Colors.grey[850],
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Icon(icon, color: Colors.amber[600], size: 25,),
      ),
    );
  }
}
