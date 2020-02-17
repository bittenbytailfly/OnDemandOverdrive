import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ondemand_overdrive/services/NavigationService.dart';

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  bool _initialized = false;

  factory FirebaseMessagingService() {
    return _instance;
  }

  FirebaseMessagingService._internal();

  void initialize() {
    if (this._initialized) {
      return;
    }

    FirebaseMessaging()
      ..configure(onResume: (Map<String, dynamic> msg) async {
        switch (msg['data']['click_intent']) {
          case "SHOW_NEW_RELEASE":
            NavigationService().navigateToSubscriberListings();
            break;
          default:
            break;
        }
      });
    this._initialized = true;
  }
}
