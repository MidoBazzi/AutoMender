// ignore_for_file: file_names, camel_case_types, avoid_print

import 'dart:convert';

import 'package:automender_shops/BackendUrl.dart';
import 'package:automender_shops/Controllers/TokenController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app_routes.dart';
import 'package:automender_shops/model/service.dart';
import 'package:http/http.dart' as http;


class Confirm_adding_service extends StatelessWidget {
  const Confirm_adding_service({super.key});
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Confirm adding service',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 96, 62, 234),
          toolbarHeight: 100.0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30),
            onPressed: () {
              Get.toNamed(AppRoutes.shop_add_ser);
            },
          ),
        ),
        body: const ConfirmReservationScreen(),
      ),
    );
  }
}

class ConfirmReservationScreen extends StatelessWidget {
  const ConfirmReservationScreen({super.key});



  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final Service service = Get.arguments as Service;

        Future<void> addService() async {
      var url = Uri.parse('${GlobalConfig.backendUrl}/shop/add_service');
      try {
        var response = await http.post(
          url,
          headers: {'Accept': 'application/json',
             'Authorization': 'Bearer ${authController.token}',
          },
          body: {'service_id':service.id.toString(),},
        );
        if (response.statusCode == 200) {
          print("Service added successfully");
          Get.offAllNamed(AppRoutes.add_service_confirmed);
        } else {
        final responseData = json.decode(response.body);

        Get.snackbar('Login Failed', responseData['message']);
      }
      } catch (e) {

        print("Error adding service: $e");
      }
    }



    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'images/Logo-shops.png',
            height: 200,
            width: 500,
          ),
          const SizedBox(height: 20),
          Card(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  const Text(
                    'Confirm adding',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Service:',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Text(service.name, 
                          style: const TextStyle(
                            fontSize: 20,
                          )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Description:',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Text(service.desc, 
                          style: const TextStyle(
                            fontSize: 20,
                          )),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Price:',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Text('${service.price} S.P', 
                          style: const TextStyle(
                            fontSize: 20,
                          )),
                    ],
                  ),
                                    const SizedBox(height: 8),

                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('Required Time:',
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Text(service.timeReq, 
                          style: const TextStyle(
                            fontSize: 20,
                          )),
                    ],
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 96, 62, 234) 
                        ),
                    onPressed: () {
                      addService();
                      Get.offAllNamed(AppRoutes.add_service_confirmed);
                    },
                    child: const Text('Confirm',
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
