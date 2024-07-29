// ignore_for_file: deprecated_member_use, avoid_print

import 'dart:convert';

import 'package:automender/BackendUrl.dart';
import 'package:automender/Controllers/HomeController.dart';
import 'package:automender/Controllers/TokenController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '/Controllers/Auth_Contollers/LoginController.dart';
import '../../app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final LoginController loginController = Get.put(LoginController());
  bool isLoading = true; // Added loading state

  @override
  void initState() {
    super.initState();
    Get.put(HomeController());
    Future.delayed(Duration.zero, () async {
      await refresh();
      setState(() {
        isLoading = false; // Update loading state
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
                      'images/Logo.png',
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
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.statichelp);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 97, 62, 234),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 10),
                      ),
                      child: const Text(
                        'Car Manual Help',
                        style: TextStyle(fontSize: 20, color: Colors.white),
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
    var url = Uri.parse('${GlobalConfig.backendUrl}/auth/refresh');
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
