import 'package:coffee/utils/database_operations/loyalty/update_user_loyalty_points.dart';
import 'package:coffee/utils/database_operations/user/get_user.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:coffee/utils/notifiers/loyalty_user.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';

class TransferPoints extends StatefulWidget {
  const TransferPoints({super.key, required this.email});

  @override
  State<TransferPoints> createState() => _TransferPointsState();
  final String email;
}

String name = "";
int selection = 0;
bool getName = false;

class _TransferPointsState extends State<TransferPoints> {
  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transfer Points'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            userDetails(context),
            const SizedBox(
              height: 50,
            ),
            inputTransferAmount(),
            const Spacer(),
            transferButton(context)
          ],
        ),
      ),
    );
  }

  Row transferButton(BuildContext context) {
    var pointNotifier = context.read<LoyaltyUserNotifier>();
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
                onPressed: () async {
                  final String storeEmail = await getUserData(0);
                  final userPoint = pointNotifier.userPoints
                          .where((p) =>
                              p.userEmail == widget.email &&
                              p.storeEmail == storeEmail)
                          .first
                          .totalPoint +
                      selection;
                  if (mounted) {
                    bool isCompleted = false;
                    String response = "";
                    (isCompleted, response) = await UpdateUserPoint()
                        .updateUserPoint(
                            context,
                            widget.email,
                            userPoint,
                            pointNotifier.userPoints
                                .where((p) =>
                                    p.userEmail == widget.email &&
                                    p.storeEmail == storeEmail)
                                .first
                                .totalGained);
                    if (isCompleted && mounted) {
                      Dialogs.showTransectionCompleted(
                          context, response, storeEmail);
                    }
                  }
                },
                child: const Text('Complete Transfer')),
          ),
        ),
      ],
    );
  }

  Container inputTransferAmount() {
    return Container(
        decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                  blurRadius: 3,
                  color: Color.fromARGB(108, 0, 0, 0),
                  blurStyle: BlurStyle.outer,
                  spreadRadius: 0,
                  offset: Offset(1, 2))
            ],
            color: const Color.fromARGB(255, 249, 241, 246),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Amount of points to be transferred",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    NumberPicker(
                      axis: Axis.horizontal,
                      itemHeight: 50,
                      itemWidth: 50,
                      minValue: 0,
                      maxValue: 15,
                      value: selection,
                      onChanged: (value) => setState(() => selection = value),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black26),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }

  Container userDetails(BuildContext context) {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
                blurRadius: 3,
                color: Color.fromARGB(108, 0, 0, 0),
                blurStyle: BlurStyle.outer,
                spreadRadius: 0,
                offset: Offset(1, 2))
          ],
          color: const Color.fromARGB(255, 249, 241, 246),
          borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.email,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(
            height: 15,
          ),
          getName
              ? Text(
                  name,
                  style: const TextStyle(fontSize: 18),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )
        ],
      ),
    );
  }

  Future<void> getUserName() async {
    name = await getUser(widget.email);
    getName = true;
    setState(() {});
  }
}
