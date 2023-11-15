import 'package:coffee/pages/company_pages/widgets/product_details.dart';
import 'package:coffee/pages/customer_pages/customer_list_stores.dart';
import 'package:coffee/utils/database_operations/get_menu_user.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class StoreDetails extends StatefulWidget {
  const StoreDetails({super.key, required this.index});

  @override
  State<StoreDetails> createState() => _StoreDetailsState();
  final int index;
}

bool isFound = false;
int category = 1;
int currentIndex = 2;
bool visibility1 = true;
bool visibility2 = false;
bool visibility3 = false;
bool visibility4 = false;
int count = 0;

class _StoreDetailsState extends State<StoreDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          children: [
            Container(
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10)),
                height: 200,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Center(
                            child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.4),
                                    border: Border.all(width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                height: 80,
                                width: 80,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.network(
                                    stores[widget.index].storeLogoLink,
                                    fit: BoxFit.contain,
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width - 200,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    stores[widget.index].storeName,
                                    style: const TextStyle(fontSize: 16),
                                    overflow: TextOverflow.clip,
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  const Row(
                                    children: [
                                      Text("-"),
                                      Icon(
                                        Icons.star,
                                        color:
                                            Color.fromARGB(255, 216, 196, 19),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width - 100,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.shopping_bag,
                            size: 18,
                          ),
                          Text(
                            'Take-away',
                            style: TextStyle(fontSize: 14),
                          )
                        ],
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width - 100,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.4),
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Working hours',
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                    fontSize: 10),
                              ),
                              Text(
                                  '${stores[widget.index].openingTime.replaceAll(" ", "")} - ${stores[widget.index].closingTime.replaceAll(" ", "")}'),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0, top: 20),
              child: Row(
                children: [
                  categoryItem(1),
                  categoryItem(2),
                  categoryItem(3),
                  categoryItem(4),
                  const Spacer(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: menu.length,
                itemBuilder: (context, index) {
                  if (menu[index].storeEmail ==
                          stores[widget.index].storeEmail &&
                      menu[index].menuItemCategory == category) {
                    count++;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 5.0),
                      child: Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                    index: index,
                                    menus: menu,
                                  ),
                                ));
                          },
                          leading: SizedBox(
                            height: 80,
                            width: 80,
                            child: FadeInImage(
                              placeholder: const AssetImage(
                                  'assets/img/placeholder_image.png'),
                              image:
                                  NetworkImage(menu[index].menuItemImageLink),
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                          title: Text(menu[index].menuItemName),
                          subtitle: Text(
                            menu[index].menuItemDescription,
                            style: const TextStyle(fontSize: 10),
                          ),
                          trailing: Text(
                            "${menu[index].menuItemPrice} ₺",
                            style: const TextStyle(fontSize: 25),
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding categoryItem(int selectedCategory) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: () {
          category = selectedCategory;
          setVisibility(selectedCategory);
          fetchMenuUserData();
          setState(() {});
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: category == selectedCategory
                ? Colors.brown.shade600
                : Colors.grey.withOpacity(0.5),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getCategoryIcon(selectedCategory),
                Visibility(
                  visible: getCategoryVisibility(selectedCategory),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(getCategoryName(selectedCategory)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getCategoryIcon(int selectedCategory) {
    switch (selectedCategory) {
      case 1:
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset("assets/img/coffee.png"),
        );
      case 2:
        return Image.asset("assets/img/cold-coffee.png");
      case 3:
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: Image.asset("assets/img/cake.png"),
        );
      case 4:
        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Image.asset("assets/img/sandwich.png"),
        );
      default:
        return Image.asset("assets/img/coffee.png");
    }
  }

  String getCategoryName(int selectedCategory) {
    switch (selectedCategory) {
      case 1:
        return "Hot Drinks";
      case 2:
        return "Cold Drinks";
      case 3:
        return "Desserts";
      case 4:
        return "Snacks";
      default:
        return "";
    }
  }

  bool getCategoryVisibility(int selectedCategory) {
    switch (selectedCategory) {
      case 1:
        return visibility1;
      case 2:
        return visibility2;
      case 3:
        return visibility3;
      case 4:
        return visibility4;
      default:
        return false;
    }
  }

  void setVisibility(int selected) {
    visibility1 = selected == 1;
    visibility2 = selected == 2;
    visibility3 = selected == 3;
    visibility4 = selected == 4;
  }
}
