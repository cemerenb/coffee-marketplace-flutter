import 'dart:developer';
import 'dart:io';

import 'package:coffee/pages/company_pages/company_give_free_drink.dart';
import 'package:coffee/pages/company_pages/company_transfer_points.dart';
import 'package:coffee/utils/notifiers/loyalty_user.dart';
import 'package:coffee/utils/notifiers/order_notifier.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CompanyScanQrCode extends StatefulWidget {
  const CompanyScanQrCode({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CompanyScanQrCodeState();
}

class _CompanyScanQrCodeState extends State<CompanyScanQrCode> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: _buildQrView(context),
              ),
              Positioned(
                  top: 60,
                  left: 20,
                  child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Center(
                          child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                                size: 20,
                              ))))),
              Positioned(
                bottom: 30,
                right: 20,
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.black.withOpacity(0.3),
                  ),
                  child: Center(
                    child: IconButton(
                        onPressed: () async {
                          await controller?.flipCamera();
                          setState(() {});
                        },
                        icon: const Icon(
                          Icons.flip_camera_android,
                          color: Colors.white,
                          size: 30,
                        )),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 300.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    var orderNotifier = context.read<OrderNotifier>();
    var pointNotifier = context.read<LoyaltyUserNotifier>();
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code!.isNotEmpty && mounted) {
        await orderNotifier.fetchCompanyOrderData();
        await pointNotifier.getPoints();
        if (mounted) {
          setState(() {
            result = scanData;
            Navigator.pop(context);
            if (result!.code.toString().isNotEmpty &&
                result!.code.toString().split(":").first == "givepoint") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransferPoints(
                        email: result!.code.toString().split(":").last),
                  ));
            } else if (result!.code.toString().isNotEmpty &&
                result!.code.toString().split(":").first == "redeempoint") {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GiveFreeDrink(
                        email: result!.code.toString().split(":").last),
                  ));
            }
          });
        }
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
