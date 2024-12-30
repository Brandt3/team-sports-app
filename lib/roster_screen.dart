import 'package:flutter/material.dart';
import 'db_helper.dart';

class RosterScreen extends StatefulWidget {
  const RosterScreen({super.key});

  @override
  State<RosterScreen> createState() => _RosterScreenState();
}

class _RosterScreenState extends State<RosterScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> playerMap = [];

  Future<void> playerGet() async {
    playerMap = await dbHelper.getAllPlayersInfo();
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Player'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearch());
            },
          )
        ],
      ),
      body: ListView.builder(
          itemCount: playerMap.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("${playerMap[index]['fname']}'s Information"),
                        content: Text("Email: ${playerMap[index]['email']}"
                            "\nPhone number: ${playerMap[index]['phone']}"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                title: Text(
                    "${playerMap[index]['fname']} ${playerMap[index]['lname']}",
                  style: const TextStyle(fontSize: 18),
                ),
                leading: const CircleAvatar(
                  backgroundImage: NetworkImage(
                      "https://as1.ftcdn.net/v2/jpg/02/05/80/08/1000_F_205800828_rx4yT3MR78897625sUHLTOI2HJwjSEO9.jpg"),
                ),
              ),
            );
          }
      ),
    );
  }
}

//This creates the search application
class CustomSearch extends SearchDelegate {
  final DatabaseHelper dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> otherMap = [];

//This function creates a list that stores data from the SQL DB
//so I can easily access it when it's called
  Future<void> otherGet() async {
    otherMap = await dbHelper.getAllPlayersInfo();
  }
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {query = '';},
      )
    ];
  }

//This is creating the back arrow to get out of the search
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () { close(context, null); },
    );
  }

//This matches you search query with any data
  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = [];
    //Calling function to get access to SQL DB
    otherGet();
    for (var item in otherMap) {
      if (item['fname'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item['fname']);
      }

    }
//This returns the persons name and if you click the person it
//gives a pop up telling their info
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          final result = matchQuery[index];
          return ListTile(
            title: Text(result),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("${otherMap[index]['fname']}'s Information"),
                      content: Text("Email: ${otherMap[index]['email']}"
                          "\nPhone number: ${otherMap[index]['phone']}"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              }
          );
        }
    );
  }

//This matches you search query with any data
  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = [];
    //Calling the function to get access to the SQL DB
    otherGet();
    for (var item in otherMap) {
      if (item['fname'].toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(item['fname']);
      }
    }

    //This returns the persons name and if you click the person it
    //gives a pop up telling their info
    return ListView.builder(
        itemCount: matchQuery.length,
        itemBuilder: (context, index) {
          var result = matchQuery[index];
          return ListTile(
            title: Text(result),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("${otherMap[index]['fname']}'s Information"),
                      content: Text("Email: ${otherMap[index]['email']}"
                          "\nPhone number: ${otherMap[index]['phone']}"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close dialog
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    );
                  },
                );
              }
          );
        }
    );
  }
}
