// ignore_for_file: deprecated_member_use, avoid_print, library_private_types_in_public_api

import 'dart:convert';

import 'package:automender_shops/BackendUrl.dart';
import 'package:automender_shops/Controllers/Auth_Contollers/LoginController.dart';
import 'package:automender_shops/Controllers/TokenController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.put(LoginController());
  bool isLoading = true; 

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await refresh();
      setState(() {
        isLoading = false; 
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 50),
                    Image.asset(
                      'images/Logo-shops.png',
                      height: 200,
                    ),
                    TextFormField(
                      controller: loginController.emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      validator: _validateEmail,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: loginController.passwordController,
                      decoration: const InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: _validatePassword,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(AppRoutes.forgotPassword);
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(255, 97, 62, 234)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 97, 62, 234),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                      ),
                      onPressed:
                          loginController.isLoading.value ? null : _submitForm,
                      child: loginController.isLoading.value
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text('Login',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white)),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.signUp);
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 97, 62, 234)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

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

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!value.contains('@')) {
      return 'Invalid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value is! String || value.isEmpty) {
      return 'Please enter your password';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      loginController.updateEmailAndPassword();
      loginController.login();
    }
  }
}

Future<void> refresh() async {
  final authController = Get.find<AuthController>();
  if (authController.token != null) {
    var url = Uri.parse('${GlobalConfig.backendUrl}/auth_shop/refresh');
    try {
      var response = await http.post(
        url,
        headers: <String, String>{
          'Accept': 'application/json',
        },
        body: {
          'token': authController.token,
        },
      );

      print("================");
      print(response.headers);
      print(response.body);
      print("================");

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final String newToken = responseData['data']['token'];
        await authController.saveToken(newToken);
        Get.offAllNamed(AppRoutes.home);
      } else {
        await authController.removeToken();
      }
    } catch (e) {
      print('Error during token refresh: $e');
      await authController.removeToken();
    }
  } else {
  }
}
