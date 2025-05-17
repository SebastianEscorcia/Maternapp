import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/navigation_navbar_provider.dart';

//Screens
import '../screens/home/home_screens.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/tips/tips_screen.dart';
import '../screens/vitals/vitals_screen.dart';
import '../screens/calendar/calendar_screen.dart';
//button
import '../widgets/home/navbar/botton_navbar.dart';

class MainScaffoldNavbar extends StatelessWidget {
  const MainScaffoldNavbar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationNavbarProvider>(context);
    final currentIndex = navProvider.currentIndex;

    final screens = const [
      HomeScreens(),
      CalendarScreen(),
      TipsScreen(),
      ProfileScreen(),
      VitalsScreen(),
    ];
    
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottonNavbar(
        currentIndex: currentIndex,
        onTap: (index) => navProvider.setIndex(index),
      ),
    );
  }
}
