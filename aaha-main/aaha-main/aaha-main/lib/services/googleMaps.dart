import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class GoogleMaps extends StatefulWidget {
  final Function(LatLng) callback;
  final Function(bool) theme;
  final bool color;
  final LatLng position;
  const GoogleMaps({Key? key,required this.position, required this.callback, required this.theme, required this.color}) : super(key: key);

  @override
  State<GoogleMaps> createState() => _GoogleMapsState();
}

class _GoogleMapsState extends State<GoogleMaps> {
  late final LatLng p;
  Completer<GoogleMapController> _controller = Completer();
  late final CameraPosition _initialPosition;
  late bool theme;

  late Marker marker;

  Future<void> addMarker(coordinate) async {
    marker = Marker(markerId: const MarkerId("Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: coordinate
    );
    widget.callback(coordinate);
    setState(() {
    });
  }
  Future<void> goToLocation(coordinate) async {
    CameraPosition cameraPosition = CameraPosition(zoom: 14, target: coordinate);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  Future<Position> getCurrentLocation() async{
    await Geolocator.requestPermission().then((value) {

    }).onError((error, stackTrace) async{
      print("error" + error.toString());
      await Geolocator.requestPermission();
    });
    return await Geolocator.getCurrentPosition();
  }
  @override
  void initState() {
    // TODO: implement initState
    p = widget.position;
    _initialPosition = CameraPosition(target: p, zoom: 14);
    marker = Marker(markerId: const MarkerId("Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      position: p,
    );
    theme = widget.color;
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select your Location'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initialPosition,
            mapType: theme ? MapType.normal : MapType.satellite,
            onMapCreated: (GoogleMapController controller) {
              setState(() {
                _controller.complete(controller);
              });
            },
            markers: {
              marker
            },
            onTap: (coordinate) async {
              addMarker(coordinate);
              goToLocation(coordinate);
              // widget.callback(coordinate);
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.layers),
                      ),
                      onTap: () async {
                        theme = !theme;
                        widget.theme(theme);
                        setState(() {

                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      child: const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.my_location),
                      ),
                      onTap: () async {
                        getCurrentLocation().then((value) async{
                          //p = LatLng(value.latitude, value.longitude);
                          addMarker(LatLng(value.latitude, value.longitude));
                          goToLocation(LatLng(value.latitude, value.longitude));
                          // widget.callback(LatLng(value.latitude, value.longitude));
                        });
                        setState(() { });
                      },
                    ),
                  ),

                ],
              ),
            ],
          )
        ],
      ),
    );

  }
}
