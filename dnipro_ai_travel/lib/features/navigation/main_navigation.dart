import 'package:flutter/material.dart';

import '../../../core/design_system/widgets/app_bottom_dock.dart';
import '../companion/presentation/screens/companion_screen.dart';
import '../explore/presentation/screens/explore_screen.dart';
import '../passport/presentation/screens/passport_screen.dart';
import '../places/presentation/screens/places_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int selectedIndex = 0;

  final screens = const [
    PlacesScreen(),
    ExploreScreen(),
    CompanionScreen(),
    PassportScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: screens[selectedIndex],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: AppBottomDock(
              selectedIndex: selectedIndex,
              onChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}