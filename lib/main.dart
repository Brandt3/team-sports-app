/* The purpose of this app is a team organization app that allows players
to login or sign up and they can see the next upcoming event, view the roster,
view the schedule, or see the completion of the season through the Pie chart.

 */

import 'package:flutter/material.dart';
import 'package:team_app_final_project/login.dart';
import './roster_screen.dart';
import './schedule_screen.dart';
import './home_screen.dart';
import './db_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Team App',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {

  //Bring the email over from the login so I can show it on the account screen
  final String email;
  const MainScreen({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Row (
                children: [
                  SizedBox(width: 38,),
                  Icon(Icons.bubble_chart, size: 40, color: Colors.white,),
                  SizedBox(width: 4,),
                  Text("Team App",
                    style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    ),
                 ),
                ]
            ),
            backgroundColor: Colors.blueAccent,
          ),
          //Links each dart file by calling the class in the other file
          body: const TabBarView(
              children: [
                Center(child: HomeScreen()),
                Center(child: ScheduleScreen()),
                Center(child: RosterScreen()),
              ]
          ),
          //Pass user email here from login
          drawer: NavigationDrawer(email: email),
          bottomNavigationBar: const Material(
            color: Colors.blueAccent,
            child: TabBar(
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  child: Text("Home", style: TextStyle(
                    fontSize: 20,
                  ),
                  ),
                ),
                Tab(
                  icon: Icon(Icons.calendar_month),
                  child: Text("Schedule", style: TextStyle(
                    fontSize: 20,
                  ),
                  ),
                ),
                Tab(
                  icon: Icon(Icons.people_alt),
                  child: Text("Roster", style: TextStyle(
                    fontSize: 20,
                  ),
                  ),
                ),
              ],
            ),
          ),
        )
    );
  }
}

class NavigationDrawer extends StatefulWidget {
  final String email;
  const NavigationDrawer({super.key, required this.email});

  @override
  State<NavigationDrawer> createState() => _NavigationDrawerState();
}

class _NavigationDrawerState extends State<NavigationDrawer> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  //late is used because the variable will be defined later
  late String first = '';
  late String last = '';
  late String mail = '';

  List<Map<String, dynamic>> playerMap = [];
  Future<void> playerGet() async {
    playerMap = await dbHelper.getAllPlayersInfo();
    for (var it in playerMap) {
      //widget.email is just another way of getting the variable email from the class
      if (it['email'] == widget.email) {
        first = it['fname'];
        last = it['lname'];
        mail = widget.email;
        break;
      }
    }
    setState(() {
    });
  }

  @override
  void initState() {
    super.initState();
    playerGet();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
              decoration: const BoxDecoration(
                  color: Colors.blue
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 30,
                    child: Icon(Icons.person, size: 40),
                  ),
                  const SizedBox(height: 10,),
                  Text(
                    '$first $last' ,
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    mail,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              )
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen(email: widget.email,))
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.pop(context);
              //Used this line below so that when the user logs out they can not hit the
              // back arrow and go back in the stack of routes
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
