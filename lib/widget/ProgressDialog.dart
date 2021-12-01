// ignore_for_file: file_names, prefer_const_constructors_in_immutables, use_key_in_widget_constructors
import 'package:easy_bus/utils.dart';
import 'package:flutter/material.dart';

class ProgressDialog extends StatelessWidget {
  final String status;
  ProgressDialog({this.status});
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      backgroundColor: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(16),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const SizedBox(width: 4),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(colorBtn),
              ),
              const SizedBox(width: 25),
              Text(status, style: const TextStyle(fontSize: 15))
            ],
          ),
        ),
      ),
    );
  }
}
