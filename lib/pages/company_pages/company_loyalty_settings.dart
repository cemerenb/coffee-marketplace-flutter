import 'dart:developer';

import 'package:coffee/main.dart';
import 'package:coffee/pages/company_pages/company_loyalty_details.dart';
import 'package:coffee/pages/company_pages/company_update_loyalty_rules.dart';
import 'package:coffee/utils/database_operations/loyalty/save_loyalty_rules.dart';
import 'package:coffee/utils/notifiers/loyalty_user.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:coffee/utils/notifiers/loyalty_program_notifier.dart';
import 'package:coffee/utils/notifiers/store_notifier.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompanyLoyaltySettings extends StatefulWidget {
  const CompanyLoyaltySettings({super.key, required this.email});

  @override
  State<CompanyLoyaltySettings> createState() => _CompanyLoyaltySettingsState();
  final String email;
}

class _CompanyLoyaltySettingsState extends State<CompanyLoyaltySettings> {
  @override
  void initState() {
    getTotals();
    var rulesNotifier = context.read<LoyaltyNotifier>();
    rulesNotifier.getRules();
    super.initState();
  }

  int goal = 0;
  int selection1 = 0;
  int selection2 = 0;
  int selection3 = 0;
  int selection4 = 0;
  int totalGaineds = 0;
  int totalPoints = 0;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Loyalty Settings"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () async {
                String storeName = "";
                if (mounted) {
                  var storeNotifier = context.read<StoreNotifier>();
                  storeName = storeNotifier.stores
                      .where((s) => s.storeEmail == widget.email)
                      .first
                      .storeName;
                }

