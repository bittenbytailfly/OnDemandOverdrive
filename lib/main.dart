import 'package:flutter/material.dart';
import 'package:ondemand_overdrive/providers/AccountProvider.dart';
import 'package:ondemand_overdrive/providers/ListingsProvider.dart';
import 'package:ondemand_overdrive/screens/ListingDetailScreen.dart';
import 'package:ondemand_overdrive/screens/ListingsScreen.dart';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:ondemand_overdrive/screens/NewSubscriptionScreen.dart';
import 'package:ondemand_overdrive/screens/SubscriberListingsScreen.dart';
import 'package:ondemand_overdrive/screens/SubscriptionsScreen.dart';
import 'package:ondemand_overdrive/services/FIrebaseMessagingService.dart';
import 'package:ondemand_overdrive/services/NavigationService.dart';
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
        home: Builder(
          builder: (context) {
            FirebaseMessagingService().initialize();
            return ListingsScreen(title: 'On Demand Overdrive');
          }
        ),
        navigatorKey: NavigationService().navigatorKey,
        initialRoute: '/',
        onGenerateRoute: (routeSettings) {
          final Map arguments = routeSettings.arguments as Map;
          switch (routeSettings.name) {
            case NavigationService.SUBSCRIBER_LISTINGS:
              return MaterialPageRoute(builder: (context) => SubscriberListingsScreen());
            case NavigationService.SUBSCRIPTIONS:
              return MaterialPageRoute(builder: (context) => SubscriptionsScreen());
            case NavigationService.NEW_SUBSCRIPTION_SCREEN:
              return MaterialPageRoute(builder: (context) => NewSubscriptionScreen());
            case NavigationService.LISTING_DETAIL:
              return MaterialPageRoute(builder: (context) => ListingDetailScreen(id: arguments['id']));
            default:
              return MaterialPageRoute(builder: (context) => ListingsScreen());
          }
        },
      ),
    );
  }
}