import 'package:flutter/material.dart';
import '../../controller/internet_provider.dart';

Center NoInternetBox(InternetProvider provider) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.wifi_off, size: 60, color: Colors.red),
        const SizedBox(height: 8),
        const Text("You are not connected to the internet"),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: provider.checkConnection,
          child: const Text("Retry"),
        ),
      ],
    ),
  );
}
