import 'package:flutter/material.dart';

final MyData obj = MyData();

class Events {
  String title;
  String time;
  DateTime date;
  String location;
  Events(this.title, this.time, this.date, this.location);
}

class MyData {
  List<Events> events = [
    Events('Practice', '12:30 pm', DateTime.utc(2024, 11, 11), '701 Oak St Ave, Springfield, IL'),
    Events('Practice', '1:30 pm', DateTime.utc(2024, 11, 24), '701 Oak St Ave, Springfield, IL'),
    Events('Game', '2:00 pm', DateTime.utc(2024, 11, 25), '456 Park Ave, Springfield, IL'),
    Events('Game', '4:30 pm', DateTime.utc(2024, 12, 9), '789 River Rd, Springfield, IL'),
    Events('Practice', '5:00 pm', DateTime.utc(2024, 12, 11), '701 Oak St Ave, Springfield, IL'),
    Events('Practice', '5:00 pm', DateTime.utc(2024, 12, 12), '701 Oak St Ave, Springfield, IL'),
    Events('Practice', '5:00 pm', DateTime.utc(2024, 12, 13), '701 Oak St Ave, Springfield, IL'),
    Events('Practice', '5:00 pm', DateTime.utc(2024, 12, 14), '701 Oak St Ave, Springfield, IL'),
    Events('Practice', '5:00 pm', DateTime.utc(2025, 1, 2), '701 Oak St Ave, Springfield, IL'),
    Events('Game', '6:30 pm', DateTime.utc(2025, 1, 4), '606 Cedar St, Springfield, IL'),
    Events('Practice', '5:00 pm', DateTime.utc(2025, 1, 6), '701 Oak St Ave, Springfield, IL'),
    Events('Game', '6:30 pm', DateTime.utc(2025, 1, 8), '808 Willow St, Springfield, IL'),
    Events('Practice', '5:00 pm', DateTime.utc(2025, 1, 10), '701 Oak St Ave, Springfield, IL'),
    Events('Game', '6:30 pm', DateTime.utc(2025, 1, 12), '1001 Cherry St, Springfield, IL'),
    Events('Practice', '5:00 pm', DateTime.utc(2025, 1, 14), '701 Oak St Ave, Springfield, IL'),
    Events('Game', '6:30 pm', DateTime.utc(2025, 1, 16), '1201 Poplar St, Springfield, IL'),
    Events('Practice', '5:00 pm', DateTime.utc(2025, 1, 18), '701 Oak St Ave, Springfield, IL'),
    Events('Game', '6:30 pm', DateTime.utc(2025, 1, 20), '1401 Cypress St, Springfield, IL'),
    Events('Practice', '5:00 pm', DateTime.utc(2025, 1, 22), '701 Oak St Ave, Springfield, IL'),
    Events('Game', '6:30 pm', DateTime.utc(2025, 1, 24), '1601 Hickory St, Springfield, IL'),
    Events('Practice', '5:00 pm', DateTime.utc(2025, 1, 26), '701 Oak St Ave, Springfield, IL'),
    Events('Game', '6:30 pm', DateTime.utc(2025, 1, 28), '1801 Juniper St, Springfield, IL'),
    Events('Practice', '5:00 pm', DateTime.utc(2025, 1, 30), '701 Oak St Ave, Springfield, IL'),
  ];
}

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({super.key});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

bool isToday(DateTime date) {
  DateTime now = DateTime.now();
  return date.year == now.year && date.month == now.month && date.day == now.day;
}

bool isTomorrow(DateTime date) {
  DateTime now = DateTime.now().add(const Duration(days: 1));
  return date.year == now.year && date.month == now.month && date.day == now.day;
}

bool isThisMonth(DateTime date) {
  DateTime now = DateTime.now();
  return date.year == now.year && date.month == now.month;
}

bool isNextMonth(DateTime date) {
  DateTime now = DateTime.now();
  DateTime nextMonth = DateTime(now.year, now.month + 1);
  return date.year == nextMonth.year && date.month == nextMonth.month;
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  @override
  Widget build(BuildContext context) {
    //Following is a shortcut way of building a list using the dart where operator
    List<Events> todayItems = obj.events.where((e) => isToday(e.date))
        .toList();
    List<Events> tomorrowItems = obj.events.where((e) =>
        isTomorrow(e.date)).toList();
    List<Events> thisMonthItems = obj.events.where((e) =>
        isThisMonth(e.date)).toList();
    List<Events> nextMonthItems = obj.events.where((e) =>
        isNextMonth(e.date)).toList();

    return Scaffold(
      body: ListView(
        children: [
          //Performing checks to see what category each object falls under
          if (todayItems.isNotEmpty) CategorySection(
              "Today", todayItems),
          if (tomorrowItems.isNotEmpty) CategorySection(
              "Tomorrow", tomorrowItems),
          if (thisMonthItems.isNotEmpty) CategorySection(
              "This Month", thisMonthItems),
          if (nextMonthItems.isNotEmpty) CategorySection(
              "Next Month", nextMonthItems),
        ],
      ),
    );
  }
}

class CategorySection extends StatelessWidget {
//These must be final so the Category section can be const
  final String title;
  final List<Events> items;

  const CategorySection(this.title, this.items, {super.key});

//This function returns an icon based off of the title of the object
  Icon iconShow(String name) {
    if (name == "Practice") {
      return const Icon(Icons.sports_soccer);
    }
    else if (name == "Game") {
      return const Icon(Icons.sports);
    } else { return const Icon(Icons.delete_forever);}
    /*Need this line as a fall back line for the compiler in case
      none of the if statements match. This Icon won't ever actually
      be shown but the compiler wanted a default value

     */
  }

/*This widget builds the tiles that show each object
  and place them in the right category

 */
  @override
  Widget build(BuildContext context) {
    List<Widget> itemCards = [];
    for (var item in items) {
      itemCards.add(
          Card(
            elevation: 10,
            child: ListTile(
              leading: iconShow(item.title),
              title: Text('${item.title} - Time: ${item.time}'),
              subtitle: Text('Date: ${item.date.month}-${item.date.day}-${item.date.year}'),
            ),
          )
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        ...itemCards,
      ],
    );
  }
}
