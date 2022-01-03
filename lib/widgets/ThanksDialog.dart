// ignore_for_file: file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors, sized_box_for_whitespace

import 'package:easy_bus/brand_colors.dart';
import 'package:easy_bus/widgets/BrandDivier.dart';
import 'package:easy_bus/widgets/BusButton.dart';
import 'package:flutter/material.dart';

class CollectPayment extends StatelessWidget {
  final String paymentMethod;
  final int fares;

  CollectPayment({this.paymentMethod, this.fares});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.all(4.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(4)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            
            SizedBox(
              height: 20,
            ),
            BrandDivider(),
            SizedBox(
              height: 16.0,
            ),
            Text(
              'Thanks',
              style: TextStyle(fontFamily: 'Brand-Bold', fontSize: 50),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'Thanks to take our journy',
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: 230,
              child: BusButton(
                title: (paymentMethod == 'cash') ? 'CONFIRM' : 'CONFIRM',
                color: BrandColors.colorGreen,
                onPressed: () {
                  Navigator.pop(context, 'close');
                },
              ),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
    );
  }
}
