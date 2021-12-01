// ignore_for_file: use_key_in_widget_constructors
import 'package:easy_bus/Widget/GradientButton.dart';
import 'package:easy_bus/Widget/ProgressDialog.dart';
import 'package:easy_bus/screen/mainPage.dart';
import 'package:easy_bus/utils.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';

class RegistrationPage extends StatefulWidget {
  static const String id = 'register';

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  void showSnackBar(String title) {
    final snackbar = SnackBar(
      content: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 15),
      ),
    );
    // ignore: deprecated_member_use
    scaffoldKey.currentState.showSnackBar(snackbar);
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var fullNameController = TextEditingController();

  var phoneController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  void registerUser() async {
    //show please wait dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) => ProgressDialog(
        status: 'Registering you...',
      ),
    );
    final User user = (await _auth
            .createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
            .catchError(
      (ex) {
        //check error and display message
        Navigator.pop(context);
        PlatformException thisEx = ex;
        showSnackBar(thisEx.message);
      },
    ))
        .user;

    Navigator.pop(context);
    // check if user registration is successful
    if (user != null) {
      DatabaseReference newUserRef =
          FirebaseDatabase.instance.reference().child('users/${user.uid}');
      
      //Prepare data to be saved on users table
      Map userMap = {
        'fullname': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
      };
      newUserRef.set(userMap);
      userLoggedin = true;

      //Take the user to the mainPage
      Navigator.pushNamedAndRemoveUntil(context, MainPage.id, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/logo.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Create new account',
                  style: TextStyle(fontFamily: 'bolt', fontSize: 25),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: <Widget>[
                      // Fullname
                      TextField(
                        controller: fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                            labelText: 'Full name',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // Email Address
                      TextField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // Phone
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                            labelText: 'Phone',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      // Password
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              fontSize: 14.0,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 10.0)),
                        style: const TextStyle(fontSize: 14),
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      GradientButton(
                        title: 'Register',
                        onPressed: () async {
                          //check network availability
                          var connectivityResult =
                              await Connectivity().checkConnectivity();
                          if (connectivityResult != ConnectivityResult.mobile &&
                              connectivityResult != ConnectivityResult.wifi) {
                            showSnackBar('No internet connectivity');
                            return;
                          }

                          if (fullNameController.text.length < 3) {
                            showSnackBar('Please provide a valid fullname');
                            return;
                          }

                          if (phoneController.text.length < 10) {
                            showSnackBar('Please provide a valid phone number');
                            return;
                          }

                          if (!emailController.text.contains('@')) {
                            showSnackBar(
                                'Please provide a valid email address');
                            return;
                          }

                          if (passwordController.text.length < 8) {
                            showSnackBar(
                                'password must be at least 8 characters');
                            return;
                          }
                          setState(() {
                            registerUser();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, LoginPage.id, (route) => false);
                    },
                    child: const Text('Already have a DRIVER account? Log in',
                        style: TextStyle(color: Colors.black))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
