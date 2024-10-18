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
      url: 'https://api.stripe.com/v1/payment_intents',
      body: paymentIntentInputModel.toJson(),
      token: ApiKeys.secretKey,
    );

    return PaymentIntentModel.fromJson(response.data);
  }

  Future initPaymentSheet({required String paymentIntentClientSecret}) async {
    Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
      paymentIntentClientSecret: paymentIntentClientSecret,
      merchantDisplayName: 'Omar Amer',
    ));
  }

  Future displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } on Exception catch (e) {
      if (e is StripeException) {
        print('Error from Stripe: ${e.error.localizedMessage}');
      } else {
        print('$e');
      }
    } catch (e) {
      print('$e');
    }
  }

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    var paymentIntentModel = await createPaymentIntent(paymentIntentInputModel);

    await initPaymentSheet(
        paymentIntentClientSecret: paymentIntentModel.clientSecret!);
    await displayPaymentSheet();
  }
}
