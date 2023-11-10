import 'package:coffee/pages/customer_pages/customer_main_page.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class StoresListView extends StatelessWidget {
  StoresListView({
    super.key,
    required this.stores,
  });

  final List<Store> stores;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: stores.length,
      itemBuilder: (context, index) {
        if (stores[index].storeLogoLink.isNotEmpty) {
          count++;
          return Card(
            child: ListTile(
              leading: Image.network(stores[index].storeLogoLink),
              title: Text(stores[index].storeName),
              subtitle: Text(
                  'Open: ${stores[index].openingTime} - Close: ${stores[index].closingTime}'),
            ),
          );
        } else if (count == 0) {
          count++;
          return const Center(
            child: Text("There is not any stores"),
          );
        }
        return null;
      },
    );
  }
}
