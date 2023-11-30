import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddMapInfo extends StatefulWidget {
  const AddMapInfo({
    super.key,
  });

  @override
  State<AddMapInfo> createState() => _AddMapInfoState();
}

late GoogleMapController mapController;
LatLng currentPosition = const LatLng(34, 34);
double zoom = 2;

class _AddMapInfoState extends State<AddMapInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        GoogleMap(
          zoomControlsEnabled: false,
          onMapCreated: (controller) async {
            log("${currentPosition.latitude.toString()}: ${currentPosition.longitude.toString()}");
            mapController = controller;
            currentPosition = await mapController.getLatLng(ScreenCoordinate(
                x: MediaQuery.of(context).size.width.toInt(),
                y: MediaQuery.of(context).size.height.toInt()));
          },
          initialCameraPosition: currentPosition.latitude.isNaN
              ? CameraPosition(target: const LatLng(34, 34), zoom: zoom)
              : CameraPosition(target: currentPosition, zoom: zoom),
          onCameraMove: (position) async {
            currentPosition = await mapController.getLatLng(ScreenCoordinate(
                x: MediaQuery.of(context).size.width.toInt(),
                y: MediaQuery.of(context).size.height.toInt()));
            log("${currentPosition.latitude.toString()}: ${currentPosition.longitude.toString()}");
          },
        ),
        Positioned(
            left: 10,
            bottom: 40,
            child: Container(
              width: 40,
              height: 100,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(255, 249, 241, 246)),
              child: Column(
                children: [
                  MaterialButton(
                    onPressed: () async {
                      var currentZoomLevel = await mapController.getZoomLevel();

                      currentZoomLevel = currentZoomLevel + 2;
                      if (mounted) {
                        double x = MediaQuery.of(context).size.width / 2;
                        double y = MediaQuery.of(context).size.height / 2;
                        log(x.toString());
                        log(y.toString());
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: LatLng(currentPosition.latitude,
                                  currentPosition.longitude * 0.8),
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
                      var currentZoomLevel = await mapController.getZoomLevel();

                      currentZoomLevel = currentZoomLevel - 2;
                      if (mounted) {
                        double x = MediaQuery.of(context).size.width / 2;
                        double y = MediaQuery.of(context).size.height / 2;
                        log(x.toString());
                        log(y.toString());
                        mapController.animateCamera(
                          CameraUpdate.newCameraPosition(
                            CameraPosition(
                              target: currentPosition,
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
                            child: Text("-", style: TextStyle(fontSize: 20)))),
                  )
                ],
              ),
            )),
        Positioned(
            top: MediaQuery.of(context).size.height / 2 - 55,
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
                onPressed: () {},
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
      ]),
    );
  }
}
