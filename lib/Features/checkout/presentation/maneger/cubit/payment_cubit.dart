import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_checkout/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:flutter_checkout/Features/checkout/data/repos/cheackout_repo.dart';
part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this.cheackoutRepo) : super(PaymentInitial());
  CheackoutRepo cheackoutRepo;
  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    emit(PaymentLoading());

    var data = await cheackoutRepo.makePayment(
        paymentIntentInputModel: paymentIntentInputModel);

    data.fold(
      (e) => emit(PaymentFailure(errorMessage: e.toString())),
      (r) => emit(PaymentSuccess()),
    );
  }

  @override
  void onChange(Change<PaymentState> change) {
    super.onChange(change);
    log(change.toString());
  }
}
