import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationTracer extends StatefulWidget {
  const LocationTracer({Key? key}) : super(key: key);

  @override
  State<LocationTracer> createState() => _LocationTracerState();
}

class _LocationTracerState extends State<LocationTracer> {
  static const CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(24.971723, 67.065707), zoom: 14.0);

  final Completer<GoogleMapController> _controller = Completer();

  final List<Marker> _marker = [];

  final List<Marker> list = [
    const Marker(
      markerId: MarkerId('1'),
      position: LatLng(24.971723, 67.065707),
      infoWindow: InfoWindow(title: 'My current location'),
    ),
  ];
  Future<Position> getcurrentlocation() async {
    await Geolocator.requestPermission()
        .then((value) {})
        .onError((error, stackTrace) {
      print("error" + error.toString());
    });
    return await Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GoogleMap(
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
          initialCameraPosition: _kGooglePlex,
          markers: Set<Marker>.of(_marker),
          // mapType: MapType.hybrid,
          myLocationEnabled: true,
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          compassEnabled: true,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.location_disabled_outlined),
        onPressed: () async {
          getcurrentlocation().then((value) async {
            print('my current location');
            print(value.latitude.toString() + value.longitude.toString());
            _marker.add(
              Marker(
                  markerId: MarkerId('2'),
                  position: LatLng(value.longitude, value.latitude),
                  infoWindow: InfoWindow(title: 'Mylocation')),
            );
            CameraPosition cameraPosition = CameraPosition(
              target: LatLng(value.longitude, value.latitude),
            );
            GoogleMapController controller = await _controller.future;
            controller.animateCamera(
              CameraUpdate.newCameraPosition(cameraPosition),
            );
            setState(() {});
          });
        },
      ),
    );
  }
}
