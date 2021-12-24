import 'package:firebase_database/firebase_database.dart';

class UserData{
  String fullName;
  String email;
  String phone;
  String id;

  UserData({
    this.email,
    this.fullName,
    this.phone,
    this.id,
  });

  UserData.fromSnapshot(DataSnapshot snapshot){
    id = snapshot.key;
    phone = snapshot.value['phone'];
    email = snapshot.value['email'];
    fullName = snapshot.value['fullname'];
  }

}