import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/screens/listingsScreen.dart';

void main() => runApp(OnDemandOverdrive());

class OnDemandOverdrive extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'On Demand Overdrive',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.teal,
        brightness: Brightness.light
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.teal,
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(color: Colors.teal),
      ),
      home: ListingsScreen(title: 'On Demand Overdrive'),
    );
  }
}