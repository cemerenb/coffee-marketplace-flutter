import 'package:coffee/utils/database_operations/user/get_user.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class CustomerQrCode extends StatefulWidget {
  const CustomerQrCode({super.key, required this.data});

  @override
  State<CustomerQrCode> createState() => _CustomerQrCodeState();
  final String data;
}

bool isLoading = true;
String name = "";

class _CustomerQrCodeState extends State<CustomerQrCode> {
  @override
  void initState() {
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("QR Code")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 0,
            ),
            QrImageView(
              data: widget.data,
              size: 280,
              // You can include embeddedImageStyle Property if you
              //wanna embed an image from your Asset folder
              embeddedImageStyle: const QrEmbeddedImageStyle(
                size: Size(
                  200,
                  200,
                ),
              ),
            ),
            Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Color.fromARGB(255, 198, 169, 146)),
                child: isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(fontSize: 25),
                            ),
                            Text(
                                "${DateTime.now().day < 10 ? "0${DateTime.now().day}" : "${DateTime.now().day}"} ${DateTime.now().month < 10 ? "0${DateTime.now().month}" : "${DateTime.now().month}"} ${DateTime.now().year}t${(DateTime.now().hour + 3) % 24 < 9 ? "0${(DateTime.now().hour + 3) % 24}" : "${(DateTime.now().hour + 3) % 24}"}:${DateTime.now().minute < 9 ? "0${DateTime.now().minute}" : "${DateTime.now().minute}"}"
                                    .replaceAll("t", "  "))
                          ],
                        ),
                      ))
          ],
        ),
      ),
    );
  }

  void getName() async {
    name = await getUser(widget.data);
    isLoading = false;
    setState(() {});
  }
}
