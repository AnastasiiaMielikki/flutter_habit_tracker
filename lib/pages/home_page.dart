import 'package:flutter/material.dart';
import 'package:flutter_habit_tracker/components/month_summary.dart';
import 'package:flutter_habit_tracker/data/habit_database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../components/habit_tile.dart';
import '../components/my_fab.dart';
import '../components/my_alert_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

  @override
  void initState() {
    // if there is no data, create default one
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    } else {
      db.loadData();
    }

    db.updateDatabase();

    super.initState();
  }

  // checkbox was tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });

    db.updateDatabase();
  }

  // create new habit
  final _newHabitNameController = TextEditingController();
  void createNewHabit() {
    // show alert dialog for user to enter the new habit details
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: 'Enter Habit Name',
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  // save new habit
  void saveNewHabit() {
    // add new habit to the list
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });
    // clear text habit
    _newHabitNameController.clear();
    // pop dialog box
    Navigator.of(context).pop();

    db.updateDatabase();
  }

  // cancel new habit
  void cancelDialogBox() {
    // clear text habit
    _newHabitNameController.clear();
    // pop dialog box
    Navigator.of(context).pop();
  }

  // open habit settings to edit
  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
          hintText: db.todaysHabitList[index][0],
        );
      },
    );
  }

  // save existing habit

  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);

    db.updateDatabase();
  }

  // delete habit

  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });

    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        floatingActionButton: MyFloatingActionButton(
          onPressed: () => createNewHabit(),
        ),
        body: ListView(
          children: [
            // monthly summary heat map
            MonthlySummary(
                datasets: db.heatMapDataSet,
                startDate: _myBox.get("START_DATE")),

            // list of habits
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: db.todaysHabitList.length,
              itemBuilder: (context, index) {
                return HabitTile(
                  habitName: db.todaysHabitList[index][0],
                  habitComplete: db.todaysHabitList[index][1],
                  onChanged: (value) => checkBoxTapped(value, index),
                  deleteTaped: (context) => deleteHabit(index),
                  settingTaped: (context) => openHabitSettings(index),
                );
              },
            ),
          ],
        ));
  }
}
