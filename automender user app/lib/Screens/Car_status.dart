// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:automender/Controllers/Auth_Contollers/CarController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_routes.dart';
import '../model/car_model.dart';
import 'dart:math' as math;

class CarStatus extends StatelessWidget {
  final Car2 selectedCar;

  const CarStatus({super.key, required this.selectedCar});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Car Status',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CarStatusScreen(selectedCar: selectedCar),
    );
  }
}

class CarStatusScreen extends StatefulWidget {
  final Car2 selectedCar;

  const CarStatusScreen({super.key, required this.selectedCar});

  @override
  _CarStatusScreenState createState() => _CarStatusScreenState();
}

class _CarStatusScreenState extends State<CarStatusScreen> {
  TextEditingController currentMileageController = TextEditingController();
  TextEditingController nextOilChangeMileageController =
      TextEditingController();
  TextEditingController plateNumberController = TextEditingController();
  String? selectedColor;
  String? selectedGovernorate;

  final List<String> colors = [
    'Red',
    'Blue',
    'Green',
    'Yellow',
    'Black',
    'White'
  ];
  final List<String> governorates = [
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

    selectedColor = widget.selectedCar.color;
    selectedGovernorate = widget.selectedCar.governorate;
    plateNumberController.text =
        widget.selectedCar.plateNum.toString();
    currentMileageController.text =
        widget.selectedCar.currMialage.toString(); 
    nextOilChangeMileageController.text =
        widget.selectedCar.nextMialage.toString();
  }

  @override
  Widget build(BuildContext context) {
    int nextOilChangeMileage = widget.selectedCar.nextMialage;
    int counterValue = 5000 -
        (nextOilChangeMileage -
            (int.tryParse(currentMileageController.text) ?? 0));

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Car Status',
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
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: Center(
                  child: OilConsumptionGauge(
                    maxValue: 5000,
                    currentValue: counterValue.toDouble(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildEditableField(
                controller: currentMileageController,
                label: 'Current Mileage',
                validator: _validateMileage,
              ),
              _buildEditableField(
                controller:
                    nextOilChangeMileageController, 
                label: 'Next Oil Change Mileage',
                validator:
                    _validateNextMileage,
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              _buildReadOnlyField(
                label: 'Brand',
                value: widget.selectedCar.brandName,
              ),
              _buildReadOnlyField(
                label: 'Model and Year',
                value: widget.selectedCar.carModelName,
              ),
              _buildDropdown('Color', selectedColor, colors,
                  (String? newValue) {
                setState(() {
                  selectedColor = newValue;
                });
              }),
              _buildDropdown('Governorate', selectedGovernorate, governorates,
                  (String? newValue) {
                setState(() {
                  selectedGovernorate = newValue;
                });
              }),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: TextFormField(
                  controller: plateNumberController,
                  decoration: const InputDecoration(
                    labelText: 'Plate Number',
                    border: OutlineInputBorder(),
                  ),
                  validator: _validatePlateNumber,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveCarInfo,
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 96, 62, 234),
                    fixedSize: const Size(350, 50)),
                child: const Text(
                  'Save Car Info',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.edit),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildReadOnlyField({required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        readOnly: true,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        initialValue: value,
      ),
    );
  }

  Widget _buildDropdown(String label, String? value, List<String> items,
      void Function(String?)? onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
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
        validator: (value) => value == null ? 'Please select a $label' : null,
      ),
    );
  }

  String? _validateMileage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the current mileage';
    }
    int? mileage = int.tryParse(value);
    if (mileage == null || mileage < 0 || mileage > 999999) {
      return 'Mileage must be between 0 and 999999';
    }
    return null;
  }

  String? _validateNextMileage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the next oil change mileage';
    }
    int? nextOilChangeMileage = int.tryParse(value);
    int? currentMileage = int.tryParse(currentMileageController.text);
    if (nextOilChangeMileage == null) {
      return 'Invalid mileage';
    }
    if (currentMileage != null &&
        (nextOilChangeMileage < currentMileage ||
            nextOilChangeMileage > currentMileage + 5000)) {
      return 'Mileage must be between current mileage and\ncurrent mileage + 5000';
    }
    return null;
  }

  String? _validatePlateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the plate number';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Plate number must be 6 digits';
    }
    return null;
  }

  void _saveCarInfo() async {
    if (!_validateForm()) {
      return;
    }

    final CarController carController =
        Get.find<CarController>();
    Map<String, dynamic> updatedCarData = {
      'curr_mialage': int.tryParse(currentMileageController.text) ??
          widget.selectedCar.currMialage,
      'next_mialage': int.tryParse(nextOilChangeMileageController.text) ??
          widget.selectedCar.nextMialage,
      'plate_num': int.tryParse(plateNumberController.text) ??
          widget.selectedCar.plateNum,
      'color': selectedColor ?? widget.selectedCar.color,
      'governorate': selectedGovernorate ?? widget.selectedCar.governorate,
      'car_id': widget.selectedCar.id,
    };

    try {
      await carController.editCar(updatedCarData);
      Get.snackbar(
        'Success',
        'Car information updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update car information: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  bool _validateForm() {
    return true; 
  }
}

class OilConsumptionGauge extends StatefulWidget {
  final double maxValue;
  final double currentValue;

  const OilConsumptionGauge(
      {super.key, required this.maxValue, required this.currentValue});

  @override
  _OilConsumptionGaugeState createState() => _OilConsumptionGaugeState();
}

class _OilConsumptionGaugeState extends State<OilConsumptionGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = Tween<double>(begin: 0, end: widget.currentValue).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    )..addListener(() {
        setState(() {});
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, 200),
      painter: GaugePainter(
        maxValue: widget.maxValue,
        value: _animation.value,
      ),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double maxValue;
  final double value;

  GaugePainter({required this.maxValue, required this.value});

  @override
  void paint(Canvas canvas, Size size) {
    Paint basePaint = Paint()
      ..color = Colors.grey.withAlpha(80)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    Paint progressPaint = Paint()
      ..color = value >= maxValue * 0.75
          ? Colors.red
          : (value >= maxValue * 0.5 ? Colors.orange : Colors.blue)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    double angle = 2 * math.pi / 2; 
    Offset center = Offset(size.width / 2, size.height);
    double radius = size.width / 2;

    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi,
        angle, false, basePaint);

    double progressAngle = angle * (value / maxValue);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), math.pi,
        progressAngle, false, progressPaint);

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: value.toStringAsFixed(0),
        style: TextStyle(
            fontSize: 16.0,
            color: progressPaint.color,
            fontWeight: FontWeight.bold),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas,
        Offset(center.dx - textPainter.width / 2, center.dy - radius - 30));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
