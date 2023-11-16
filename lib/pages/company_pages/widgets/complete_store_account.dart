import 'package:flutter/material.dart';

import '../../../utils/classes/stores.dart';
import '../../../utils/database_operations/store/update_store.dart';
import '../../../widgets/dialogs.dart';

class CompleteAccount extends StatefulWidget {
  final List<Store> store;
  final String email;
  const CompleteAccount({super.key, required this.store, required this.email});

  @override
  State<CompleteAccount> createState() => _CompleteAccountState();
}

TimeOfDay selectedOpeningTime = TimeOfDay.now();
TimeOfDay selectedClosingTime = TimeOfDay.now();
String imageUrl = '';
String coverImageUrl = "";
bool isImageValid = false;
bool isCoverImageValid = false;
bool isReSubmitEnabled = false;
bool isReSubmitCoverEnabled = false;

class _CompleteAccountState extends State<CompleteAccount> {
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.store[0].storeName,
              textAlign: TextAlign.start,
            ),
            Text(
              widget.store[0].storeTaxId,
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 10),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              coverImageArea(context),
              imageArea(context),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    openingTimePicker(context),
                    closingTimePicker(context),
                  ],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: completeStoreButton(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton completeStoreButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (widget.email.isNotEmpty &&
            selectedClosingTime.hour.toString().isNotEmpty &&
            selectedClosingTime.minute.toString().isNotEmpty &&
            selectedOpeningTime.hour.toString().isNotEmpty &&
            selectedOpeningTime.minute.toString().isNotEmpty &&
            imageUrl.isNotEmpty) {
          await UpdateStoreApi().updateStore(
              context,
              widget.email,
              "${selectedOpeningTime.hour}:${selectedOpeningTime.minute > 9 ? selectedOpeningTime.minute : "0${selectedOpeningTime.minute}"}",
              "${selectedClosingTime.hour}:${selectedClosingTime.minute > 9 ? selectedClosingTime.minute : "0${selectedClosingTime.minute}"}",
              imageUrl,
              coverImageUrl);
        } else {
          Dialogs.showErrorDialog(
              context, 'One or mor field empty. Please try again');
        }
      },
      child: const Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Text(
              'Update store',
              style: TextStyle(fontSize: 16),
            ),
            Icon(Icons.add)
          ],
        ),
      ),
    );
  }

  Column openingTimePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: Text(
            'Opening time',
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width / 2.5,
            child: MaterialButton(
              onPressed: () async {
                final TimeOfDay? timeOfDay = await showTimePicker(
                  context: context,
                  initialTime: selectedOpeningTime,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child ?? Container(),
                    );
                  },
                );
                if (timeOfDay != null) {
                  selectedOpeningTime = timeOfDay;
                  setState(() {});
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedOpeningTime.hour.toString(),
                        style: const TextStyle(fontSize: 25),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          ":",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Text(
                        selectedOpeningTime.minute > 9
                            ? selectedOpeningTime.minute.toString()
                            : "0${selectedOpeningTime.minute.toString()}",
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ],
    );
  }

  Column closingTimePicker(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
          child: Text(
            'Closing time',
            textAlign: TextAlign.start,
          ),
        ),
        SizedBox(
            width: MediaQuery.of(context).size.width / 2.5,
            child: MaterialButton(
              onPressed: () async {
                final TimeOfDay? timeOfDay = await showTimePicker(
                  context: context,
                  initialTime: selectedClosingTime,
                  builder: (context, child) {
                    return MediaQuery(
                      data: MediaQuery.of(context)
                          .copyWith(alwaysUse24HourFormat: true),
                      child: child ?? Container(),
                    );
                  },
                );
                if (timeOfDay != null) {
                  selectedClosingTime = timeOfDay;
                  setState(() {});
                }
              },
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        selectedClosingTime.hour.toString(),
                        style: const TextStyle(fontSize: 25),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          ":",
                          style: TextStyle(fontSize: 25),
                        ),
                      ),
                      Text(
                        selectedClosingTime.minute > 9
                            ? selectedClosingTime.minute.toString()
                            : "0${selectedClosingTime.minute.toString()}",
                        style: const TextStyle(fontSize: 25),
                      ),
                    ],
                  ),
                ),
              ),
            )),
      ],
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
                        child: const Text('Add Logo'),
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

  Padding coverImageArea(BuildContext context) {
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
        width: MediaQuery.of(context).size.width,
        height: 200,
        child: coverImageUrl == ''
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _showCoverImageInputSheet(context);
                        },
                        child: const Text('Add Cover Image'),
                      ),
                    ],
                  ),
                ],
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  coverImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    isCoverImageValid = false;

                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(15.0),
                        child: Text('Error loading image. Please try again.'),
                      ),
                    );
                  },
                ),
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

  void _showCoverImageInputSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        isReSubmitCoverEnabled = true;
        return SingleChildScrollView(
          child: Container(
            height: 600,
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Enter Cover Image URL',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextField(
                  onChanged: (value) {
                    coverImageUrl = value;
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
                      coverImageUrl = coverImageUrl;
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
