import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  Completer<GoogleMapController> _controller = Completer();
   CameraPosition? _kGooglePlex;

  late Position cl;
  late double lat;
  late double long;

  Future getPer() async {
    bool service = await Geolocator.isLocationServiceEnabled();
    print(service);
    if (service == false) {
      AwesomeDialog(
              context: context,
              title: 'Service',
              body: const Text('Service not enabled'))
          .show();
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }
  Future<void> getLanLong() async {
    cl = await Geolocator.getCurrentPosition().then((value) => value);
    lat = cl.latitude;
    long = cl.longitude;
    _kGooglePlex= CameraPosition(
      target: LatLng(lat, long),
      zoom: 11.4746,
    );
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    getPer();
    getLanLong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            Visibility(
              visible: _kGooglePlex!=null,
              replacement: const CircularProgressIndicator(),
              child: Container(
                alignment: Alignment.center,
                height: 500,
                width: 400,
                child: GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: _kGooglePlex??CameraPosition(target: LatLng(31,31)),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                print('latitude is :  ${cl.latitude}');
                print('longitude is :  ${cl.longitude}');
              },
              child: const Text('Show Current Position'),
            ),
          ],
        ),
      ),
    );
  }
}