                if (mounted) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CompanyLoyaltyDetails(name: storeName),
                      ));
                }
              },
              icon: const Icon(Icons.info_outline))
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : settingsArea(),
    );
  }

  Widget settingsArea() {
    var rulesNotifier = context.watch<LoyaltyNotifier>();
    return rulesNotifier.rules
                .where((r) => r.storeEmail == widget.email)
                .toList()
                .length ==
            1
        ? Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          totalPoints.toString(),
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Image.asset(
                          'assets/img/point.png',
                          scale: 1.8,
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          totalGaineds.toString(),
                          style: const TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        Image.asset(
                          'assets/img/cup.png',
                          scale: 1.8,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Goal",
                              style: TextStyle(fontSize: 20),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(width: 1)),
                              child: Center(
                                child: Text(
                                  "${rulesNotifier.rules.where((r) => r.storeEmail == widget.email).first.pointsToGain}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Points for hot drinks",
                              style: TextStyle(fontSize: 20),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(width: 1)),
                              child: Center(
                                child: Text(
                                  "${rulesNotifier.rules.where((r) => r.storeEmail == widget.email).first.category1Gain}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Points for cold drinks",
                              style: TextStyle(fontSize: 20),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(width: 1)),
                              child: Center(
                                child: Text(
                                  "${rulesNotifier.rules.where((r) => r.storeEmail == widget.email).first.category2Gain}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Points for desserts",
                              style: TextStyle(fontSize: 20),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(width: 1)),
                              child: Center(
                                child: Text(
                                  "${rulesNotifier.rules.where((r) => r.storeEmail == widget.email).first.category3Gain}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Points for snacks",
                              style: TextStyle(fontSize: 20),
                            ),
                            Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(width: 1)),
                              child: Center(
                                child: Text(
                                  "${rulesNotifier.rules.where((r) => r.storeEmail == widget.email).first.category4Gain}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                width: 150,
                child: ElevatedButton(
                  onPressed: () async {
                    rulesNotifier.getRules();
                    if (mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UpdateLoyalty(email: email),
                          ));
                    }
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Edit',
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.edit,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          )
        : inactive(rulesNotifier);
  }

  Padding inactive(LoyaltyNotifier rulesNotifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              const Text(
                'You have not yet joined the loyalty program. Before joining, you can read the information below.',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              RichText(
                text: TextSpan(
                  text: 'Read the details here.',
                  style: const TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      String storeName = "";
                      if (mounted) {
                        var storeNotifier = context.read<StoreNotifier>();
                        storeName = storeNotifier.stores
                            .where((s) => s.storeEmail == widget.email)
                            .first
                            .storeName;
                      }

                      if (mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CompanyLoyaltyDetails(name: storeName),
                            ));
                      }
                    },
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Goal',
                      style: TextStyle(fontSize: 20),
                    ),
                    Center(
                      child: NumberPicker(
                        axis: Axis.horizontal,
                        itemHeight: 50,
                        itemWidth: 50,
                        minValue: 0,
                        maxValue: 20,
                        value: goal,
                        onChanged: (value) => setState(() => goal = value),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black26),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Points for hot drinks',
                      style: TextStyle(fontSize: 20),
                    ),
                    Center(
                      child: NumberPicker(
                        axis: Axis.horizontal,
                        itemHeight: 50,
                        itemWidth: 50,
                        minValue: 0,
                        maxValue: 15,
                        value: selection1,
                        onChanged: (value) =>
                            setState(() => selection1 = value),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black26),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Points for cold drinks',
                      style: TextStyle(fontSize: 20),
                    ),
                    Center(
                      child: NumberPicker(
                        axis: Axis.horizontal,
                        itemHeight: 50,
                        itemWidth: 50,
                        minValue: 0,
                        maxValue: 15,
                        value: selection2,
                        onChanged: (value) =>
                            setState(() => selection2 = value),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black26),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Points for desserts',
                      style: TextStyle(fontSize: 20),
                    ),
                    Center(
                      child: NumberPicker(
                        axis: Axis.horizontal,
                        itemHeight: 50,
                        itemWidth: 50,
                        minValue: 0,
                        maxValue: 15,
                        value: selection3,
                        onChanged: (value) =>
                            setState(() => selection3 = value),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black26),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Points for snacks',
                      style: TextStyle(fontSize: 20),
                    ),
                    Center(
                      child: NumberPicker(
                        axis: Axis.horizontal,
                        itemHeight: 50,
                        itemWidth: 50,
                        minValue: 0,
                        maxValue: 15,
                        value: selection4,
                        onChanged: (value) =>
                            setState(() => selection4 = value),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: Colors.black26),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    bool isCompleted = false;
                    String response = "";
                    if (goal == 0 ||
                        selection1 == 0 ||
                        selection2 == 0 ||
                        selection3 == 0 ||
                        selection4 == 0) {
                      Dialogs.showErrorDialog(context,
                          'One ore more selection is 0. Please select all.');
                    } else {
                      isLoading = true;
                      setState(() {});
                      (isCompleted, response) = await SetLoyaltyRules()
                          .setRules(context, 0, widget.email, goal, selection1,
                              selection2, selection3, selection4);
                      if (isCompleted) {
                        await rulesNotifier.getRules();
                        isLoading = false;
                        setState(() {});
                      }
                    }
                  },
                  child: const SizedBox(
                    height: 50,
                    width: 100,
                    child: Center(
                      child: Text('Save'),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }

  void getTotals() async {
    int tempGained = 0;
    int tempPoint = 0;
    var pointNotifier = context.read<LoyaltyUserNotifier>();
    await pointNotifier.getPoints();
    if (pointNotifier.userPoints
        .where((p) => p.storeEmail == widget.email)
        .isNotEmpty) {
      for (var i = 0;
          i <
              pointNotifier.userPoints
                  .where((p) => p.storeEmail == widget.email)
                  .toList()
                  .length;
          i++) {
        tempGained += pointNotifier.userPoints
            .where((p) => p.storeEmail == widget.email)
            .toList()[i]
            .totalGained;
        tempPoint += pointNotifier.userPoints
            .where((p) => p.storeEmail == widget.email)
            .toList()[i]
            .totalPoint;
      }
    } else {
      tempGained = 0;
      tempPoint = 0;
    }
    totalGaineds = tempGained;
    totalPoints = tempPoint;
    setState(() {});
  }
}
