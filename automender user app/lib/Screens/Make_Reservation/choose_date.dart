// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_routes.dart';
import '../../Controllers/Appointment_Controllers/AppointmentController.dart';
import '../../model/appointment_model.dart';

class ServiceAppointmentScreen extends StatefulWidget {
  const ServiceAppointmentScreen({super.key});

  @override
  _ServiceAppointmentScreenState createState() =>
      _ServiceAppointmentScreenState();
}

class _ServiceAppointmentScreenState extends State<ServiceAppointmentScreen> {
  final AppointmentController appointmentController =
      Get.put(AppointmentController());
  String? selectedDay;
  String? selectedTimeSlot;
  List<String> availableDays = [];
  Map<String, List<String>> availableTimeSlots = {};
  Appointments? appointment;
  String? serviceName;
  String? servicePrice;
  String? shopName;
  String? X;
  String? Y;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments['appointment'] is Appointments) {
      appointment = Get.arguments['appointment'] as Appointments; 
      _fetchAvailableDates(appointment!.ShopId); 
    } else {
      Get.back();
    }

    final arguments = Get.arguments as Map<String, dynamic>;
    serviceName = arguments['serviceName'];
    servicePrice = arguments['servicePrice'];
    shopName = arguments['shopName'];
    X = arguments['locationX'];
    Y = arguments['locationY'];
  }

  void _fetchAvailableDates(String shopId) async {
    availableDays = await appointmentController.fetchDates(shopId);
    setState(() {});
  }

  void _fetchAvailableTimeSlots(String shopId, String date) async {
    availableTimeSlots[date] = await appointmentController.fetchTimeSlots(
        shopId, appointment!.serviceId, date); 
    setState(() {});
  }

  void _onDaySelected(String day) {
    selectedDay = day;
    _fetchAvailableTimeSlots(appointment!.ShopId, day); 
    setState(() {
      selectedTimeSlot = null;
    });
  }

  void _proceed() {
    if (selectedDay == null || selectedTimeSlot == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Incomplete Selection'),
            content: const Text(
              'Please select both a day and a time slot.',
              style: TextStyle(fontSize: 18),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK', style: TextStyle(fontSize: 16)),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    } else {
      appointment!.date = selectedDay!;
      appointment!.startTime = selectedTimeSlot!;

      Get.toNamed(AppRoutes.confirm_reservation, arguments: {
        'appointment': appointment,
        'serviceName': serviceName,
        'shopName': shopName,
        'servicePrice': servicePrice,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Choose Date and Time\n${serviceName ?? ''}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 96, 62, 234),
          toolbarHeight: 100.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30),
            onPressed: () => Get.offNamed(
              AppRoutes
                  .chooseshop, 
              arguments: {
                'carId': appointment?.CarId,
                'serviceId': appointment?.serviceId,
                'serviceName': serviceName
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, 
                    children: [
                      Text(
                        shopName ?? '',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 96, 62, 234),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Get.toNamed(
                            AppRoutes.map,
                            arguments: {
                              'appointment': appointment,
                              'serviceName': serviceName,
                              'servicePrice': servicePrice,
                              'shopName': shopName,
                              'locationX': X,
                              'locationY': Y,
                            },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 96, 62, 234),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 20),
                        ),
                        child: const Text(
                          'Show on map',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(height: 20),
                const Text(
                  'When do you want the service?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: availableDays.map((day) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(day),
                          selected: selectedDay == day,
                          onSelected: (bool selected) {
                            if (selected) {
                              _onDaySelected(day);
                            }
                          },
                          backgroundColor: Colors.white,
                          selectedColor: const Color.fromARGB(255, 96, 62, 234),
                          labelStyle: TextStyle(
                            fontSize: 18,
                            color: selectedDay == day
                                ? Colors.white
                                : Colors.black,
                          ),
                          elevation: selectedDay == day ? 4 : 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Select the appointment time:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                if (selectedDay != null &&
                    availableTimeSlots.containsKey(selectedDay))
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 8.0,
                    children: availableTimeSlots[selectedDay]!.map((slot) {
                      return ChoiceChip(
                        label: Text(slot),
                        selected: selectedTimeSlot == slot,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedTimeSlot = selected ? slot : null;
                          });
                        },
                        backgroundColor: Colors.white,
                        selectedColor: const Color.fromARGB(255, 96, 62, 234),
                        labelStyle: TextStyle(
                          fontSize: 18,
                          color: selectedTimeSlot == slot
                              ? Colors.white
                              : Colors.black,
                        ),
                        elevation: selectedTimeSlot == slot ? 4 : 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }).toList(),
                  ),
                const SizedBox(height: 20),
                Text(
                  'Price: $servicePrice\S.P',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _proceed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 96, 62, 234),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 80),
                    ),
                    child: const Text(
                      'PROCEED',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
