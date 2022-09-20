import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task/constant.dart';
import 'package:task/model/atms.dart';
import 'package:task/screen/search/search_atms_degelte.dart';
import 'package:task/widget/search_card.dart';

import '../../api/controller/api_atm_controller.dart';
import '../../widget/navigation_button.dart';
import '../../widget/small_icon.dart';

class AtmsScreen extends StatefulWidget {
  const AtmsScreen(
      {Key? key, required this.tabController, this.myLong, this.myLat})
      : super(key: key);
  final TabController tabController;
  final double? myLat;
  final double? myLong;

  @override
  State<AtmsScreen> createState() => _AtmsScreenState();
}

class _AtmsScreenState extends State<AtmsScreen> {
  late Future<List<ATMs>> _futureAtms;

  @override
  void initState() {
    // TODO: implement initState
    _futureAtms = ApiATMsController().readATMS();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SearchCard(
          onPress: () {
            showSearch(
                context: context,
                delegate:
                    SearchATMsDelegate(tabController: widget.tabController));
          },
        ),
        FutureBuilder<List<ATMs>>(
          future: _futureAtms,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (context, index) {
                  double distanceInMeters = Geolocator.distanceBetween(
                    widget.myLat ?? 31,
                    widget.myLong ?? 32,
                    double.parse(snapshot.data![index].atmBin.split(',')[0]),
                    double.parse(snapshot.data![index].atmBin.split(', ')[1]),
                  );
                  String distanceInKelMeters =
                      (distanceInMeters / 1000).toStringAsFixed(2).toString();
                  marker.add(
                    Marker(
                      onTap: () {
                        googleMapController!.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                                target: LatLng(
                                    double.parse(snapshot.data![index].atmBin
                                        .split(',')[0]),
                                    double.parse(snapshot.data![index].atmBin
                                        .split(', ')[1])),
                                zoom: 15,
                                tilt: 45,
                                bearing: 15)));
                      },
                      markerId:
                          MarkerId('markerId_${snapshot.data![index].atmBin}'),
                      position: LatLng(
                        double.parse(
                            snapshot.data![index].atmBin.split(',')[0]),
                        double.parse(
                            snapshot.data![index].atmBin.split(', ')[1]),
                      ),
                      infoWindow: InfoWindow(
                          title: snapshot.data![index].atmName,
                          onTap: () {},
                          snippet:snapshot.data![index].atmAddress ),
                    ),
                  );
                  return Container(
                    padding: const EdgeInsets.all(20),
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.teal.shade50,
                              blurRadius: 5,
                              offset: const Offset(0, 0.75),
                              spreadRadius: 2),
                        ]),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                snapshot.data![index].atmAddress,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '$distanceInKelMeters km away',
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Container(
                                    height: 10,
                                    width: 10,
                                    decoration: BoxDecoration(
                                        color: Colors.green.shade600,
                                        borderRadius: BorderRadius.circular(5)),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'online',
                                    style: TextStyle(
                                      color: Colors.green.shade600,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              NavigationButton(
                                onPress: () {
                                  widget.tabController.animateTo(2);
                                },
                                color: Colors.green.shade600,
                              ),
                              const SizedBox(height: 5),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  SmallIcon(iconData: Icons.currency_exchange),
                                  SizedBox(width: 5),
                                  SmallIcon(iconData: Icons.fingerprint),
                                  SizedBox(width: 5),
                                  SmallIcon(iconData: Icons.wallet_rounded)
                                ],
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: snapshot.data!.length,
              );
            } else {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.warning_amber,
                      color: Colors.red,
                    ),
                    Text(
                      "you don't have any Data ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
