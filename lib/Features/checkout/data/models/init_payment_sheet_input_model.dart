class InitPaymentSheetInputModel {
  final String clientSecret;
  final String ephemeralKey;
  final String customerId;

  InitPaymentSheetInputModel(
      {required this.clientSecret,
      required this.ephemeralKey,
      required this.customerId});
}
