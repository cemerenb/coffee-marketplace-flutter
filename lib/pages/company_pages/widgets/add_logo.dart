import 'package:coffee/pages/company_pages/widgets/add_cover_image.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:flutter/material.dart';

class AddLogo extends StatefulWidget {
  final String email;
  const AddLogo({super.key, required this.email});

  @override
  State<AddLogo> createState() => _AddLogoState();
}

TimeOfDay selectedOpeningTime = TimeOfDay.now();
TimeOfDay selectedClosingTime = TimeOfDay.now();
String imageUrl = '';
bool isReSubmitEnabled = false;
bool isImageValid = false;

class _AddLogoState extends State<AddLogo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            imageArea(context),
            Visibility(
              visible: isReSubmitEnabled,
              child: ElevatedButton(
                  onPressed: () {
                    _showImageInputSheet(context);
                  },
                  child: const Text('Resubmit')),
            ),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (imageUrl.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddCoverImage(
                                    openingTime:
                                        "${selectedOpeningTime.hour > 9 ? selectedOpeningTime.hour : "0${selectedOpeningTime.hour}"}:${selectedOpeningTime.minute > 9 ? selectedOpeningTime.minute : "0${selectedOpeningTime.minute}"}",
                                    closingTime:
                                        "${selectedClosingTime.hour > 9 ? selectedClosingTime.hour : "0${selectedClosingTime.hour}"}:${selectedClosingTime.minute > 9 ? selectedClosingTime.minute : "0${selectedClosingTime.minute}"}",
                                    logoImage: imageUrl),
                              ));
                        } else {
                          Dialogs.showErrorDialog(
                              context, "Image can not be empty");
                        }

                        setState(() {});
                      },
                      child: const Text('Next')),
                ),
              ],
            )
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
