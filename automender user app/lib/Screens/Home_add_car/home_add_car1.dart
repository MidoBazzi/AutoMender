// ignore_for_file: library_private_types_in_public_api, avoid_print, deprecated_member_use, empty_catches

import 'package:flutter/material.dart';
import 'package:automender/Controllers/Auth_Contollers/CarController.dart';
import 'package:get/get.dart';
import '../../app_routes.dart';

class CarInfoFormHome extends StatelessWidget {
  const CarInfoFormHome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Car Information',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 96, 62, 234),
          toolbarHeight: 100.0,
        ),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: CarInfoFormContent(),
          ),
        ),
      ),
    );
  }
}

class CarInfoFormContent extends StatefulWidget {
  const CarInfoFormContent({super.key});

  @override
  _CarInfoFormContentState createState() => _CarInfoFormContentState();
}

class _CarInfoFormContentState extends State<CarInfoFormContent> {
  final _formKey = GlobalKey<FormState>();
  final CarController _carController = CarController();

  final String userEmail = Get.arguments;

  String? selectedBrand;
  String? selectedBrandId;
  String? selectedModel;
  String? selectedCountry;
  String? selectedColor;
  String? selectedModelId; 
  Map<String, String> brands = {};
  List<String> models = [];
  Map<String, int> modelIdMap = {};
  Map<String, int> countryIdMap = {};
  bool _autoValidate = false;
  String? selectedGovernorate;
  final TextEditingController _plateNumberController = TextEditingController();
  final TextEditingController _currentMileageController =
      TextEditingController();
  final TextEditingController _lastOilChangeMileageController =
      TextEditingController();
  final List<String> syrianGovernorates = [
    'Damascus',
    'Aleppo',
    'Homs',
    'Latakia',
    'Hama',
    'Raqqa',
    'Idlib',
    'Deir ez-Zor',
    'Daraa',
    'Tartus',
    'Al-Hasakah',
    'Quneitra',
    'Al-Suwayda',
  ];

  @override
  void initState() {
    super.initState();
    _fetchBrands();
  }

  void _fetchBrands() async {
    try {
      final response = await _carController.getBrands();
      if (response['data'] != null && response['data']['brands'] != null) {
        var fetchedBrands = {
          for (var item in response['data']['brands'])
            item['name'] as String: item['id'].toString()
        };

        setState(() {
          brands = fetchedBrands;
        });
      }
    } catch (e) {
    }
  }

  void _fetchModels(int brandId) async {
    try {
      final response = await _carController.getModels(brandId);
      if (response['data'] != null && response['data']['models'] != null) {
        var fetchedModels = response['data']['models'];
        List<String> modelNames = [];
        Map<String, int> newModelIdMap = {};

        for (var model in fetchedModels) {
          String modelName = model['name'];
          int modelId = model['id'];
          modelNames.add(modelName);
          newModelIdMap[modelName] = modelId;
        }

        setState(() {
          models = modelNames;
          modelIdMap = newModelIdMap;
        });
      }
    } catch (e) {
    }
  }

  void _fetchCountry(int brandId) async {
    try {
      final response = await _carController.getCountry(brandId);
      if (response['data'] != null && response['data']['country'] != null) {
        setState(() {
          selectedCountry = response['data']['country']['name'];
          countryIdMap[selectedCountry!] = response['data']['country']['id'];
        });
      }
    } catch (e) {
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      print('Form validation passed');
      Map<String, dynamic> carData = {
        'brand_id': selectedBrandId.toString(),
        'model_id': selectedModelId, 
        'country_id': countryIdMap[selectedCountry]?.toString(),
        'color': selectedColor,
        'governorate': selectedGovernorate,
        'plate_number': _plateNumberController.text,
        'current_mileage': _currentMileageController.text,
        'next_oil_change_mileage': _lastOilChangeMileageController.text,
        'email': userEmail
      };

      print('Car data to be submitted: $carData');

      try {
        await _carController.addCar(carData);
        print('Car data submitted successfully');
        Get.offAllNamed(AppRoutes.home);
      } catch (e) {
        print('Error in submitting car data: $e');
      }
    } else {
      print('Form validation failed');
      setState(() => _autoValidate = true);
    }
  }

  Widget _buildTextFormField(String labelText, TextEditingController controller,
      String? Function(String?)? validator, TextInputType keyboardType) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
      keyboardType: keyboardType,
    );
  }

  Widget _buildDropdown(String labelText, String? value, List<String> items,
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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _onWillPop,
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset('images/Logo.png', height: 150),
              const Text(
                'Enter your car information',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 15),
              _buildDropdown('Brand', selectedBrand, brands.keys.toList(),
                  (String? newValue) async {
                setState(() {
                  selectedBrand = newValue;
                  selectedBrandId = brands[newValue];
                  selectedModel = null;
                  selectedCountry = null;
                });
                if (newValue != null) {
                  _fetchModels(int.parse(brands[newValue]!));
                  _fetchCountry(int.parse(brands[newValue]!));
                }
              }),
              const SizedBox(height: 10),
              _buildDropdown('Model', selectedModel, models,
                  (String? newValue) {
                setState(() {
                  selectedModel = newValue;
                  if (newValue != null && modelIdMap.containsKey(newValue)) {
                    selectedModelId = modelIdMap[newValue]
                        .toString(); 
                  }
                });
              }),
              const SizedBox(height: 10),
              _buildDropdown('Color', selectedColor, [
                'Red',
                'Blue',
                'Green',
                'Yellow',
                'Black',
                'White'
              ], (String? newValue) {
                setState(() {
                  selectedColor = newValue;
                });
              }),
              const SizedBox(height: 10),
              _buildDropdown(
                  'Governorate', selectedGovernorate, syrianGovernorates,
                  (String? newValue) {
                setState(() {
                  selectedGovernorate = newValue;
                });
              }),
              const SizedBox(height: 15),
              _buildTextFormField(
                'Plate Number',
                _plateNumberController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the plate number';
                  }
                  if (!RegExp(r'^\d{6}$').hasMatch(value)) {
                    return 'Plate number must be 6 digits';
                  }
                  return null;
                },
                TextInputType.number,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                'Current Mileage',
                _currentMileageController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the current mileage';
                  }
                  int? mileage = int.tryParse(value);
                  if (mileage == null || mileage < 0 || mileage > 999999) {
                    return 'Mileage must be between 0 and 999999';
                  }
                  return null;
                },
                TextInputType.number,
              ),
              const SizedBox(height: 15),
              _buildTextFormField(
                'Next Oil Change Mileage',
                _lastOilChangeMileageController,
                (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the next oil change mileage';
                  }
                  int? nextOilChangeMileage = int.tryParse(value);
                  int? currentMileage =
                      int.tryParse(_currentMileageController.text);
                  if (nextOilChangeMileage == null) {
                    return 'Invalid mileage';
                  }
                  if (currentMileage != null &&
                      (nextOilChangeMileage < currentMileage ||
                          nextOilChangeMileage > currentMileage + 5000)) {
                    return 'Mileage must be between current mileage and\ncurrent mileage + 5000';
                  }
                  return null;
                },
                TextInputType.number,
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 96, 62, 234),
                  fixedSize: const Size(350, 50),
                ),
                onPressed: _submitForm,
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }
}
