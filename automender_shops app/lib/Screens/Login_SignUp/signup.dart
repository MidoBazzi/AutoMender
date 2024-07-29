// ignore_for_file: library_private_types_in_public_api, avoid_print, non_constant_identifier_names, unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:automender_shops/Controllers/Auth_Contollers/SignUpController.dart';

import 'package:automender_shops/model/place.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

import '../../app_routes.dart';
import 'package:http/http.dart' as http;

class SignUpScreen extends StatefulWidget {
  final VoidCallback onVerificationPressed;

  const SignUpScreen({super.key, required this.onVerificationPressed});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignUpController signUpController = Get.put(SignUpController());
  final ImagePicker _picker = ImagePicker();

  FileImage? _image;
  String? selectedOpeningTime;
  String? selectedClosingTime;
  final List<String> openingTimes = ['8', '9', '10', '11', '12'];
  final List<String> closingTimes = [
    '17',
    '18',
    '19',
    '20',
    '21',
    '22',
    '23',
    '24'
  ];

  List<String> daysOfWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  Map<String, bool> selectedDays = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  String? numberOfTeams;
  final List<String> teamNumbers = ['1', '2', '3', '4', '5'];

  String locationX = "";
  String locationY = "";

  Future<void> getImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (pickedFile != null) {
        _image = FileImage(File(pickedFile.path));
      } else {
        print('No image selected.');
      }
    });
  }

  void showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      getImage(ImageSource.gallery);
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    getImage(ImageSource.camera);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _showOpeningDaysDialog() async {
    showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Select Opening Days'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: daysOfWeek.map((day) {
                    return CheckboxListTile(
                      title: Text(day),
                      value: selectedDays[day],
                      onChanged: (bool? value) {
                        setState(() {
                          selectedDays[day] = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDropdown(String labelText, List<String> items, String? value,
      void Function(String?)? onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      value: value,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      validator: (value) => value == null ? 'Please select a $labelText' : null,
    );
  }

  bool _validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      if (_image == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add a shop image.')),
        );
        return false;
      }
      if (selectedDays.values.every((v) => !v)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please select at least one opening day')),
        );
        return false;
      }
      form.save();
      return true;
    }
    return false;
  }

  placelocation? _pickedlocation;
  var _isgettinglocation = false;

  /// هون مشان السناب شوت يعني بس بتاخد صورة صغيرة

  String get Locationimage {
    if (_pickedlocation == null) {
      return '';
    }
    /*هون منروح منجيب اللات واللنغ من البيكد لوكيشن */

    final lat = _pickedlocation!.latitude;
    final lng = _pickedlocation!.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyCW1q68HzQyTrKsu95fiX4Z3sq6q9D9Izc';
  }

  void _getcurrentlocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isgettinglocation = true;
    });

    locationData = await location.getLocation();
/* هون عم اتعامل مع الجيو كودينغ مشان تترجم اللونغ واللات عالخريطة*/
// those 2 variables is for assigning our location to that link and send it to the request*/
    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyCW1q68HzQyTrKsu95fiX4Z3sq6q9D9Izc');
// هون الريسبونس من الجيوكودينغمن الجيسون يلي بقلب الموقع */
    final Response = await http.get(url);
/*هون منفكك يلي الجيسون يلي واصلني من اللينك  */
    final resData = json.decode(Response.body);
    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedlocation =
          placelocation(latitude: lat, longitude: lng, address: address);
      _isgettinglocation = false;
      // Check if location is picked and assign latitude and longitude
      locationX = _pickedlocation != null
          ? _pickedlocation!.latitude.toString()
          : 'default_latitude';
      locationY = _pickedlocation != null
          ? _pickedlocation!.longitude.toString()
          : 'default_longitude';
    });

    print(locationData.latitude);
    print(locationData.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget PreviewContent = const Text('No location chosen');

    if (_pickedlocation != null) {
      PreviewContent = Image.network(Locationimage,
          fit: BoxFit.cover, width: double.infinity, height: double.infinity);
    }

    if (_isgettinglocation) {
      PreviewContent = const CircularProgressIndicator();
    }

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
                  'images/Logo-shops.png',
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
                const SizedBox(height: 10.0),
                const Divider(
                  color: Color.fromARGB(255, 96, 62, 234),
                  thickness: 10.0,
                ),
                const Column(
                  children: [
                    Text(
                      'Enter your shop information.',
                      style: TextStyle(
                        fontSize: 20.0, 
                        fontWeight:
                            FontWeight.bold, 
                        color: Color.fromARGB(
                            255, 0, 0, 0), 
                        letterSpacing: 1.2, 
                        wordSpacing: 2.0, 
                        fontStyle: FontStyle
                            .italic, 
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: signUpController.shop_namecontroller,
                  label: 'shop Name',
                  errorText: 'Please enter your shop name',
                ),
                const SizedBox(height: 10),
                _buildDropdown('Number of Teams', teamNumbers, numberOfTeams,
                    (String? newValue) {
                  setState(() {
                    numberOfTeams = newValue;
                  });
                }),
                const SizedBox(height: 10),
                _buildTextField(
                  controller: signUpController.locationcontroller,
                  label: 'location',
                  errorText: 'Please enter your location',
                ),
                const SizedBox(height: 10),
                _buildDropdown(
                    'Opening Time', openingTimes, selectedOpeningTime,
                    (String? newValue) {
                  setState(() {
                    selectedOpeningTime = newValue;
                  });
                }),
                const SizedBox(height: 10),
                _buildDropdown(
                    'Closing Time', closingTimes, selectedClosingTime,
                    (String? newValue) {
                  setState(() {
                    selectedClosingTime = newValue;
                  });
                }),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                      )),
                      child: PreviewContent,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton.icon(
                          icon: const Icon(Icons.location_on),
                          label: const Text('Get current location'),
                          onPressed: _getcurrentlocation,
                            style: TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 8)),
                        ),
                        TextButton.icon(
                          icon: const Icon(Icons.map),
                          label: const Text('select on map'),
                          onPressed: () {
                            navigateToMapAndGetLocation();
                          },
                           style: TextButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 8),
  ),
                        )
                      ],
                    )
                  ],
                ),
                const SizedBox(height: 20),
                _image != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(
                          _image!.file,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                        ),
                      ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () => showPicker(context),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    backgroundColor: const Color.fromARGB(255, 96, 62, 234),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                  child: const Text(
                    'Add picture',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _showOpeningDaysDialog,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    backgroundColor: const Color.fromARGB(255, 96, 62, 234),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text(
                    'Select Opening Days',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 20),
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

  Future<void> navigateToMapAndGetLocation() async {
    var result = await Get.toNamed(AppRoutes.show_on_map);
    if (result != null && result is Map<String, dynamic>) {
      setState(() {
        locationX = result['x'];
        locationY = result['y'];
      });
    }
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

  void _saveProfile() async {
    if (_validateAndSave()) {
      String schedule = selectedDays.keys
          .where((String key) => selectedDays[key]!)
          .join(', ');
      await signUpController.signUp(
        image: _image,
        selectedDays: selectedDays,
        openingTime: selectedOpeningTime!,
        closingTime: selectedClosingTime!,
        numberOfTeams: numberOfTeams!,
        locationX: locationX,
        locationY: locationY,
      );
    }
  }
}
