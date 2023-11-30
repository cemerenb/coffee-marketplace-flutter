import 'dart:developer';

import 'package:coffee/pages/company_pages/widgets/preview_complete_result.dart';
import 'package:coffee/utils/get_user/get_user_data.dart';
import 'package:coffee/utils/notifiers/store_notifier.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddMapInfo extends StatefulWidget {
  final String openingTime;
  final String closingTime;
  final String logoImage;
  final String coverImage;
  const AddMapInfo({
    super.key,
    required this.openingTime,
    required this.closingTime,
    required this.logoImage,
    required this.coverImage,
  });

  @override
  // ignore: library_private_types_in_public_api
  _AddMapInfoState createState() => _AddMapInfoState();
}

class _AddMapInfoState extends State<AddMapInfo> {
  late GoogleMapController _controller;
  LatLng _center = const LatLng(34, 34);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            zoomControlsEnabled: false,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            onCameraMove: (CameraPosition position) {
              setState(() {
                _center = position.target;
                log('Latitude: ${_center.latitude}, Longitude: ${_center.longitude}');
              });
            },
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 4,
            ),
          ),
          Positioned(
              top: MediaQuery.of(context).size.height / 2 - 30,
              left: MediaQuery.of(context).size.width / 2 - 25,
              child: Icon(
                Icons.location_pin,
                size: 50,
                color: Colors.brown.shade500,
              )),
          Positioned(
              right: 20,
              bottom: 20,
              child: ElevatedButton(
                  onPressed: () async {
                    final String email = await getUserData(0);
                    await StoreNotifier().fetchStoreUserData();
                    if (mounted) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PreviewStore(
                              openingTime: widget.openingTime,
                              closingTime: widget.closingTime,
                              logoImage: widget.logoImage,
                              coverImage: widget.coverImage,
                              latitude: _center.latitude.toString(),
                              longitude: _center.longitude.toString(),
                              email: email,
                            ),
                          ));
                    }
                  },
                  child: const Icon(
                    Icons.done,
                    size: 30,
                  ))),
          Positioned(
            left: 10,
            top: 30,
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
          ),
          Positioned(
              left: 10,
              bottom: 40,
              child: Container(
                width: 40,
                height: 100,
                decoration: BoxDecoration(
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(110, 0, 0, 0),
                          blurStyle: BlurStyle.outer,
                          offset: Offset(1, 1),
                          spreadRadius: 0,
                          blurRadius: 5)
                    ],
                    borderRadius: BorderRadius.circular(10),
                    color: const Color.fromARGB(255, 249, 241, 246)),
                child: Column(
                  children: [
                    MaterialButton(
                      onPressed: () async {
                        var currentZoomLevel = await _controller.getZoomLevel();

                        currentZoomLevel = currentZoomLevel + 2;
                        if (mounted) {
                          _controller.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: _center,
                                zoom: currentZoomLevel,
                              ),
                            ),
                          );
                        }
                      },
                      child: const SizedBox(
                          height: 49,
                          width: 30,
                          child: Center(
                              child: Text(
                            "+",
                            style: TextStyle(fontSize: 20),
                          ))),
                    ),
                    Container(
                      height: 1,
                      width: 40,
                      color: const Color.fromARGB(80, 0, 0, 0),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        var currentZoomLevel = await _controller.getZoomLevel();

                        currentZoomLevel = currentZoomLevel - 2;

                        _controller.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: _center,
                              zoom: currentZoomLevel,
                            ),
                          ),
                        );
                      },
                      child: const SizedBox(
                          height: 49,
                          width: 30,
                          child: Center(
                              child:
                                  Text("-", style: TextStyle(fontSize: 20)))),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
