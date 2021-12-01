// ignore_for_file: file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors
import 'package:easy_bus/utils.dart';
import 'package:flutter/material.dart';

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
      width: 250,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              colorBtn,
              colorBtn1,
            ]),
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            spreadRadius: 0.3,
            color: colorBtn,
          ),
        ],
      ),
      child: TextButton(
        onPressed: widget.onPressed,
        child: Text(
          widget.title,
          style: const TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
    );
  }
}
