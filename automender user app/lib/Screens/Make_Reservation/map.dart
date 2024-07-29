import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:automender/model/appointment_model.dart';
import 'package:automender/app_routes.dart';

void main() {
  runApp(const MapScreen());
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? gmc;
  Appointments? appointment;
  String? serviceName;
  String? servicePrice;
  String? shopName;

  CameraPosition cameraPosition = const CameraPosition(
    target: LatLng(33.504157, 36.253777),
    zoom: 16,
  );

  List<Marker> markers = [
    const Marker(
        markerId: MarkerId('1'),
        position: LatLng(33.504157, 36.253777)), 
  ];

  @override
  void initState() {
    super.initState();

    if (Get.arguments != null && Get.arguments['appointment'] is Appointments) {
      appointment = Get.arguments['appointment'] as Appointments;
      serviceName = Get.arguments['serviceName'];
      servicePrice = Get.arguments['servicePrice'];
      shopName = Get.arguments['shopName'];
      final String? X = Get.arguments['locationX'];
      final String? Y = Get.arguments['locationY'];

      double? latitude = X != null ? double.tryParse(X) : null;
      double? longitude = Y != null ? double.tryParse(Y) : null;

   
      if (latitude != null && longitude != null) {
   
        setState(() {
          cameraPosition = CameraPosition(
            target: LatLng(latitude, longitude),
            zoom: 15,
          );
          markers = [
            Marker(
              markerId: const MarkerId('1'),
              position: LatLng(latitude, longitude),
            ),
          ];
        });
      } else {

        Get.back();
      }
    } else {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 96, 62, 234),
          toolbarHeight: 50.0,
          title: const Text(
            'Shop Location on Maps',
            style: TextStyle(
              color: Colors.white,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30),
            onPressed: () {
              Get.toNamed(
                AppRoutes.choosedate,
                arguments: {
                  'appointment': appointment,
                  'serviceName': serviceName,
                  'shopName': shopName,
                  'servicePrice': servicePrice
                },
              );
            },
          ),
        ),
        body: Column(children: [
          Expanded(
            child: GoogleMap(
              markers: markers.toSet(),
              initialCameraPosition: cameraPosition,
              mapType: MapType.normal,
              onMapCreated: (controller) {
                gmc = controller;
              },
            ),
          )
        ]),
      ),
    );
  }
}
