// store_info_page.dart

import 'package:flutter/material.dart';
import '../../utils/classes/stores.dart';

class StoreInfoPage extends StatefulWidget {
  final List<Store> store;
  final String email;

  const StoreInfoPage({Key? key, required this.store, required this.email})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _StoreInfoPageState createState() => _StoreInfoPageState();
}

class _StoreInfoPageState extends State<StoreInfoPage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${widget.store[0].storeName}'),
          Text('Tax ID: ${widget.store[0].storeTaxId}'),
          Text('Opening Time: ${widget.store[0].openingTime}'),
          Text('Closing Time: ${widget.store[0].closingTime}'),
          // Add more widgets for other properties as needed
        ],
      ),
    );
  }
}
