import 'dart:developer';

import 'package:coffee/utils/database_operations/create_product.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class AddNewProduct extends StatefulWidget {
  const AddNewProduct({Key? key, required this.email}) : super(key: key);

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
  final String email;
}

class _AddNewProductState extends State<AddNewProduct> {
  String imageUrl = '';
  bool isImageValid = false;
  bool isReSubmitEnabled = false;

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final List<String> categories = [
    'Hot Drinks',
    'Cold Drinks',
    'Deserts',
    'Snacks'
  ];
  String selectedCategory = 'Hot Drinks';
  int chosenCategory = 1;

  // Map category names to their corresponding indices
  final Map<String, int> categoryIndices = {
    'Hot Drinks': 1,
    'Cold Drinks': 2,
    'Deserts': 3,
    'Snacks': 4,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add new item'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),
                imageArea(context),
                if (isReSubmitEnabled)
                  ElevatedButton(
                    onPressed: () {
                      _showImageInputSheet(context);
                    },
                    child: const Text('Resubmit Image'),
                  ),
                addProductTextField(productNameController),
                addProductDescriptionTextField(descriptionController),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [categoryDropdown(), priceTextField(context)],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        onPressed: () async {
                          if (widget.email.isNotEmpty &&
                              productNameController.text.isNotEmpty &&
                              descriptionController.text.isNotEmpty &&
                              imageUrl.isNotEmpty &&
                              priceController.text.isNotEmpty) {
                            log(widget.email);
                            log(int.parse(priceController.text).toString());
                            var (isSuccess, responseMessage) =
                                await CreateProductApi().createProduct(
                                    widget.email,
                                    productNameController.text,
                                    descriptionController.text,
                                    imageUrl,
                                    "1",
                                    1,
                                    int.parse(priceController.text),
                                    chosenCategory);
                            if (isSuccess && context.mounted) {
                              Dialogs.showProductCreatedDialog(
                                  context, responseMessage);
                            } else {
                              Dialogs.showErrorDialog(context, responseMessage);
                            }
                          } else {
                            Dialogs.showErrorDialog(context,
                                'One or mor field empty. Please try again');
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                'Add Item',
                                style: TextStyle(fontSize: 16),
                              ),
                              Icon(Icons.add)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox priceTextField(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.2,
      child: TextField(
        textInputAction: TextInputAction.done,
        controller: priceController,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Price',
          suffix: const Text('₺'),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 1),
          ),
        ),
      ),
    );
  }

  Padding addProductTextField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: TextField(
        textInputAction: TextInputAction.next,
        keyboardType: TextInputType.text,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Product Name',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 1),
          ),
        ),
      ),
    );
  }

  Padding addProductDescriptionTextField(TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: TextField(
        textInputAction: TextInputAction.next,
        maxLength: 200,
        maxLines: 4,
        minLines: 1,
        keyboardType: TextInputType.text,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: 'Description',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(width: 1),
          ),
        ),
      ),
    );
  }

  Padding categoryDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: Container(
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
            )),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: DropdownButton<String>(
            underline: const SizedBox(),
            value: selectedCategory,
            onChanged: (String? newValue) {
              setState(() {
                selectedCategory = newValue!;
                chosenCategory = categoryIndices[selectedCategory] ?? 1;
                log(chosenCategory.toString());
              });
            },
            items: categories.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            isExpanded: true,
          ),
        ),
      ),
    );
  }

  Padding imageArea(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              spreadRadius: 0,
              blurRadius: 20,
              color: Colors.grey.withOpacity(0.4),
              blurStyle: BlurStyle.outer,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        width: MediaQuery.of(context).size.width / 2.4,
        height: MediaQuery.of(context).size.width / 2.4,
        child: imageUrl == ''
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showImageInputSheet(context);
                        },
                        child: const Text('Add Image'),
                      ),
                    ],
                  ),
                ],
              )
            : Image.network(
                imageUrl,
                errorBuilder: (BuildContext context, Object error,
                    StackTrace? stackTrace) {
                  isImageValid = false;

                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(15.0),
                      child: Text('Error loading image. Please try again.'),
                    ),
                  );
                },
              ),
      ),
    );
  }

  void _showImageInputSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        isReSubmitEnabled = true;
        return SingleChildScrollView(
          child: Container(
            height: 600,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter Image URL',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    imageUrl = value;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Optionally, you can update the image in the parent widget
                    setState(() {
                      imageUrl = imageUrl;
                    });
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
