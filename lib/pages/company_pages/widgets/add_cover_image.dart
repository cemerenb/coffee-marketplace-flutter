import 'package:coffee/pages/company_pages/widgets/add_map_info.dart';
import 'package:flutter/material.dart';

class AddCoverImage extends StatefulWidget {
  final String openingTime;
  final String closingTime;
  final String logoImage;
  const AddCoverImage(
      {super.key,
      required this.openingTime,
      required this.closingTime,
      required this.logoImage});

  @override
  State<AddCoverImage> createState() => _AddCoverImageState();
}

String coverImageUrl = "";
bool isCoverImageValid = false;

bool isReSubmitCoverEnabled = false;

class _AddCoverImageState extends State<AddCoverImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            coverImageArea(context),
            Visibility(
              visible: isReSubmitCoverEnabled,
              child: ElevatedButton(
                  onPressed: () {
                    _showCoverImageInputSheet(context);
                  },
                  child: const Text('Resubmit')),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: ElevatedButton(
                      onPressed: () {
                        if (coverImageUrl.isNotEmpty) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AddMapInfo()));
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
                      isReSubmitCoverEnabled = true;
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
}
