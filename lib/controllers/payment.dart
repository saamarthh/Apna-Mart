import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

Map<String, dynamic>? paymentIntent;

Future<void> makePayment(BuildContext context, double amount) async {
  try {
    paymentIntent = await createPaymentIntent('$amount', 'INR');
    await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntent!['client_secret'],
            applePay: const PaymentSheetApplePay(
              merchantCountryCode: '+91',
            ),
            googlePay: const PaymentSheetGooglePay(currencyCode:"+91",
                merchantCountryCode: "US", testEnv: true)));

    displayPaymentSheet(context);
  } catch (e, s) {
    print('exception:$e$s');
  }
}

displayPaymentSheet(BuildContext context) async {
  try {
    await Stripe.instance.presentPaymentSheet().then((value) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.green),
                        Text('Payment Succesfull'),
                      ],
                    )
                  ],
                ),
              ));

      paymentIntent = null;
    }).onError((error, stackTrace) {
      print('Error is:--->$error $stackTrace');
    });
  } on StripeException catch (e) {
    print("Error is:---> $e");
    showDialog(
        context: context,
        builder: (_) => const AlertDialog(
              content: Text('Cancelled'),
            ));
  } catch (e) {
    print('$e');
  }
}

createPaymentIntent(String amount, String currency) async {
  try {
    Map<String, dynamic> body = {
      'amount': calculateAmount(amount),
      'currency': currency,
      'payment_method_types[]': 'card'
    };

    var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        body: body,
        headers: {
          'Authorization':
              'Bearer sk_test_51MtV1fSDRmD8t0PZ5vr3eWIUKqQGfreNZcedXgTk6K3hQhsfsE5guPuNmHo6HMWKOnjcQ25EruJ7yq3FKJsjuDKW00m1SK2t16',
          'Content-Type': 'application/x-www-form-urlencoded'
        });
    return jsonDecode(response.body);
  } catch (error) {
    print('err charging user: ${error.toString()}');
  }
}

calculateAmount(String amount) {
  final calculatedAmount = (int.parse(amount)) * 100;
  return calculatedAmount.toString();
}
