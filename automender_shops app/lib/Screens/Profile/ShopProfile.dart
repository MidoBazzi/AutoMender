// ignore_for_file: unused_field, use_build_context_synchronously, library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:automender_shops/Controllers/ShopController.dart';
import 'package:automender_shops/Controllers/TokenController.dart';
import 'package:automender_shops/BackendUrl.dart';
import '../../app_routes.dart';

class ShopProfileScreen extends StatefulWidget {
  const ShopProfileScreen({Key? key}) : super(key: key);

  @override
  _ShopProfileScreenState createState() => _ShopProfileScreenState();
}

class _ShopProfileScreenState extends State<ShopProfileScreen> {
  final ShopController shopController = Get.put(ShopController(), permanent: true);
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _ownerNameController;
  late final TextEditingController _shopNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  String _newPassword = '';
  String _confirmPassword = '';

  @override
  void initState() {
    super.initState();

    _ownerNameController = TextEditingController(text: shopController.ownerName.value);
    _shopNameController = TextEditingController(text: shopController.shopName.value);
    _phoneController = TextEditingController(text: shopController.phoneNum.value);
    _emailController = TextEditingController(text: shopController.email.value);

    ever(shopController.ownerName, (dynamic name) => _ownerNameController.text = name);
    ever(shopController.shopName, (dynamic name) => _shopNameController.text = name);
    ever(shopController.phoneNum, (dynamic phone) => _phoneController.text = phone);
    ever(shopController.email, (dynamic email) => _emailController.text = email);
  }

  @override
  void dispose() {
    _ownerNameController.dispose();
    _shopNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shop and Owner Profile',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 96, 62, 234),
        toolbarHeight: 100.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 25),
          onPressed: () => Get.toNamed(AppRoutes.home),
        ),
        actions: [
          ElevatedButton.icon(
            icon: const Icon(Icons.logout, size: 30),
            label: const Text(
              'Log Out',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            onPressed: logout,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(84, 21, 12, 54),
              elevation: 0,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _ownerNameController,
                decoration: const InputDecoration(labelText: 'Owner Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the owner\'s name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _shopNameController,
                decoration: const InputDecoration(labelText: 'Shop Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the shop name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                readOnly: true,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New Password'),
                onChanged: (value) => _newPassword = value,
              ),
              const SizedBox(height: 10),
              TextFormField(
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                onChanged: (value) => _confirmPassword = value,
                validator: (value) {
                  if (_newPassword.isNotEmpty && value != _newPassword) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 96, 62, 234),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {

      shopController.updateShopProfile(
        _ownerNameController.text,
        _shopNameController.text,
        _phoneController.text,
        _newPassword,
      );

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved successfully.')));
    }
  }

  Future<void> logout() async {
    final AuthController authController = Get.find<AuthController>();
    var url = Uri.parse('${GlobalConfig.backendUrl}/auth_shop/logout');
    var response = await http.post(
      url,
      headers: <String, String>{
        'Accept': 'application/json',
      },
      body: {
        'token': authController.token,
      },
    );

    if (response.statusCode == 200) {
      await authController.removeToken();
      Get.offAllNamed(AppRoutes.login);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logout failed.')));
    }
  }
}
