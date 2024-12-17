import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomSnackBar(
    String message, {bool isError = true, String title = 'Error'}) {
  Get.snackbar(
    backgroundColor: Colors.red,
    title,
    message,
    titleText: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  );
}