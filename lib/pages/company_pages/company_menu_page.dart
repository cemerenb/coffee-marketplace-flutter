// Importing necessary packages and files
import 'package:coffee/pages/company_pages/company_orders_page.dart';
import 'package:coffee/pages/company_pages/company_settings.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';

import 'package:coffee/pages/company_pages/add_product.dart';
import 'package:coffee/pages/company_pages/widgets/product_details.dart';
import 'package:coffee/utils/classes/menu_class.dart';
import 'package:coffee/utils/notifiers/store_notifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/database_operations/store/get_menu.dart';

// Defining a StatefulWidget for displaying the list of menus
class MenusListView extends StatefulWidget {
  final String email;

  const MenusListView({Key? key, required this.email}) : super(key: key);

  @override
  State<MenusListView> createState() => _MenusListViewState();
}

// Initializing an empty list of Menu objects
List<Menu> menus = [];

// State class for the MenusListView
class _MenusListViewState extends State<MenusListView> {
  @override
  void initState() {
    super.initState();
    // Fetching menu data when the state is initialized
    fetchMenuData().then((success) async {});
    setState(() {});
  }

  // State variables
  bool isFound = false;
  int category = 1;
  int currentIndex = 2;
  bool visibility1 = true;
  bool visibility2 = false;
  bool visibility3 = false;
  bool visibility4 = false;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              // Displaying category items and add button
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Row(
                  children: [
                    categoryItem(1),
                    categoryItem(2),
                    categoryItem(3),
                    categoryItem(4),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddNewProduct(email: widget.email),
                            ));
                      },
                      icon: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
              // Displaying list of menu items based on selected category
              listMenuItems(context)
            ],
          ),
        ),
      ),
      // Adding bottom navigation bar
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  // Method to build the list of menu items
  Padding listMenuItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: menus.indexed.map((item) {
          var (index, menusItem) = item;
          // Displaying menu items only for the selected category and store
          if (menusItem.storeEmail == widget.email &&
              menusItem.menuItemCategory == category) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(
                            index: index,
                            menus: menus,
                          ),
                        ));
                  },
                  leading: SizedBox(
                    height: 80,
                    width: 80,
                    child: FadeInImage(
                      placeholder:
                          const AssetImage('assets/img/placeholder_image.png'),
                      image: NetworkImage(menusItem.menuItemImageLink),
                      fit: BoxFit.contain,
                    ),
                  ),
                  title: Text(menusItem.menuItemName),
                  subtitle: Text(
                    menusItem.menuItemDescription,
                    style: const TextStyle(fontSize: 10),
                  ),
                  trailing: Text(
                    "${menusItem.menuItemPrice} ₺",
                    style: const TextStyle(fontSize: 25),
                  ),
                ),
              ),
            );
          }
          return const SizedBox();
        }).toList(),
      ),
    );
  }

  // Method to build the bottom navigation bar
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
                // Button for navigating to orders
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrdersListView(
                              email: widget.email,
                            ),
                          ));
                      setState(() {});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(Icons.list, size: 25, color: Colors.black),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.transparent),
                        )
                      ],
                    )),
                // Button for refreshing
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
                        const Icon(Icons.coffee,
                            size: 30,
                            color: Color.fromARGB(255, 198, 169, 146)),
                        Container(
                          height: 4,
                          width: 30,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: const Color.fromARGB(255, 198, 169, 146)),
                        )
                      ],
                    )),
                // Button for navigating to store settings
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.2),
                        shadowColor: Colors.transparent),
                    onPressed: () async {
                      var storeNotifier = context.read<StoreNotifier>();
                      await storeNotifier.fetchStoreUserData();
                      final String email = await getUserData(0);
                      await StoreNotifier().fetchStoreUserData();
                      if (context.mounted) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreInfoPage(email: email),
                            ),
                            (route) => false);
                        setState(() {});
                      }
                    },
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

  // Method to build category item widget
  Padding categoryItem(int selectedCategory) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: GestureDetector(
        onTap: () {
          category = selectedCategory;
          setVisibility(selectedCategory);
          setState(() {});
        },
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: category == selectedCategory
                ? const Color.fromARGB(255, 198, 169, 146)
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

  // Method to get category icon based on selected category
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

  // Method to get category name based on selected category
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

  // Method to get category visibility based on selected category
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

  // Method to set category visibility based on selected category
  void setVisibility(int selected) {
    visibility1 = selected == 1;
    visibility2 = selected == 2;
    visibility3 = selected == 3;
    visibility4 = selected == 4;
  }
}
