import 'package:flutter/material.dart';

AppBar baseAppBar(String title) {
  return AppBar(
    centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(
        color: Color.fromARGB(255, 255, 255, 255),
        fontWeight: FontWeight.w500,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    backgroundColor: const Color.fromARGB(255, 21, 56, 102),
    elevation: 0,
  );
}
