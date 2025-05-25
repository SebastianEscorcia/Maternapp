import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/navigation_navbar_provider.dart';
import '../screens/familiar/InformacionMaterna/materna_info_screen.dart';
import '../screens/familiar/home_familiar_screen.dart';
import '../screens/familiar/profile/profile_familiar_screen.dart';
import '../widgets/home/navbar/botton_navbar_familiar.dart';


class MainScaffoldNavbarFamiliar extends StatelessWidget {
  const MainScaffoldNavbarFamiliar({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationNavbarProvider>(context);
    final currentIndex = navProvider.currentIndex;

    final screens = const [
      HomeFamiliarScreen(),
      MaternaInfoScreen(),
      NotificationsScreen(),
      ProfileFamiliarScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottonNavbarFamiliar(
        currentIndex: currentIndex,
        onTap: navProvider.setIndex,
      ),
    );
  }
}
