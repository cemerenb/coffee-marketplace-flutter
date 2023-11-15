import 'package:flutter/material.dart';

import '../../main.dart';
import '../../utils/classes/menu_class.dart';
import '../../utils/classes/stores.dart';

// ignore: must_be_immutable
class StoresListView extends StatefulWidget {
  const StoresListView({
    super.key,
    required this.stores,
  });

  final List<Store> stores;

  @override
  State<StoresListView> createState() => _StoresListViewState();
}

List<Menu> menu = [];

class _StoresListViewState extends State<StoresListView> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: ListView.builder(
          itemCount: stores.length,
          itemBuilder: (context, index) {
            if (stores[index].storeLogoLink.isNotEmpty) {
              count++;
              return Card(
                child: ListTile(
                  onTap: () {},
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
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Padding bottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 88, 88, 88).withOpacity(0.2),
            borderRadius: BorderRadius.circular(20)),
        height: 60,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      setState(() {});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.home,
                            size: 30, color: Colors.brown.shade600),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.brown.shade600),
                        )
                      ],
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shadowColor: Colors.transparent),
                    onPressed: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.coffee, size: 25, color: Colors.black),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent),
                        )
                      ],
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shadowColor: Colors.transparent),
                    onPressed: () {},
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.settings,
                            size: 25, color: Colors.black),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent),
                        )
                      ],
                    )),
              ]),
        ),
      ),
    );
  }
}
