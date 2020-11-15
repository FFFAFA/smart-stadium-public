import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_stadium/pages/orderCart.dart';
import 'package:smart_stadium/pages/reserve.dart';
import 'package:smart_stadium/pages/user_auth/login.dart';
import 'package:smart_stadium/pages/verify_ticket.dart';
import 'package:smart_stadium/pages/widgets/warning_dialog.dart';
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

  @override
  Widget build(BuildContext context) {

    FirebaseFirestore fireStore = FirebaseFirestore.instance;
    CollectionReference users = fireStore.collection('User');
    CollectionReference reservations = fireStore.collection('Reservation');

    // if(_error){
    //   return FirebaseError();
    // }

    if (!_initialized){
       return LinearProgressIndicator();
    }

    return Scaffold(
      body: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).backgroundColor,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 40, left: 10, right: 10, bottom: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        // Logo
                        Image.asset(
                          'assets/images/stadium_icon.png',
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                        Row(
                          children: [
                            CurrentUser(),
                            RaisedButton(
                              onPressed: _signOut,
                              child: Text(
                                'Sign out',
                                style: TextStyle(fontSize: 12, color: Theme.of(context).primaryColor),
                                ),
                              shape: StadiumBorder(),
                              color: Colors.black12,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  CardList('Recent Events', 'Events'),

                  CardList('Special Offers', 'SpecialOffers'),

                  // Bottom button row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      // Make reservation button
                      RoundButton(Icons.calendar_today, _pushReserve),
                      // Verify ticket button
                      RoundButton(Icons.verified, _pushVerifyTicket),
                      // Navigation button
                      RoundButton(Icons.location_on, _pushNavigation),
                      // Order button
                      RoundButton(Icons.add_shopping_cart, _pushOrder),
                    ],
                  ),
                ],
              ),
            )
      )
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Toast.show('Signed out', context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LogInPage()));
  }

  void _pushVerifyTicket() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new VerifyTicketPage();
    }));
  }

  void _pushReserve() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new ReservePage();
    }));
  }
  
  void _pushNavigation() {
    String userRole;
    FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser.uid).get()
    .then((snapshot) {
      userRole = snapshot.data()['role'];
      if (userRole=='audience' || userRole=='renter') {
        // Push navigation page
      } else {
        DialogProvider().noPermissionDialog(context);
      }
    });
  }

//new added: to OrderPage
  void _pushOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderPage()),
    );
  }
//-----------------------

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

class CurrentUser extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('User').doc(FirebaseAuth.instance.currentUser.uid).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError){
          return LinearProgressIndicator();
        }

        if(!snapshot.hasData) {
          return LinearProgressIndicator();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            snapshot.data.data()['username'],
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 15,
            ),
          ),
        );
      },
    );
  }
}

class CardList extends StatelessWidget {
  final String listTitle;
  final String collectionName;

  CardList(this.listTitle, this.collectionName);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // title
          Padding(
            padding: EdgeInsets.all(5),
            child: Text(this.listTitle, style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),),
          ),
          // list
          StreamBuilder(
              stream: FirebaseFirestore.instance.collection(this.collectionName).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot){
                if (snapshot.hasError){
                  return LinearProgressIndicator();
                }

                if(!snapshot.hasData) {
                  return LinearProgressIndicator();
                }
                return Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: snapshot.data.docs.map((document){
                      return Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: EventCard(
                          title: document.data()['title'],
                          imageURL: document.data()['imageURL'],
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatefulWidget{
  final String title;
  final String imageURL;
  EventCard({Key key, this.title, this.imageURL}):super(key: key);
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
            width: 160,
            height: 200,
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius:  BorderRadius.circular(15.0),
              ),
              elevation: 20,
              color: Theme.of(context).backgroundColor,
              shadowColor: Colors.black,
              child:
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      image: DecorationImage(
                        image: NetworkImage(widget.imageURL),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient: LinearGradient(
                          begin: FractionalOffset.topCenter,
                          end: FractionalOffset.bottomCenter,
                          colors: [ Colors.black.withOpacity(0.0), Colors.black.withOpacity(0.8)],
                          stops: [0.0, 1.0]
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.bottomRight,
                    child: Padding(padding: EdgeInsets.all(5),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        )
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
