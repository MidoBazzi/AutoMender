// ignore_for_file: invalid_use_of_protected_member, camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:automender/Controllers/Appointment_Controllers/ServiceController.dart';
import 'package:automender/Controllers/Appointment_Controllers/ShopController.dart';
import 'package:automender/model/Shop_model.dart';
import 'package:automender/model/service_model.dart';
import 'package:automender/model/appointment_model.dart';
import 'package:get/get.dart';
import '../../app_routes.dart';

class Choose_Shop extends StatelessWidget {
  const Choose_Shop({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final String carId = arguments['carId'].toString();
    final String serviceId = arguments['serviceId'].toString();
    final String serviceName = arguments['serviceName'].toString();

    final ShopController shopController = Get.put(ShopController());
    final ServiceController serviceController = Get.put(ServiceController());

    shopController.fetchShops(serviceId);
    serviceController.fetchServices();

    return MaterialApp(
      home: MyHomePage(
          carId: carId, serviceId: serviceId, serviceName: serviceName),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String carId;
  final String serviceId;
  final String serviceName;

  const MyHomePage(
      {Key? key,
      required this.carId,
      required this.serviceId,
      required this.serviceName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ShopController shopController = Get.find<ShopController>();
    final ServiceController serviceController = Get.find<ServiceController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 96, 62, 234),
        toolbarHeight: 100.0,
        title: Text(
          'Choose the shop you want\n$serviceName',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Get.offNamed(AppRoutes.chooseservice, arguments: {'carId': carId});
          },
        ),
      ),
      body: Obx(() {
        final shops = shopController.shops.value;
        final services = serviceController.services.value;

        return ListView.builder(
          itemCount: shops.length,
          itemBuilder: (context, index) {
            var service = services.firstWhere(
              (srv) => srv.id == serviceId,
              orElse: () =>
                  Service(id: '', name: '', desc: '', price: '', timeReq: ''),
            );

            return ServiceTile(
              shop: shops[index],
              service: service,
              carId: carId,
              serviceId: serviceId,
            );
          },
        );
      }),
    );
  }
}

class ServiceTile extends StatelessWidget {
  final Shop shop;
  final Service service;
  final String carId;
  final String serviceId;

  const ServiceTile({
    Key? key,
    required this.shop,
    required this.service,
    required this.carId,
    required this.serviceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeData = Theme.of(context);

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
      child: InkWell(
        onTap: () {
          Appointments appointment = Appointments(
            CarId: carId,
            ShopId: shop.id.toString(),
            serviceId: serviceId,
          );
          Get.toNamed(
            AppRoutes.choosedate,
            arguments: {
              'appointment': appointment,
              'serviceName': service.name,
              'servicePrice': service.price,
              'shopName': shop.shopName,
              'locationX': shop.locationX,
              'locationY': shop.locationY,
            },
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                shop.picture,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.store, size: 150); 
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    shop.shopName,
                    style: TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      color: themeData.primaryColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                    child: Text(
                      service.desc,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${service.price} USD',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: themeData.colorScheme.secondary,
                        ),
                      ),
                      Text(
                        'Time required: ${service.timeReq}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Icon(Icons.location_on,
                          color: themeData.primaryColor, size: 20),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          shop.location,
                          style: const TextStyle(fontSize: 16),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
