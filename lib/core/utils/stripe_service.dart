import 'package:flutter_checkout/Features/checkout/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:flutter_checkout/core/utils/api_keys.dart';
import 'package:flutter_checkout/core/utils/api_service.dart';

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
}
