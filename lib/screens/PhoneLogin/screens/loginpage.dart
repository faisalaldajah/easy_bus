// ignore_for_file: constant_identifier_names, use_key_in_widget_constructors, prefer_final_fields, prefer_const_literals_to_create_immutables

import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:easy_bus/screens/StartPage.dart';
import 'package:easy_bus/widgets/GradientButton.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreens extends StatefulWidget {
  static const String id = 'logins';
  @override
  _LoginScreensState createState() => _LoginScreensState();
}

class _LoginScreensState extends State<LoginScreens> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();
  CountryCode countryCode;
  FirebaseAuth _auth = FirebaseAuth.instance;
  var fullNameController = TextEditingController();
  String verificationId;

  bool showLoading = false;
  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      setState(() {
        showLoading = false;
      });
      if (authCredential?.user != null) {
        DatabaseReference newUserRef = FirebaseDatabase.instance.reference();
        Map userMap = {
          'fullname': fullNameController.text,
          'phone': '$countryCode${checkNumber(phoneController.text)}',
        };
        newUserRef.child('users/${authCredential.user.uid}').set(userMap);
        Navigator.pushNamedAndRemoveUntil(
            context, StartPage.id, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });
      showSnackBar(e.message);
    }
  }

  getMobileFormWidget(context) {
    return Scaffold(
      key: scaffoldKey,
      body: Column(
        children: [
          const Image(
            alignment: Alignment.center,
            height: 250.0,
            width: 250.0,
            image: AssetImage('images/logo.png'),
          ),
          TextFormField(
            keyboardType: TextInputType.name,
            decoration: const InputDecoration(hintText: 'الاسم الكامل'),
            controller: fullNameController,
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              CountryCodePicker(
                initialSelection: 'JO',
                showCountryOnly: false,
                showOnlyCountryWhenClosed: false,
                favorite: ['+962', 'JO'],
                showFlagMain: true,
                onChanged: (value) {
                  countryCode = value;
                },
                onInit: (value) {
                  countryCode = value;
                },
              ),
              Flexible(
                child: TextField(
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                  decoration: const InputDecoration(
                    hintText: "Phone Number",
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          GradientButton(
            onPressed: () async {
              setState(() {
                showLoading = true;
              });

              await _auth.verifyPhoneNumber(
                phoneNumber: '$countryCode${checkNumber(phoneController.text)}',
                verificationCompleted: (phoneAuthCredential) async {
                  setState(() {
                    showLoading = false;
                  });
                },
                verificationFailed: (verificationFailed) async {
                  setState(() {
                    showLoading = false;
                  });
                  showSnackBar(verificationFailed.message);
                },
                codeSent: (verificationId, resendingToken) async {
                  setState(() {
                    showLoading = false;
                    currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                    this.verificationId = verificationId;
                  });
                },
                codeAutoRetrievalTimeout: (verificationId) async {},
              );
            },
            title: "SEND",
          ),
          const Spacer(),
        ],
      ),
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        const Image(
          alignment: Alignment.center,
          height: 280.0,
          width: 280.0,
          image: AssetImage('images/logo.png'),
        ),
        TextField(
          controller: otpController,
          decoration: const InputDecoration(
            hintText: "Enter OTP",
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        GradientButton(
          onPressed: () async {
            PhoneAuthCredential phoneAuthCredential =
                PhoneAuthProvider.credential(
                    verificationId: verificationId,
                    smsCode: otpController.text);

            signInWithPhoneAuthCredential(phoneAuthCredential);
          },
          title: "VERIFY",
        ),
        const Spacer(),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          child: showLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? getMobileFormWidget(context)
                  : getOtpFormWidget(context),
          padding: const EdgeInsets.all(16),
        ));
  }

  // ignore: missing_return
  String checkNumber(String phone) {
    if (phone.startsWith('0')) {
      showSnackBar('احذف الصفر في بداية الرقم');
    } else if (phone.length > 9) {
      showSnackBar('يجب ان يحتوي رقم الهاتف على 9 ارقام');
    } else if (!phone.contains('79') &&
        !phone.contains('78') &&
        !phone.contains('77')) {
      showSnackBar('يجب ان يحتوي رقم الهاتف رمز مزود الخدمة');
    } else {
      return phone;
    }
  }

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
}
