import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';


import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:task/constant.dart';
import 'package:task/screen/tab_screen/branch_screen.dart';
import 'package:task/screen/tab_screen/maps_screen.dart';

import 'tab_screen/atms_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double? lat;
  double? long;
   late Position cl;
  CameraPosition? _kGooglePlex;



  Future getPer() async {
    bool service = await Geolocator.isLocationServiceEnabled();
    if (service == false) {
      AwesomeDialog(
              context: context,
              title: 'Service',
              body: const Text('Service not enabled'),
              padding: const EdgeInsets.all(20))
          .show();
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  Future getLanLong() async {
    cl = await Geolocator.getCurrentPosition();
    // print(cl!.latitude);
   if(mounted){
     setState(() {
       lat = cl.latitude;
       long = cl.longitude;
       _kGooglePlex = CameraPosition(
         target: LatLng(lat!, long!),
         zoom:10,
         tilt: 45,
         bearing: 45,
       );
     });
   }
  }
  @override
  void initState() {
    // TODO: implement initState
    getPer();
     Future.delayed(const Duration(seconds: 4),(){
       getLanLong();
     });

    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        leading: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.arrow_back,
              size: 34,
            )),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.grid_view_rounded,
                size: 34,
              ))
        ],
        title: const Text(
          'Locator',
          style: TextStyle(color: Colors.black, fontSize: 22),
        ),
        backgroundColor: Colors.white,
        elevation: 7,
        shadowColor: Colors.teal.shade500,
        bottom: TabBar(
          onTap: (int value) {
           if(mounted){
             setState(() {
               _tabController.index = value;
             });
           }
            print(value);
          },
          indicatorWeight: 5,
          indicatorColor: Colors.green.shade700,
          labelColor: Colors.green.shade700,
          unselectedLabelColor: Colors.black45,
          controller: _tabController,
          isScrollable: false,
          padding: const EdgeInsets.only(left: 20, right: 20),
          tabs: const [
            Tab(child: Text('ATMs')),
            Tab(child: Text('Branch')),
            Tab(child: Text('ON Map')),
          ],
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: [
          AtmsScreen(tabController: _tabController, myLong: long, myLat: lat),
          BranchScreen(tabController: _tabController, myLat: lat, myLong: long),
          MapsScreen(kGooglePlex: _kGooglePlex, tabController: _tabController),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 6,
        notchMargin: 8,
        shape: const CircularNotchedRectangle(),
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              MaterialButton(
                onPressed: () {},
                minWidth: 40,
                child: Icon(
                  Icons.home,
                  color: Colors.grey.shade400,
                ),
              ),
              MaterialButton(
                onPressed: () {},
                minWidth: 45,
                child: Icon(
                  Icons.file_open_sharp,
                  color: Colors.grey.shade400,
                ),
              ),
              MaterialButton(
                onPressed: () {},
                minWidth: 40,
                child: Icon(
                  Icons.credit_card,
                  color: Colors.grey.shade400,
                ),
              ),
              MaterialButton(
                onPressed: () {},
                minWidth: 40,
                child: Icon(
                  Icons.settings,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        clipBehavior: Clip.antiAlias,
        backgroundColor: Colors.green.shade600,
        elevation: 10,
        child: const Icon(
          Icons.add,
          size: 38,
        ),
      ),
    );
  }
}