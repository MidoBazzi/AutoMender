// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '/Controllers/Auth_Contollers/SignUpController.dart';
import '../../app_routes.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onVerificationPressed;

  const SignUpScreen({super.key, required this.onVerificationPressed});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignUpController signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Enter your information',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 96, 62, 234),
        toolbarHeight: 100.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 30),
          onPressed: () {
            Get.toNamed(AppRoutes.login);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Image.asset(
                  'images/Logo.png',
                  height: 200,
                ),
                const SizedBox(height: 15.0),
                _buildTextField(
                  controller: signUpController.nameController,
                  label: 'Name',
                  errorText: 'Please enter your name',
                ),
                const SizedBox(height: 15.0),
                _buildTextField(
                  controller: signUpController.emailController,
                  label: 'Email',
                  errorText: 'Please enter your email',
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15.0),
                _buildTextField(
                  controller: signUpController.phoneNumberController,
                  label: 'Phone Number',
                  errorText: 'Please enter your phone number',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                const SizedBox(height: 15.0),
                _buildTextField(
                  controller: signUpController.newPasswordController,
                  label: 'New Password',
                  errorText: 'Please enter your new password',
                  isPassword: true,
                ),
                const SizedBox(height: 15.0),
                _buildTextField(
                  controller: signUpController.confirmPasswordController,
                  label: 'Confirm Password',
                  errorText: 'Passwords do not match',
                  isPassword: true,
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 97, 62, 234),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.all(16.0),
                  ),
                  onPressed: _saveProfile,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String errorText,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      obscureText: isPassword,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        if (label == 'Email' && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
          return 'Please enter a valid email address';
        }
        if (label == 'Phone Number' && !RegExp(r'^0?9\d{8}$').hasMatch(value)) {
          return 'Please enter a valid Syrian phone number';
        }
        if ((label == 'New Password' || label == 'Confirm Password') &&
            (value.length < 8 ||
                !RegExp(r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]')
                    .hasMatch(value))) {
          return 'Password must be at least 8 characters long and include both letters and numbers';
        }
        return null;
      },
      onSaved: (value) => controller.text = value ?? '',
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (signUpController.newPasswordController.text ==
          signUpController.confirmPasswordController.text) {
        signUpController.signUp(); 
        widget.onVerificationPressed();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match.')),
        );
      }
    }
  }
}
