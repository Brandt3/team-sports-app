import 'package:flutter/material.dart';
import 'package:team_app_final_project/schedule_screen.dart';
import 'package:pie_chart/pie_chart.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, double> myGraph = {};
  Events? nextEvent;


/*This function takes data from the events class and checks to see if
  the date has happened to determine how much of the season is complete

 */
  void graphCheck() {
    DateTime now = DateTime.now();
    int completed = 0;
    int remain = 0;

    for (var exp in obj.events) {
      if (exp.date.isBefore(now)) {
        ++completed;
      } else {
        ++remain;
      }
    }
    int total = completed + remain;
    myGraph['Season Complete'] = (completed / total) * 100;
    myGraph['Time Left in the Season'] = (remain / total) * 100;
    setState(() {
    });
  }

  void closeDate() {
    //Found this code doing some research
    //What these lines do is create a list of the object organizing them by there dates in acceding order
    List<Events> sortedEvents = List.from(obj.events)
      ..sort((a, b) => a.date.compareTo(b.date));

  /*Once the objects are in order this will take the first item from the list
    that is equal to today or the next upcoming event and set that to the variable
    nextEvent which is used for the Next Event content

   */
    nextEvent = sortedEvents.isNotEmpty ? sortedEvents.firstWhere(
          (e) => e.date == (DateTime.now()) || e.date.isAfter(DateTime.now()),
    ) : null;
  }

  @override
//This calls functions that run before the app is up
  void initState() {
    super.initState();
    graphCheck();
    closeDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
      //Column must be in SingleChildScrollView to prevent a render overflow error
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Divider(
                color: Colors.blueAccent, // Line color
                thickness: 4, // Line thickness
                indent: 2, // Left spacing
                endIndent: 2, // Right spacing
              ),
              const SizedBox(height: 16),
              const Text("Upcoming Event",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)
              ),
              const SizedBox(height: 8),
              Card(
                //This line adds a shadow to the box to make it pop
                elevation: 10,
                child: ListTile(
                  leading: const Icon(Icons.event, color: Colors.blue,
                    size: 40,
                  ),
                  title: Text("${nextEvent?.title}",
                    style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                //Must include ? because there is a possibility of it being null but that would be after the season is over anyways
                  subtitle: Text("${nextEvent?.location} on ${nextEvent?.date.month}/${nextEvent?.date.day}/${nextEvent?.date.year}, ${nextEvent?.time}",
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueAccent, // Line color
                thickness: 4, // Line thickness
                indent: 2, // Left spacing
                endIndent: 2, // Right spacing
              ),
              const SizedBox(height: 16),
              const Text("Latest Announcements",
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black)
              ),
              const SizedBox(height: 8),
              const Card(
                //This line adds a shadow to the box to make it pop
                elevation: 10,
                child: ListTile(
                  leading: Icon(Icons.announcement, color: Colors.blue,
                    size: 40,
                  ),
                  title: Text("Practice Canceled",
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  subtitle: Text(
                    "Practice will be canceled one Dec 23rd due to weather",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(
                color: Colors.blueAccent, // Line color
                thickness: 4, // Line thickness
                indent: 2, // Left spacing
                endIndent: 2, // Right spacing
              ),
            //Graph that shows a completion of the season based on the dates
              PieChart(
                dataMap: myGraph,
                chartRadius: MediaQuery
                    .of(context)
                    .size
                    .width / 1.5,
                legendOptions: const LegendOptions(
                    legendPosition: LegendPosition.right
                ),
                chartValuesOptions: const ChartValuesOptions(
                    showChartValuesInPercentage: true
                ),
              )
          ]
        )
      ),
      )
    );
  }
}
