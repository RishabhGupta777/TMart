import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetProvider extends ChangeNotifier {
  bool? isOnline;

  Future<void> checkConnection() async {
    bool connected = await InternetConnection().hasInternetAccess;
    isOnline = connected;
    notifyListeners(); // tell UI to rebuild
  }
}

