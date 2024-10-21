import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_checkout/core/utils/api_keys.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import 'Features/checkout/presentation/views/my_cart_view.dart';

void main() {
  Stripe.publishableKey = ApiKeys.publishableKey;

  runApp(
    // DevicePreview(
    // enabled: true,
    // builder: (context) =>
    const CheckoutApp(),
  );
}

class CheckoutApp extends StatelessWidget {
  const CheckoutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // locale: DevicePreview.locale(context),
      // builder: DevicePreview.appBuilder,
      debugShowCheckedModeBanner: false,
      home: const MyCartView(),
    );
  }
}
