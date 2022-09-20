import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:task/api/controller/api_atm_controller.dart';
import 'package:task/api/controller/api_branch_controller.dart';
import 'package:task/model/atms.dart';
import 'package:task/screen/tab_screen/atms_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../model/branch.dart';
import '../../widget/navigation_button.dart';
import '../../widget/small_icon.dart';

class SearchATMsDelegate extends SearchDelegate {
  final TabController tabController;
  final double? myLat;
  final double? myLong;

  SearchATMsDelegate({required this.tabController, this.myLat, this.myLong});

  @override
  List<Widget>? buildActions(BuildContext context) {

    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.close))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final Future<List<ATMs>> futureAtms = ApiATMsController().readATMS(query: query);
   return Padding(
     padding: const EdgeInsets.all(20.0),
     child: FutureBuilder<List<ATMs>>(
       future: futureAtms,
       builder: (context, snapshot) {
         if (snapshot.connectionState == ConnectionState.waiting) {
           return const Center(child: CircularProgressIndicator());
         } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
           return ListView.builder(
             shrinkWrap: true,
             physics: const ScrollPhysics(),
             itemBuilder: (context, index) {
               double distanceInMeters = Geolocator.distanceBetween(
                 myLat ?? 31,
                 myLong ?? 32,
                 double.parse(snapshot.data![index].atmBin.split(',')[0]),
                 double.parse(snapshot.data![index].atmBin.split(', ')[1]),
               );
               String distanceInKelMeters =
               (distanceInMeters / 1000).toStringAsFixed(2).toString();
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
                             '$distanceInKelMeters km',
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
                               Navigator.pop(context);
                               tabController.animateTo(2);
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
   );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(
      child:  Text('Search Branch'),
    );
  }
  // Future<void> _makePhoneCall(String phoneNumber) async {
  //   final Uri launchUri = Uri(
  //     scheme: 'tel',
  //     path: phoneNumber,
  //   );
  //   await launchUrl(launchUri);
  // }
}
