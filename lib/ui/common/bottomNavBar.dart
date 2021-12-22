import 'package:flutter/material.dart';
import 'package:massigym_flutter/ui/home_screen.dart';
import 'package:massigym_flutter/ui/personal/personale_screen.dart';
import 'package:massigym_flutter/ui/workout/workoutTabBar.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key? key}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  PageController _pageController = PageController();
  List<Widget> _screens = [MovieListScreen(), WorkoutTabBar(), PersonaleScreen()];

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
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? Colors.blue : Colors.grey,
              ),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.fitness_center,
                color: _selectedIndex == 1 ? Colors.blue : Colors.grey,
              ),
              label: "Workout",
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.manage_accounts,
                color: _selectedIndex == 2 ? Colors.blue : Colors.grey,
              ),
              label: "Personale",
            ),
          ],
        ));
  }
}
