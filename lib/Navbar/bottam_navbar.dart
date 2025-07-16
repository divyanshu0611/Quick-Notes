import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:quick_notes/Views/Task/task_screen.dart';
import 'package:quick_notes/Views/calendar_page.dart';
import 'package:quick_notes/Views/home_page.dart';
import 'package:quick_notes/Views/profile_page.dart';

class BottomNavbar extends StatefulWidget {
  const BottomNavbar({super.key});

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();
}

class _BottomNavbarState extends State<BottomNavbar> {
  late int _selectedIndex;
  late final PageController _pageController;

  final List<Widget> _pages = const [
    HomePage(),
    TaskScreen(),
    CalendarPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();

    // ✅ Read index passed via Get.arguments
    _selectedIndex = Get.arguments?['tabIndex'] ?? 0;
    _pageController = PageController(initialPage: _selectedIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: PageView(
        controller: _pageController,
        physics:
            const NeverScrollableScrollPhysics(), // Prevent swipe to save performance
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
        },
        children: _pages,
      ),
      bottomNavigationBar: SafeArea(
        bottom: true,
        child: Container(
          margin: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
          decoration: BoxDecoration(
            color: Colors.grey.withAlpha(40),
            border: Border.all(width: 0.5, color: Colors.black),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: GNav(
              gap: 5,
              color: Colors.black,
              activeColor: Colors.white,
              tabBorderRadius: 12,
              tabBackgroundGradient: const LinearGradient(
                colors: [Color(0xff0093E9), Color(0xff80D0C7)],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                _pageController.jumpToPage(index);
                setState(() => _selectedIndex = index);
              },
              tabs: const [
                GButton(icon: Icons.home, text: 'Home'),
                GButton(icon: Icons.task_rounded, text: 'Task'),
                GButton(icon: Icons.calendar_month, text: 'Calendar'),
                GButton(icon: Icons.person, text: 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
