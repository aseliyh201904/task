import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task/constant.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen(
      {Key? key,
      this.kGooglePlex,
      this.myLat,
      this.myLong,
      required this.tabController})
      : super(key: key);
  final CameraPosition? kGooglePlex;
  final double? myLat;
  final double? myLong;
  final TabController? tabController;

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.kGooglePlex != null,
      replacement: const Center(child: CircularProgressIndicator()),
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: widget.kGooglePlex ??
            const CameraPosition(
                target: LatLng(31.685432, 35.212443), zoom: 11),
        onMapCreated: (GoogleMapController controller) {
          if (mounted) {
            setState(() {
              googleMapController = controller;
            });
          }
        },
        markers: marker,
        myLocationEnabled: true,
        tiltGesturesEnabled: true,
        compassEnabled: true,
        scrollGesturesEnabled: true,
        zoomGesturesEnabled: true,
      ),
    );
  }
}
