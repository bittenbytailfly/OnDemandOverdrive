import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/providers/AccountProvider.dart';
import 'package:ondemand_overdrive/providers/ListingsProvider.dart';
import 'package:ondemand_overdrive/screens/ListingsScreen.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:ondemand_overdrive/screens/SubscriberListingsScreen.dart';
import 'package:ondemand_overdrive/services/NavigationService.dart';
import 'package:provider/provider.dart';



void _handleNotificationClick(Map<String, dynamic> msg) async {
  //(App in background)
  // From Notification bar when user click notification we get this event.
  // on this event navigate to a particular page.
  switch (msg['data']['click_intent']) {
    case "SHOW_NEW_RELEASE":
      debugPrint("navigating from provider");
      
      break;
    default:
      break;
  }
}

class MessagingSingleton {
  static final MessagingSingleton _singleton = MessagingSingleton._internal();

  factory MessagingSingleton() {
    return _singleton;
  }

  MessagingSingleton._internal() {
    FirebaseMessaging()
      ..configure(
        onMessage: (Map<String, dynamic> message) async {
          print('on message $message');
        },
        onResume: (Map<String, dynamic> message) async {
          print('Resuming!');
          NavigationService().navigateTo('subscriberListings');
        },
        onLaunch: (Map<String, dynamic> message) async {
          print('on launch $message');
        },
      );
  }
}

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  Admob.initialize('ca-app-pub-1438831506348729~8718003556');
  runApp(OnDemandOverdrive());
  MessagingSingleton();
}

class OnDemandOverdrive extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AccountProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ListingsProvider(),
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
        navigatorKey: NavigationService().navigatorKey,
        onGenerateRoute: (routeSettings) {
          switch (routeSettings.name) {
            case 'subscriberListings':
              return MaterialPageRoute(builder: (context) => SubscriberListingsScreen());
            default:
              return MaterialPageRoute(builder: (context) => ListingsScreen());
          }
        },
      ),
    );
  }
}