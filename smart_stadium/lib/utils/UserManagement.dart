import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class UserManagement {
  
  void createUserDocument(String uid, String username, [String staffID]) {
    FirebaseFirestore.instance.collection('User').doc(uid).set({
      'profile-photo-url': '',
      'username': username,
      'role': staffID==null ? 'normal' : 'staff'
    }).then((value) => print('User Document Created'))
        .catchError((error){print('Set Failed');});
  }

  String getUserRole() {
    return '';
  }

  void setUserRole(String role){

  }


  
}