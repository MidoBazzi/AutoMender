// ignore_for_file: avoid_print, library_private_types_in_public_api, file_names

import 'dart:async';
import 'package:automender/Controllers/Auth_Contollers/CarController.dart';
import 'package:automender/app_routes.dart';
import 'package:automender/model/car_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class Endtrip extends StatefulWidget {
  final Car2 car;
  const Endtrip({super.key, required this.car});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<Endtrip> {
  GoogleMapController? mapController;
  LatLng? _lastPosition;
  double _totalDistance = 0.0;
  String _distanceDisplay = 'The Traveled Distance:';
  StreamSubscription<Position>? positionStreamSubscription;
  List<LatLng> polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _checkAndRequestLocationPermission();
  }

  Future<void> _checkAndRequestLocationPermission() async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    _startLocationUpdates();
  }

  void _startLocationUpdates() {
    positionStreamSubscription = Geolocator.getPositionStream().listen(
      (Position position) {
        setState(() {
          if (_lastPosition != null) {
            _totalDistance += Geolocator.distanceBetween(
              _lastPosition!.latitude,
              _lastPosition!.longitude,
              position.latitude,
              position.longitude,
            );

            polylineCoordinates
                .add(LatLng(position.latitude, position.longitude));
          }
          _lastPosition = LatLng(position.latitude, position.longitude);
        });

        if (mapController != null) {
          _animateCameraToPosition(_lastPosition!);
        }
      },
      onError: (e) {
        print('Error getting location: $e');
      },
    );
  }

  void _animateCameraToPosition(LatLng position) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 16.0),
      ),
    );
  }

  @override
  void dispose() {
    positionStreamSubscription?.cancel();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    if (_lastPosition != null) {
      _animateCameraToPosition(_lastPosition!);
    }
  }

  void _onCalculateDistancePressed() async {
    double distanceInKilometers = _totalDistance / 1000; 
    int distanceInMeters = distanceInKilometers.round(); 
    print("Distance calculated: $distanceInMeters meters");

    widget.car.currMialage += distanceInMeters;
    print("New mileage: ${widget.car.currMialage}");

    try {
      await Get.find<CarController>().editCurrMileage(widget.car.toMap());
      print("Car updated successfully");

      setState(() {
        _distanceDisplay =
            'The Traveled Distance: ${distanceInKilometers.toStringAsFixed(2)} kilometers';
      });

      await Future.delayed(const Duration(seconds: 2));
      print("Navigating back to home");
      Get.offNamed(AppRoutes.home); 
    } catch (e) {
      print('Error updating car: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'End Trip',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 96, 62, 234),
          toolbarHeight: 80.0,
        ),
        body: _lastPosition == null
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: _lastPosition ?? const LatLng(0, 0),
                      zoom: 16.0,
                    ),
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('route'),
                        points: polylineCoordinates,
                        color: Colors.blue, 
                        width: 5,
                      ),
                    },
                  ),
                  Positioned(
                    bottom: 20,
                    left: 120,
                    child: ElevatedButton(
                      onPressed: _onCalculateDistancePressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 97, 62, 234),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                      ),
                      child: const Text(
                        'End Trip',
                        style: TextStyle(fontSize: 24, color: Colors.white),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    right: 20,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.black54,
                      child: Text(
                        _distanceDisplay,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
