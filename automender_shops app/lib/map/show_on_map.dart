// ignore_for_file: non_constant_identifier_names, avoid_print

import 'package:automender_shops/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController? gmc;

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(33.504157, 36.253777),
    zoom: 16,
  );

  List<Marker> markers = [];

  @override
  void initState() {
    super.initState();
  }

  String locationX = "";
  String locationY = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 96, 62, 234),
              toolbarHeight: 50.0,
              title: const Text(
                'Choose where is your shop location',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, size: 30),
                onPressed: () {
                  Get.toNamed(AppRoutes.signUp);
                },
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: GoogleMap(
                    onTap: (LatLng latLng) {
                      locationX = latLng.latitude.toString();
                      locationY = latLng.longitude.toString();  
                      print('==============');
                      print(latLng.latitude);
                      print(latLng.longitude);
                      print('==============');
                      markers.add(Marker(
                        markerId: const MarkerId("1"),
                        position: LatLng(latLng.latitude, latLng.longitude)));
                      setState(() {});
                    },
                    markers: markers.toSet(),
                    initialCameraPosition: cameraPosition,
                    mapType: MapType.normal,
                    onMapCreated: (MapController) {
                      gmc = MapController;
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30, 
            left: 10,
            child: FloatingActionButton(
              onPressed: () {
                   if (locationX.isNotEmpty && locationY.isNotEmpty) {
                  Get.back(result: {'x': locationX, 'y': locationY});
                 } else {
                   print("No location selected");
                 }
              },
              child: const Icon(Icons.check), 
            ),
          ),
        ],
      ),
    );
  }
}
