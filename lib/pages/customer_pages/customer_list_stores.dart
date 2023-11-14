import 'package:flutter/material.dart';

import '../../utils/classes/stores.dart';

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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: ListView.builder(
        itemCount: stores.length,
        itemBuilder: (context, index) {
          if (stores[index].storeLogoLink.isNotEmpty) {
            count++;
            return Card(
              child: ListTile(
                leading: Image.network(stores[index].storeLogoLink),
                title: Text(stores[index].storeName),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${stores[index].openingTime.replaceAll(" ", "")} - ${stores[index].closingTime.replaceAll(" ", "")}'),
                    const Row(
                      children: [
                        Text('-'),
                        Icon(
                          Icons.star,
                          color: Color.fromARGB(255, 216, 196, 19),
                          size: 20,
                        ),
                      ],
                    )
                  ],
                ),
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
      ),
    );
  }
}
