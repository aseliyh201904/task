import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task/api/controller/api_branch_controller.dart';
import 'package:task/constant.dart';
import 'package:task/model/branch.dart';
import 'package:task/screen/search/search_branch_degelte.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../widget/search_card.dart';

class BranchScreen extends StatefulWidget {
  const BranchScreen(
      {Key? key, required this.tabController, this.myLat, this.myLong})
      : super(key: key);
  final TabController tabController;

  final double? myLat;
  final double? myLong;

  @override
  State<BranchScreen> createState() => _BranchScreenState();
}

class _BranchScreenState extends State<BranchScreen> {
  final Future<List<Branch>> _futureBranch = ApiBranchController().readBranch();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        SearchCard(
          onPress: () {
            showSearch(
                context: context,
                delegate: SearchBranchDelegate(
                  tabController: widget.tabController,
                  myLat: widget.myLat,
                  myLong: widget.myLong,
                ));
          },
        ),
        FutureBuilder<List<Branch>>(
          future: _futureBranch,
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
                    double.parse(snapshot.data![index].branchBin.split(',')[0]),
                    double.parse(
                        snapshot.data![index].branchBin.split(', ')[1]),
                  );
                  String distanceInKelMeters =
                  (distanceInMeters / 1000).toStringAsFixed(2).toString();
                  marker.add(Marker(
                    onTap: () {
                      googleMapController!.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                              target: LatLng(
                                  double.parse(snapshot.data![index].branchBin
                                      .split(',')[0]),
                                  double.parse(snapshot.data![index].branchBin
                                      .split(', ')[1])),
                              zoom: 15,
                              tilt: 15,
                              bearing: 15),
                        ),
                      );
                    },
                    markerId:
                        MarkerId('branchId_${snapshot.data![index].branchId}'),
                    position: LatLng(
                      double.parse(
                          snapshot.data![index].branchBin.split(',')[0]),
                      double.parse(
                          snapshot.data![index].branchBin.split(', ')[1]),
                    ),
                    infoWindow: InfoWindow(
                        title: snapshot.data![index].branchName,
                        onTap: () {},
                        snippet:
                        snapshot.data![index].branchAddress,
                    )
                  ));

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Material(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      clipBehavior: Clip.antiAlias,
                      shadowColor: Colors.teal.shade300,
                      color: Colors.white,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                color: Colors.teal.shade50,
                                blurRadius: 10,
                                spreadRadius: 4,
                                offset: const Offset(0, 0.75),
                              ),
                            ]),
                            height: 80,
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      snapshot.data![index].branchName,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 10,
                                          width: 10,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Colors.green.shade800),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'open now',
                                          style: TextStyle(
                                              color: Colors.green.shade800),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  '${distanceInKelMeters}km away',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: Colors.black,
                            height: 5,
                            thickness: 1,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: size.width / 2,
                                height: 50,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    widget.tabController.animateTo(2);
                                  },
                                  icon: Transform.rotate(
                                    angle: 5.5,
                                    alignment: Alignment.center,
                                    child: const Icon(
                                      Icons.send,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  label: const Text(
                                    'Navigation',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.green.shade600,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextButton.icon(
                                  onPressed: () async {
                                    await _makePhoneCall(
                                        snapshot.data![index].branchPhone);
                                  },
                                  label: Text(
                                    'Call ',
                                    style: TextStyle(
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                  icon: Icon(
                                    Icons.call,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
