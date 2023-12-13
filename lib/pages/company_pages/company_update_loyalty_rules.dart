import 'package:coffee/utils/database_operations/loyalty/toggle_loyalty_status.dart';
import 'package:coffee/utils/database_operations/loyalty/update_loyalty_rules.dart';
import 'package:coffee/utils/notifiers/loyalty_program_notifier.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class UpdateLoyalty extends StatefulWidget {
  const UpdateLoyalty({super.key, required this.email});

  @override
  State<UpdateLoyalty> createState() => _UpdateLoyaltyState();
  final String email;
}

int goal = 0;
int selection1 = 0;
int selection2 = 0;
int selection3 = 0;
int selection4 = 0;
bool isLoading = false;
int statusValue = 0;

class _UpdateLoyaltyState extends State<UpdateLoyalty> {
  @override
  void initState() {
    var rulesNotifier = context.read<LoyaltyNotifier>();
    statusValue = rulesNotifier.rules
        .where((r) => r.storeEmail == widget.email)
        .first
        .isPointsEnabled;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Rules'),
        centerTitle: true,
      ),
      body: update(context),
    );
  }

  Padding update(BuildContext context) {
    var rulesNotifier = context.read<LoyaltyNotifier>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Loyalty Program Status',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Switch(
                inactiveTrackColor: const Color.fromARGB(255, 238, 53, 53),
                inactiveThumbColor: Colors.white,
                activeColor: const Color.fromARGB(255, 13, 104, 16),
                value: statusValue == 1 ? true : false,
                onChanged: (value) {
                  if (value) {
                    statusValue = 1;
                    ToggleLoyaltyStatus().toggleLoyaltyStatus(
                        context, widget.email, statusValue);
                    rulesNotifier.getRules();
                    setState(() {});
                  } else {
                    statusValue = 0;
                    ToggleLoyaltyStatus().toggleLoyaltyStatus(
                        context, widget.email, statusValue);
                    rulesNotifier.getRules();
                    setState(() {});
                  }
                },
              )
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
                    // ignore: unused_local_variable
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
                      (isCompleted, response) = await UpdateLoyaltyRules()
                          .updateRules(context, statusValue, widget.email, goal,
                              selection1, selection2, selection3, selection4);
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
                      child: Text(
                        'Save',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ))
            ],
          )
        ],
      ),
    );
  }
}
