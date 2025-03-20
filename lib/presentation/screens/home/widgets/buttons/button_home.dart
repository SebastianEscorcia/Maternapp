import 'package:flutter/material.dart';
import 'package:maternapp/Routes/routes.dart';

class ButtonHome extends StatelessWidget {
  const ButtonHome({super.key});
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.popUntil(context, ModalRoute.withName(Routes.homeScreen));
      },
      style: ElevatedButton.styleFrom(
        iconColor: Colors.pink[300],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Icon(Icons.home, size: 20),
      
    );
  }
}
