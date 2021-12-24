// ignore_for_file: file_names, prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:easy_bus/helpers/helpermethods.dart';
import 'package:easy_bus/widgets/ProgressDialog.dart';

class StartPage extends StatefulWidget {
  static const String id = 'startPage';

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  
  @override
  void initState() {
    super.initState();
    setState(() {
      HelperMethods.getCurrentUserInfo(context);      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ProgressDialog(
          status: 'Loading',
        ),
      ),
    );
  }
}
