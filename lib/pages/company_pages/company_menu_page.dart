import 'package:coffee/pages/company_pages/company_orders_page.dart';
import 'package:coffee/pages/company_pages/company_settings.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';

import 'package:coffee/pages/company_pages/add_product.dart';
import 'package:coffee/pages/company_pages/widgets/product_details.dart';
import 'package:coffee/utils/classes/menu_class.dart';
import 'package:flutter/material.dart';

import '../../utils/database_operations/store/get_store_data.dart';
import '../../utils/database_operations/store/get_menu.dart';

class MenusListView extends StatefulWidget {
  final String email;

  // ignore: prefer_const_constructors_in_immutables
  MenusListView({Key? key, required this.email}) : super(key: key);

  @override
  State<MenusListView> createState() => _MenusListViewState();
}

List<Menu> menus = [];

class _MenusListViewState extends State<MenusListView> {
  @override
  void initState() {
    super.initState();
    fetchMenuData().then((success) async {});
    setState(() {});
  }

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
              listMenuItems(context)
            ],
          ),
        ),
      ),
      bottomNavigationBar: bottomNavigationBar(),
    );
  }

  Padding listMenuItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        children: menus.indexed.map((item) {
          var (index, menusItem) = item;
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

  Padding bottomNavigationBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0, left: 10, right: 10),
      child: Container(
        decoration: BoxDecoration(
            color: const Color.fromARGB(255, 88, 88, 88).withOpacity(0.3),
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
                        Icon(Icons.coffee,
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
                    onPressed: () async {
                      final String email = await getUserData(0);
                      await fetchStoreData();
                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoreInfoPage(email: email),
                            ));
                      }

                      setState(() {});
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
