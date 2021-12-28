import 'package:flutter/material.dart';
import 'package:massigym_flutter/strings.dart';
import 'package:massigym_flutter/ui/workout/add_workout.dart';
import 'package:massigym_flutter/ui/workout/arms.dart';
import 'package:massigym_flutter/ui/workout/cardio.dart';
import 'package:massigym_flutter/ui/workout/legs.dart';

// barra di navigazione disposta nella parte superiore della schermata dei Workout che gestisce il passaggio
// tra le varie categorie degli allenamenti
class WorkoutTabBar extends StatefulWidget {
  WorkoutTabBar({Key? key}) : super(key: key);

  @override
  _WorkoutTabBarState createState() => _WorkoutTabBarState();
}

class _WorkoutTabBarState extends State<WorkoutTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Widget> _screens = [Cardio(), Legs(), Arms()];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
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
        title: Text("Workout"),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: Strings.cardioCategory),
            Tab(text: Strings.legsCategory),
            Tab(text: Strings.armsCategory),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add, size: 32),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddWorkout()),
          );
        },
      ),
    );
  }
}
