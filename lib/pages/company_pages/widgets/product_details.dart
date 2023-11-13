import 'package:flutter/material.dart';

import '../../../utils/classes/menu_class.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key, required this.index, required this.menus});
  final List<Menu> menus;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              menus[index].menuItemImageLink,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
