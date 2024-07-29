// ignore_for_file: file_names, library_private_types_in_public_api, unused_local_variable

import 'package:automender/BackendUrl.dart';
import 'package:automender/Controllers/TokenController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:automender/Controllers/ProfileController.dart';
import '../app_routes.dart';
import 'package:http/http.dart' as http;

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController profileController =
        Get.put(ProfileController(), permanent: true);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Text(
              'User Profile',
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
                Get.toNamed(AppRoutes.home);
              },
            ),
            actions: [
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.logout,
                  size: 30,
                ),
                label: const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                onPressed: () {
                  Future.delayed(Duration.zero, () async {
                    await logout();
                  });
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color.fromARGB(84, 21, 12, 54),
                  elevation: 0,
                ),
              ),
            ]),
        body: const UserProfileForm(),
      ),
    );
  }
}

class UserProfileForm extends StatefulWidget {
  const UserProfileForm({super.key});

  @override
  _UserProfileFormState createState() => _UserProfileFormState();
}

class _UserProfileFormState extends State<UserProfileForm> {
  final _formKey = GlobalKey<FormState>();
  final ProfileController profileController = Get.find<ProfileController>();

  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  String _newPassword = '';
  String _confirmPassword = '';

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: profileController.name.value);
    _phoneController =
        TextEditingController(text: profileController.phoneNum.value);
    _emailController =
        TextEditingController(text: profileController.email.value);

    ever(profileController.name, (name) => _nameController.text = name);
    ever(profileController.phoneNum,
        (phoneNum) => _phoneController.text = phoneNum);
    ever(profileController.email, (email) => _emailController.text = email);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const CircleAvatar(
              radius: 90.0,
              backgroundImage: AssetImage('images/avatar.png'),
            ),
            const SizedBox(height: 16.0),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onChanged: (value) {
                      profileController.name.value = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    readOnly: true, 
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _phoneController,
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    onChanged: (value) {
                      profileController.phoneNum.value = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'New Password'),
                    onChanged: (value) {
                      _newPassword = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    obscureText: true,
                    decoration:
                        const InputDecoration(labelText: 'Confirm Password'),
                    onChanged: (value) {
                      _confirmPassword = value;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please confirm your password';
                      } else if (value != _newPassword) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 96, 62, 234),
                        fixedSize: const Size(200, 50)),
                    onPressed: () {
                      _saveProfile();
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {

      if (_newPassword != _confirmPassword) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match.')),
        );
        return;
      }

      profileController.updateProfile(
        profileController.name.value,
        profileController.phoneNum.value,
        _newPassword,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile saved.')),
      );
    }
  }
}

Future<void> logout() async {
  final authController = Get.find<AuthController>();

  var url = Uri.parse('${GlobalConfig.backendUrl}/auth/logout');
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
  }
}
