import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_checkout/Features/checkout/data/models/amount_model/amount_model.dart';
import 'package:flutter_checkout/Features/checkout/data/models/item_list_model/item.dart';
import 'package:flutter_checkout/Features/checkout/data/models/item_list_model/item_list_model.dart';
import 'package:flutter_checkout/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:flutter_checkout/core/utils/api_keys.dart';
import 'package:flutter_checkout/core/widgets/custom_button.dart';
import 'package:flutter_paypal_payment/flutter_paypal_payment.dart';
import '../../../data/models/amount_model/details.dart';
import '../../maneger/cubit/payment_cubit.dart';
import '../thank_you_view.dart';

class CustomBottonBlocConsumer extends StatelessWidget {
  const CustomBottonBlocConsumer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentCubit, PaymentState>(
      listener: (context, state) {
        if (state is PaymentSuccess) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const ThankYouView()));
        }
        if (state is PaymentFailure) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(state.errorMessage),
          ));
        }
      },
      builder: (context, state) {
        return CustomButton(
            onTap: () {
              // PaymentIntentInputModel paymentIntentInputModel =
              //     PaymentIntentInputModel(
              //         amount: 100,
              //         currency: 'USD',
              //         customerId: 'cus_R3rq0IKYpfNRBL');
              // BlocProvider.of<PaymentCubit>(context).makePayment(
              //     paymentIntentInputModel: paymentIntentInputModel);
              var transactionsData = getTransactionData();
              excutePaypalPayment(context, transactionsData);
            },
            isLoading: state is PaymentLoading ? true : false,
            text: 'Continue');
      },
    );
  }

  void excutePaypalPayment(BuildContext context,
      ({AmountModel amount, ItemListModel itemList}) transactionsData) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalCheckoutView(
          sandboxMode: true,
          clientId: ApiKeys.paypalClientID,
          secretKey: ApiKeys.paypalSecret,
          transactions: [
            {
              "amount": transactionsData.amount.toJson(),
              "description": "The payment transaction description.",
              "item_list": transactionsData.itemList.toJson(),
            }
          ],
          note: "Contact us for any questions on your order.",
          onSuccess: (Map params) async {
            log("onSuccess: $params");
            Navigator.pop(context);
          },
          onError: (error) {
            log("onError: $error");
            Navigator.pop(context);
          },
          onCancel: () {
            print('cancelled:');
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  ({AmountModel amount, ItemListModel itemList}) getTransactionData() {
    AmountModel amountModel = AmountModel(
        total: '100',
        currency: 'USD',
        details: Details(subtotal: '100', shipping: '0', shippingDiscount: 0));

    List<OrderItemModel> orderItems = [
      OrderItemModel(
        currency: 'USD',
        name: 'Apple',
        quantity: 4,
        price: '10',
      ),
      OrderItemModel(
        currency: 'USD',
        name: 'Mac',
        quantity: 5,
        price: '12',
      ),
    ];
    var itemList = ItemListModel(orders: orderItems);

    return (amount: amountModel, itemList: itemList);
  }
}
