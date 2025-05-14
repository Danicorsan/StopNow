import 'package:flutter/material.dart';

AppBar baseAppBar(String title,
    {bool volver = false,
    BuildContext? context,
    Function()? onTap,
    List<Widget>? actions}) {
  return AppBar(
    centerTitle: true,
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
    ),
    flexibleSpace: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF153866), Color(0xFF608AAE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),
    elevation: 4,
    shadowColor: Colors.black.withOpacity(0.3),
    leading: volver
        ? IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              onTap != null ? onTap() : Navigator.pop(context!);
            },
          )
        : null,
    actions: actions ?? [],
  );
}
