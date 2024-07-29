// ignore_for_file: file_names, no_leading_underscores_for_local_identifiers, deprecated_member_use

import 'package:automender_shops/Controllers/Homecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app_routes.dart';

class ShopHomeScreen extends StatelessWidget {
  const ShopHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
  final UserProfileController userProfileController = Get.put(UserProfileController());

    Future<bool> _onWillPop() async {
      return (await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Are you sure?'),
              content: const Text(
                'Do you want to exit the App?',
                style: TextStyle(fontSize: 18),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('No', style: TextStyle(fontSize: 16)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Yes', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          )) ??
          false;
    }

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Obx((){
              return Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset(
                      'images/Logo-shops.png',
                      height: 200,
                    ),
                  ),
                   Text(
                     userProfileController.userProfile.value.shopName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.black
                    ),
                  ),
                   Text(
                     userProfileController.userProfile.value.ownerName,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                   Text(
                     userProfileController.userProfile.value.location,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text(
                         'open time : ${userProfileController.userProfile.value.openTime}:00am   ',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox( width: 20,),

                       Text(
                         'close time : ${userProfileController.userProfile.value.closeTime}:00pm',
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  GridView.count(
                    shrinkWrap: true,
                    physics:
                        const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    children: <Widget>[
                      ServiceTile(
                        icon: Icons.car_repair,
                        title: 'Add Service',
                        onTap: () {
                          Get.toNamed(AppRoutes.shop_add_ser);
                        },
                      ),
                      ServiceTile(
                        icon: Icons.people,
                        title: 'View Incoming Customer',
                        onTap: () {
                          Get.toNamed(AppRoutes.incoming_rides);
                        },
                      ),
                      ServiceTile(
                        icon: Icons.history,
                        title: 'History',
                        onTap: () {
                           Get.toNamed(AppRoutes.history);
                        },
                      ),
                      ServiceTile(
                        icon: Icons.edit,
                        title: 'Edit My Shop',
                        onTap: () {
                          Get.toNamed(AppRoutes.shop_profile);
                        },
                      ),
                    ],
                  ),
                ],
              );
  }
          ),
        )));
  }
}

class ServiceTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap; 

  const ServiceTile({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, 
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              size: 100,
              color: const Color.fromARGB(255, 97, 62, 234),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
