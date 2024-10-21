import 'package:dartz/dartz.dart';
import 'package:flutter_checkout/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:flutter_checkout/Features/checkout/data/repos/cheackout_repo.dart';
import 'package:flutter_checkout/core/utils/api_service.dart';
import 'package:flutter_checkout/core/utils/failure.dart';
import 'package:flutter_checkout/core/utils/stripe_service.dart';

class CheackoutRepoImpl extends CheackoutRepo {
  final StripeService stripeService = StripeService();
  @override
  Future<Either<Failure, void>> makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    try {
      await stripeService.makePayment(
          paymentIntentInputModel: paymentIntentInputModel);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
