import 'package:dartz/dartz.dart';
import 'package:flutter_checkout/core/utils/failure.dart';

import '../models/payment_intent_input_model.dart';

abstract class CheackoutRepo {
  Future<Either<Failure, void>> makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel});
}
