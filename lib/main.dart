// ignore_for_file: use_key_in_widget_constructors

import 'package:easy_bus/dataprovider/appdata.dart';
import 'package:easy_bus/globalvariable.dart';
import 'package:easy_bus/screens/PhoneLogin/screens/loginpage.dart';
import 'package:easy_bus/screens/StartPage.dart';
import 'package:easy_bus/screens/loginpage.dart';
import 'package:easy_bus/screens/mainpage.dart';
import 'package:easy_bus/screens/registrationpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // ignore: await_only_futures
  currentFirebaseUser = await FirebaseAuth.instance.currentUser;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Brand-Regular',
          primarySwatch: Colors.blue,
        ),
        initialRoute:
            (currentFirebaseUser == null) ? LoginPage.id : StartPage.id,
        routes: {
          RegistrationPage.id: (context) => RegistrationPage(),
          LoginScreens.id: (context) => LoginScreens(),
          MainPage.id: (context) => MainPage(),
          StartPage.id: (context) => StartPage(),
          LoginPage.id:(context)=>LoginPage(),
        },
      ),
    );
  }
}
