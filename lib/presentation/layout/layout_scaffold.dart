import 'package:flutter/material.dart';

class LayoutScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? bottomNav;
  final bool showBack;
  final bool centerContent;
  final Color? backgroudColor;
  const LayoutScaffold({
    this.backgroudColor,
    super.key,
    this.title = "",
    required this.child,
    this.bottomNav,
    this.showBack = false,
    this.centerContent = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: centerContent ? Center(child: child) : child,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: title.isNotEmpty
          ? AppBar(
              backgroundColor: const Color(0xFFFFF1F5),
              elevation: 0,
              automaticallyImplyLeading: showBack,
              iconTheme: const IconThemeData(color: Colors.pink),
              title: Text(
                title,
                style: const TextStyle(
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              centerTitle: true,
            )
          : null,
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: content,
        ),
      ),
      bottomNavigationBar: bottomNav != null
          ? Container(
              color: Colors.white,
              child: bottomNav,
            )
          : null,
    );
  }
}
