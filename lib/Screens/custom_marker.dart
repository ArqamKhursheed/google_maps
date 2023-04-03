import 'dart:async';
import 'dart:ffi';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Custom_Marker extends StatefulWidget {
  const Custom_Marker({Key? key}) : super(key: key);

  @override
  State<Custom_Marker> createState() => _Custom_MarkerState();
}

class _Custom_MarkerState extends State<Custom_Marker> {
  static const CameraPosition _kGooglePlex =
      CameraPosition(target: LatLng(33.6941, 72.9734), zoom: 14.0);

  final Completer<GoogleMapController> _controller = Completer();
  Uint8List? markerimage;

  final List<Marker> _marker = <Marker>[];
  List<String> images = [
    'images/car.png',
    'images/caar.png',
    'images/deliveryman.png',
    'images/motorbike.png',
    'images/cutlery.png',
    'images/resturant.png'
  ];

  final List<LatLng> _LatLng = <LatLng>[
    LatLng(33.6941, 72.9734),
    LatLng(33.7008, 72.9682),
    LatLng(33.6992, 72.9744),
    LatLng(33.6939, 72.9771),
    LatLng(33.6910, 72.9807),
    LatLng(33.7036, 72.9785)
  ];

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  loadData() async {
    for (var i = 0; i < images.length; i++) {
      final Uint8List markerIcon =
          await getBytesFromAsset(images[i].toString(), 100);
      _marker.add(Marker(
          markerId: MarkerId(i.toString()),
          position: _LatLng[i],
          icon: BitmapDescriptor.fromBytes(markerIcon),
          infoWindow: InfoWindow(title: 'this is title marker: ')));
      setState(() {});
    }
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
    );
  }
}
