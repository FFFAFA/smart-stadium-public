import 'package:flutter/material.dart';
import 'package:smart_stadium/pages/verify_ticket.dart';

import '../reserve.dart';

class DialogProvider{

  Future<void> noPermissionDialog(context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(

            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              height: 180,
              width: 400,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
                    child: Text('You need to VERIFY a ticket or make a RESERVATION to use this service',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 15,
                      ),),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        BackButton(),
                        VerifyNowButton(),
                        ReserveNowButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

}

class VerifyNowButton extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: StadiumBorder(),
      fillColor: Theme.of(context).primaryColor,
      child: Text(
        'Verify Now',
        style: TextStyle(
            color: Colors.black87,
            fontSize: 12
        ),
      ),
      onPressed: () { Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder:(context) {
            return VerifyTicketPage();
          }));},
    );
  }
}

class ReserveNowButton extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: StadiumBorder(),
      fillColor: Theme.of(context).primaryColor,
      child: Text(
        'Reserve Now',
        style: TextStyle(
            color: Colors.black87,
            fontSize: 12
        ),
      ),
      onPressed: () { Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder:(context) {
            return ReservePage();
          }));},
    );
  }
}

class BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      shape: StadiumBorder(),
      fillColor: Theme.of(context).hintColor,
      child: Text(
        'Back',
        style: TextStyle(
          color: Colors.black87,
          fontSize: 12,
        ),
      ),
      onPressed: () { Navigator.of(context).pop();},
    );
  }
}