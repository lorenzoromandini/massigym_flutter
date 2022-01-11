import 'package:flutter/material.dart';
import 'package:massigym_flutter/ui/statistics/likes_per_category.dart';
import 'package:massigym_flutter/ui/statistics/workouts_per_category.dart';

class StatisticsTabBar extends StatefulWidget {
  StatisticsTabBar({Key? key}) : super(key: key);

  @override
  _StatisticsTabBarState createState() => _StatisticsTabBarState();
}

class _StatisticsTabBarState extends State<StatisticsTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Widget> _screens = [WorkoutsPerCategory(), LikesPerCategory()];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Statistiche"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Workouts"),
            Tab(text: "Likes"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _screens,
      ),
    );
  }
}
