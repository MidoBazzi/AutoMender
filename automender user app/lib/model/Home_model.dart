// ignore_for_file: file_names

import 'package:flutter/material.dart';

class PhotoWithText extends StatelessWidget {
  final String imagePath;
  final String buttonText;
  final VoidCallback? onPressed;

  const PhotoWithText({
    super.key,
    required this.imagePath,
    required this.buttonText,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    var cardColor = const Color.fromARGB(255, 226, 225, 225);
    var buttonColor = const Color.fromARGB(255, 96, 62, 234);
    var textColor = Colors.white;
    var borderRadius = BorderRadius.circular(12.0);

    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: borderRadius),
      ),
      child: Container(
        width: 380,
        height: 200,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Image.asset(
                  imagePath,
                  height: 135,
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: buttonColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(12.0),
                  bottomRight: Radius.circular(12.0),
                ),
              ),
              child: Text(
                buttonText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
