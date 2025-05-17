import 'package:flutter/material.dart';

class LayoutScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? bottomNav;
  final bool showBack;
  final bool centerContent;
  final bool useMaternalBackground;
  const LayoutScaffold({
    super.key,
    this.title = "",
    required this.child,
    this.bottomNav,
    this.showBack = false,
    this.centerContent = false,
    this.useMaternalBackground = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: centerContent ? Center(child: child) : child,
    );

    final Widget bodyContent = AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: SizedBox.expand(child: content),
    );

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      backgroundColor: useMaternalBackground
          ? const Color(0xFFFDF6F8) // tono cálido claro profesional
          : const Color(0xFFFFFFFF),
      appBar: title.isNotEmpty
          ? AppBar(
              backgroundColor: useMaternalBackground
                  ? const Color(0xFFFDF6F8) // tono cálido claro profesional
                  : const Color(0xFFFFFFFF),
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
      body: Stack(
        children: [
          if (useMaternalBackground)
            const _MaternalBackgroundLayer(), //Fondo maternal
          SafeArea(child: bodyContent),
        ],
      ),
      bottomNavigationBar: bottomNav != null
          ? Container(
              color: useMaternalBackground
                  ? const Color(0xFFFDF6F8)
                  : Colors.white,
              child: bottomNav,
            )
          : null,
    );
  }
}

class _MaternalBackgroundLayer extends StatelessWidget {
  const _MaternalBackgroundLayer();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: ColoredBox(
        color: Color(0xFFFDF6F8), // fondo profesional suave
      ),
    );
  }
}
