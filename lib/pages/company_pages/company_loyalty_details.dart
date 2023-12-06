import 'package:flutter/material.dart';

class CompanyLoyaltyDetails extends StatelessWidget {
  final String name;
  const CompanyLoyaltyDetails({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BUCHAFE Loyalty Program'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Loyalty Program Agreement',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Dear $name,\n\n'
                'We are thrilled to introduce the BUCHAFE Loyalty Program, a token of appreciation for your ongoing support and loyalty to our craft coffee experience. This program is designed to reward you with points for each completed order, whether you choose the convenience of our mobile app or visit our cozy physical store.\n\n'
                '**How It Works:**\n\n'
                '1. **Order Placement through Mobile App:**\n'
                '   - When you place an order through the BUCHAFE mobile app, you will automatically accrue points once our store confirms that your order has been picked up.\n\n'
                '2. **In-Store Order Placement:**\n'
                '   - If you prefer the charm of ordering directly from our physical store, inform our friendly cashier that you are a BUCHAFE Loyalty Program member. Your points will be swiftly added to your account upon order confirmation.\n\n'
                '3. **QR Code Redemption:**\n'
                '   - For added convenience, utilize the QR code feature in our mobile app. Simply navigate to the Loyalty Program section, generate your unique QR code, and present it to the cashier during your purchase. The cashier will scan the QR code, and voila – your points will be credited to your account.\n\n'
                '**Terms and Conditions:**\n\n'
                '1. Points earned through the BUCHAFE Loyalty Program are non-transferable and hold no cash value.\n'
                '2. Points can only be redeemed for eligible products or discounts, as specified in the Loyalty Program guidelines.\n'
                '3. BUCHAFE reserves the right to modify or terminate the Loyalty Program at any time, with or without notice.\n'
                '4. Abuse or fraudulent activity related to the Loyalty Program may result in the termination of a customer\'s participation.\n\n'
                'By participating in our Loyalty Program, you agree to adhere to the terms and conditions outlined above.\n\n'
                'Thank you for being a cherished part of the BUCHAFE family. We value your loyalty and eagerly anticipate the opportunity to continue serving you with the finest craft coffee experiences.\n\n'
                'BUCHAFE',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
