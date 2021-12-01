// ignore_for_file: file_names, use_key_in_widget_constructors, prefer_const_constructors
import 'package:easy_bus/screen/mapPage.dart';
import 'package:easy_bus/utils.dart';
import 'package:flutter/material.dart';

class TripPage extends StatefulWidget {
  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'القادم',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        backgroundColor: backGroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: backGroundColor,
      body: SingleChildScrollView(
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            SizedBox(height: 20),
            ListTile(
              leading: Text('1'),
              subtitle: Text('جامعة الزيتونة'),
              title: Text('رغدان'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(),
                  ),
                );
              },
              trailing: Icon(Icons.bus_alert),
            ),
            ListTile(
              leading: Text('2'),
              subtitle: Text('جامعة الزيتونة'),
              title: Text('ماركا'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(),
                  ),
                );
              },
              trailing: Icon(Icons.bus_alert),
            ),
            ListTile(
              leading: Text('3'),
              subtitle: Text('جامعة الزيتونة'),
              title: Text('الهاشمي'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MapPage(),
                  ),
                );
              },
              trailing: Icon(Icons.bus_alert),
            ),
          ],
        ),
      ),
    );
  }
}
