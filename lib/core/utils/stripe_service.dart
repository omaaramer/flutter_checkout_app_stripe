import 'package:dio/dio.dart';
import 'package:flutter_checkout/Features/checkout/data/models/ephemoral_key_model/ephemoral_key_model.dart';
import 'package:flutter_checkout/Features/checkout/data/models/init_payment_sheet_input_model.dart';
import 'package:flutter_checkout/Features/checkout/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:flutter_checkout/core/utils/api_keys.dart';
import 'package:flutter_checkout/core/utils/api_service.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

import '../../Features/checkout/data/models/payment_intent_input_model.dart';

class StripeService {
  ApiService apiService = ApiService();
  Future<PaymentIntentModel> createPaymentIntent(
      PaymentIntentInputModel paymentIntentInputModel) async {
    var response = await apiService.post(
      contentType: Headers.formUrlEncodedContentType,
      url: 'https://api.stripe.com/v1/payment_intents',
      body: paymentIntentInputModel.toJson(),
      token: ApiKeys.secretKey,
    );

    return PaymentIntentModel.fromJson(response.data);
  }

  Future initPaymentSheet(
      {required InitPaymentSheetInputModel initPaymentSheetInputModel}) async {
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: initPaymentSheetInputModel.clientSecret,
      merchantDisplayName: 'Omar Amer',
      customerEphemeralKeySecret: initPaymentSheetInputModel.ephemeralKey,
      customerId: initPaymentSheetInputModel.customerId,
    ));
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    var paymentIntentModel = await createPaymentIntent(paymentIntentInputModel);
    var ephemoralKeyModel = await createEphemeralKey(
        customerId: paymentIntentInputModel.customerId);

    var initPaymentSheetInputModel = InitPaymentSheetInputModel(
      customerId: paymentIntentInputModel.customerId,
      clientSecret: paymentIntentModel.clientSecret!,
      ephemeralKey: ephemoralKeyModel.secret!,
    );
    await initPaymentSheet(
        initPaymentSheetInputModel: initPaymentSheetInputModel);
    await displayPaymentSheet();
  }

  Future<EphemoralKeyModel> createEphemeralKey(
      {required String customerId}) async {
    var response = await apiService.post(
      contentType: Headers.formUrlEncodedContentType,
      url: 'https://api.stripe.com/v1/ephemeral_keys',
      body: {
        'customer': customerId,
      },
      // token: ApiKeys.secretKey,
      headers: {
        'Stripe-Version': '2024-06-20',
        'Authorization': 'Bearer ${ApiKeys.secretKey}',
      },
    );

    return EphemoralKeyModel.fromJson(response.data);
  }
}
