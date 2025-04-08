import 'package:flutter/material.dart';

class LayoutScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? bottomNav;
  final bool showBack;
  final bool centerContent; // 👈 Nueva propiedad

  const LayoutScaffold({
    super.key,
    this.title = "",
    required this.child,
    this.bottomNav,
    this.showBack = false,
    this.centerContent = false, // 👈 Valor por defecto
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.all(20.0),
      child: centerContent
          ? Center(child: child) // 👈 Centrado vertical y horizontal
          : child,
    );

    return Scaffold(
      appBar: title.isNotEmpty
          ? AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              automaticallyImplyLeading: showBack,
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                ),
              ),
              centerTitle: true,
            )
          : null, // 👈 oculta AppBar si no hay título
      backgroundColor: Colors.white,
      body: SafeArea(child: content),
      bottomNavigationBar: bottomNav,
    );
  }
}
