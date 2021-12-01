// ignore_for_file: file_names, use_key_in_widget_constructors
import 'package:easy_bus/Widget/GradientButton.dart';
import 'package:easy_bus/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ResetPassword extends StatelessWidget {
  static const String id = 'ResetPassword';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailTextEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Text(
                'we will send you a link... please click on that link to reset your password.',
                style: bodyText,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: emailTextEditingController,
                decoration: const InputDecoration(
                  labelText: 'email',
                  labelStyle: TextStyle(
                    fontSize: 14,
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            GradientButton(
              title: 'Send',
              onPressed: () {
                _auth.sendPasswordResetEmail(
                  email: emailTextEditingController.text,
                );
                emailTextEditingController.clear();
                FocusScope.of(context).requestFocus(FocusNode());
                displayToastMessage('check your email please', context);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
