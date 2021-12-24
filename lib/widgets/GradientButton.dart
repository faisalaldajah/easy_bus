// ignore_for_file: file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import '../brand_colors.dart';

class GradientButton extends StatefulWidget {
  final String title;
  final Function onPressed;

  GradientButton({this.title, this.onPressed});

  @override
  _GradientButtonState createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // ignore: prefer_const_literals_to_create_immutables
            colors: [
              BrandColors.colorAccent,
              BrandColors.colorAccent1,
              BrandColors.colorAccent,
            ]),
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: 0.3,
            color: BrandColors.colorTextLight,
          ),
        ],
      ),
      child: TextButton(
        onPressed: widget.onPressed,
        child: Text(
          widget.title,
          style: TextStyle(fontSize: 25,color: Colors.white),
        ),
      ),
    );
  }
}
