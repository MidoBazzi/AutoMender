// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:automender_shops/Controllers/servicecontroller.dart';
import '../../app_routes.dart';
import 'package:automender_shops/model/service.dart';

class ShopAddServiceScreen extends StatefulWidget {
  const ShopAddServiceScreen({Key? key}) : super(key: key);

  @override
  _ShopAddServiceScreenState createState() => _ShopAddServiceScreenState();
}

class _ShopAddServiceScreenState extends State<ShopAddServiceScreen> {
  String? selectedService;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ServiceController serviceController = Get.put(ServiceController());

  Service? getSelectedService() {
    return serviceController.services.firstWhere(
      (s) => s.name == selectedService,
    
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add service to your shop',
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 96, 62, 234),
        toolbarHeight: 100.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Get.toNamed(AppRoutes.home);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'images/Logo-shops.png',
                  height: 200,
                ),
                Obx(() {
                  if (serviceController.services.isEmpty) {
                    return const Text("No services available");
                  }
                  return DropdownButtonFormField<String>(
                    value: selectedService,
                    hint: const Text('Select a service'),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedService = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Please select a service' : null,
                    items: serviceController.services.map((service) {
                      return DropdownMenuItem<String>(
                        value: service.name,
                        child: Text(service.name,
                            style: const TextStyle(fontSize: 20)),
                      );
                    }).toList(),
                  );
                }),
                const SizedBox(height: 160),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 96, 62, 234),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  onPressed: () {
                    Get.toNamed(AppRoutes.request_service);
                  },
                  child: const Text('Request Service',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 96, 62, 234),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final selectedServiceObj = getSelectedService();
                      if (selectedServiceObj != null) {
                        Get.toNamed(AppRoutes.confirm_add_ser, arguments: selectedServiceObj);
                      } else {
                      }
                    }
                  },
                  child: const Text('Next',
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
