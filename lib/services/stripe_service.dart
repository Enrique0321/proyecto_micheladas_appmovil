import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  static String get apiBase {
    if (kIsWeb) {
      return 'http://localhost:3000';
    }
    return 'http://10.0.2.2:3000';
  }

  static Future<bool> makePayment(BuildContext context, String amount, String currency) async {
    try {
      // 1. Create Payment Intent
      final paymentIntentData = await createPaymentIntent(amount, currency);
      if (paymentIntentData == null) return false;

      if (kIsWeb) {
        return await _webPayment(context, paymentIntentData['clientSecret']);
      }

      // 2. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentData['clientSecret'],
          merchantDisplayName: 'Micheladas App',
          style: ThemeMode.dark,
        ),
      );

      // 3. Display Payment Sheet
      return await displayPaymentSheet(context);
    } catch (e) {
      print('Error in makePayment: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    }
  }

  static Future<bool> _webPayment(BuildContext context, String clientSecret) async {
    bool success = false;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pago con Tarjeta'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CardField(
                enablePostalCode: true,
                style: TextStyle(fontSize: 18, color: Colors.black),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Datos de la tarjeta',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await Stripe.instance.confirmPayment(
                      paymentIntentClientSecret: clientSecret,
                      data: const PaymentMethodParams.card(
                        paymentMethodData: PaymentMethodData(),
                      ),
                    );
                    success = true;
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Pago exitoso!')),
                    );
                  } catch (e) {
                    print('Web Payment Error: $e');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                },
                child: const Text('Pagar'),
              ),
            ],
          ),
        ),
      ),
    );
    return success;
  }

  static Future<Map<String, dynamic>?> createPaymentIntent(String amount, String currency) async {
    try {
      final url = Uri.parse('$apiBase/create-payment-intent');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'amount': calculateAmount(amount),
          'currency': currency,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Failed to create payment intent: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error creating payment intent: $e');
      return null;
    }
  }

  static Future<bool> displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pago exitoso!')),
      );
      return true;
    } on StripeException catch (e) {
      print('Stripe Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pago cancelado')),
      );
      return false;
    } catch (e) {
      print('Error displaying payment sheet: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al procesar el pago')),
      );
      return false;
    }
  }

  static String calculateAmount(String amount) {
    final a = (double.parse(amount) * 100).toInt();
    return a.toString();
  }
}
