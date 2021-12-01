

import 'package:firebase_database/firebase_database.dart';

class UserDetails{
  String fullName;
  String email;
  String phone;
  String id;

  UserDetails({
    this.email,
    this.fullName,
    this.phone,
    this.id,
  });

  UserDetails.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    fullName = snapshot.value['fullname'];
  }

}