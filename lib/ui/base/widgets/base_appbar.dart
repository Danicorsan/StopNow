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
          color: Color.fromARGB(255, 255, 255, 255),
          fontWeight: FontWeight.w500,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      backgroundColor: const Color.fromARGB(255, 21, 56, 102),
      elevation: 0,
      leading: volver
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                onTap != null
                    ? onTap()
                    : Navigator.pop(context!); // Cierra el drawer
              },
            )
          : null,
      actions: [
        actions != null
            ? Row(
                children: actions,
              )
            : const SizedBox(),
      ]);
}
