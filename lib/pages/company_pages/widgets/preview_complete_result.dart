import 'dart:developer';

import 'package:coffee/utils/database_operations/store/update_store.dart';
import 'package:coffee/utils/notifiers/store_notifier.dart';
import 'package:coffee/widgets/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class PreviewStore extends StatefulWidget {
  final String openingTime;
  final String closingTime;
  final String logoImage;
  final String coverImage;
  final String latitude;
  final String longitude;
  final String email;

  const PreviewStore({
    Key? key,
    required this.openingTime,
    required this.closingTime,
    required this.logoImage,
    required this.coverImage,
    required this.latitude,
    required this.longitude,
    required this.email,
  }) : super(key: key);

  @override
  State<PreviewStore> createState() => _PreviewStoreState();
}

class _PreviewStoreState extends State<PreviewStore> {
  late Future<Padding> _storeDetailsFuture;

  @override
  void initState() {
    _storeDetailsFuture = _fetchStoreDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
      ),
      body: mainBuilder(),
    );
  }

  Padding mainBuilder() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: FutureBuilder<Padding>(
        future: _storeDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Error loading store details.'),
            );
          } else if (snapshot.hasData) {
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(255, 150, 150, 150)
                              .withOpacity(0.5),
                          spreadRadius: 8,
                          blurRadius: 10,
                          offset:
                              const Offset(3, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    child: Stack(
                      children: [
                        GoogleMap(
                            zoomControlsEnabled: false,
                            markers: <Marker>{
                              Marker(
                                  markerId: const MarkerId("1"),
                                  icon: BitmapDescriptor.defaultMarker,
                                  position: LatLng(
                                      double.parse(widget.latitude),
                                      double.parse(widget.longitude)))
                            },
                            initialCameraPosition: CameraPosition(
                                target: LatLng(double.parse(widget.latitude),
                                    double.parse(widget.longitude)),
                                zoom: 16)),
                        Container(
                          color: Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                ),
                snapshot.data!,
              ],
            );
          } else {
            return Container(); // Return an empty container for other cases
          }
        },
      ),
    );
  }

  Future<Padding> _fetchStoreDetails() async {
    try {
      var storeNotifier = context.read<StoreNotifier>();
      await storeNotifier.fetchStoreUserData();
      var store =
          storeNotifier.stores.where((s) => s.storeEmail == widget.email).first;
      if (mounted) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: SizedBox(
                  height: 120,
                  width: MediaQuery.of(context).size.width,
                  child: Image.network(
                    widget.coverImage,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: const Color.fromARGB(255, 179, 179, 179)
                            .withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset:
                            const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: ListTile(
                    tileColor: const Color.fromARGB(255, 249, 241, 246),
                    leading: SizedBox(
                      height: 80,
                      width: 80,
                      child: Image.network(
                        widget.logoImage,
                        fit: BoxFit.contain,
                      ),
                    ),
                    title: Text(store.storeName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${widget.openingTime} - ${widget.closingTime}'),
                        const Row(
                          children: [
                            Text('-'),
                            Icon(
                              Icons.star,
                              color: Color.fromARGB(255, 216, 196, 19),
                              size: 20,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 10),
              completeStoreButton(context)
            ],
          ),
        );
      } else {
        return const Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(),
        );
      }
    } catch (error) {
      log('Error fetching store details: $error');
      rethrow; // Rethrow the error to let the FutureBuilder handle it
    }
  }

  ElevatedButton completeStoreButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (widget.email.isNotEmpty &&
            widget.openingTime.isNotEmpty &&
            widget.closingTime.isNotEmpty &&
            widget.coverImage.isNotEmpty &&
            widget.logoImage.isNotEmpty &&
            widget.latitude.isNotEmpty &&
            widget.longitude.isNotEmpty) {
          await UpdateStoreApi().updateStore(
              context,
              widget.email,
              widget.openingTime,
              widget.closingTime,
              widget.logoImage,
              widget.coverImage,
              widget.latitude,
              widget.longitude);
        } else {
          Dialogs.showErrorDialog(
              context, 'One or mor field empty. Please try again');
        }
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 50,
        child: const Center(
          child: Text(
            'Update store',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
