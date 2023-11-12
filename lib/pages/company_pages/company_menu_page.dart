import 'package:coffee/pages/company_pages/add_product.dart';
import 'package:coffee/pages/company_pages/widgets/product_details.dart';
import 'package:coffee/utils/classes/menu_class.dart';
import 'package:flutter/material.dart';

class MenusListView extends StatefulWidget {
  final List<Menu> menus;
  final String email;

  // ignore: prefer_const_constructors_in_immutables
  MenusListView({Key? key, required this.menus, required this.email})
      : super(key: key);

  @override
  State<MenusListView> createState() => _MenusListViewState();
}

class _MenusListViewState extends State<MenusListView> {
  bool isFound = false;
  int category = 1;
  bool visibility1 = true;
  bool visibility2 = false;
  bool visibility3 = false;
  bool visibility4 = false;

  @override
  Widget build(BuildContext context) {
    bool isFound2 = widget.menus
            .where((element) => element.storeEmail == widget.email)
            .isNotEmpty &&
        widget.menus
            .where((element) => element.menuItemCategory == category)
            .isNotEmpty;

    return Column(
      children: [
        const SizedBox(
          height: 50,
        ),
        Row(
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
                      builder: (context) => AddNewProduct(email: widget.email),
                    ));
              },
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            )
          ],
        ),
        if (isFound2)
          ListView.builder(
            shrinkWrap: true,
            itemCount: widget.menus.length,
            itemBuilder: (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetails(
                            menus: widget.menus,
                          ),
                        ));
                  },
                  leading: FadeInImage(
                    placeholder:
                        const AssetImage('assets/img/placeholder_image.png'),
                    image: NetworkImage(widget.menus[index].menuItemImageLink),
                    fit: BoxFit.cover,
                  ),
                  title: Text(widget.menus[index].menuItemName),
                  subtitle: Text(widget.menus[index].menuItemDescription),
                  trailing: Text(
                    "${widget.menus[index].menuItemPrice} ₺",
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              );
            },
          )
        else
          const Center(
            child: Text('No item found'),
          ),
      ],
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
