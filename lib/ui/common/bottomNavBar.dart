import 'package:flutter/material.dart';
import 'package:massigym_flutter/ui/home_screen.dart';
import 'package:massigym_flutter/ui/personal/personale_screen.dart';
import 'package:massigym_flutter/ui/common/workoutTabBar.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  PageController _pageController = PageController();
  List<Widget> _screens = [HomeScreen(), WorkoutTabBar(), PersonaleScreen()];

  int _selectedIndex = 0;

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.indigo,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.amber : Colors.white,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.fitness_center,
                color: _selectedIndex == 1 ? Colors.amber : Colors.white,
              ),
              label: "Workout",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.manage_accounts,
                color: _selectedIndex == 2 ? Colors.amber : Colors.white,
              ),
              label: "Personale",
            ),
          ],
        ));
  }
}
