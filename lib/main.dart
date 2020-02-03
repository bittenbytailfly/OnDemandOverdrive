import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/models/FirebaseUserAuth.dart';
import 'package:ondemand_overdrive/screens/ListingsScreen.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:ondemand_overdrive/services/SubscriptionService.dart';
import 'package:provider/provider.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize('ca-app-pub-1438831506348729~8718003556');
  runApp(OnDemandOverdrive());
}

class OnDemandOverdrive extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FirebaseUserAuth(),
        ),

      ],
      child: MaterialApp(
        title: 'On-Demand Overdrive',
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
          brightness: Brightness.light,
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.teal,
              textTheme: ButtonTextTheme.primary
          ),
        ),
        darkTheme: ThemeData(
          primarySwatch: Colors.teal,
          brightness: Brightness.dark,
          appBarTheme: AppBarTheme(color: Colors.teal),
          buttonTheme: ButtonThemeData(
              buttonColor: Colors.teal,
              textTheme: ButtonTextTheme.primary
          ),
        ),
        home: ListingsScreen(title: 'On Demand Overdrive'),
      ),
    );
  }
}