import 'package:flutter/material.dart';
import 'package:maternapp/Routes/routes.dart';

class StartedButtonWelcome extends StatelessWidget {
  const StartedButtonWelcome({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.pink,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: () {
        Navigator.pushReplacementNamed(context, Routes.questionScreen);
      },
      child: const Text("Comenzar"),
    );
  }
}