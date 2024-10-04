import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For parsing JSON

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HW1',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Jobs'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;
  List<dynamic> jobList = [];

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    final response = await http.get(Uri.parse('https://mpa0771a40ef48fcdfb7.free.beeceptor.com/jobs'));

    if (response.statusCode == 200) {
      setState(() {
        jobList = json.decode(response.body)['data'];
      });
    } else {
      throw Exception('Failed to load jobs');
    }
  }
  
  // List of widgets to display bottom nav bar
  static const List<Widget> _widgetOptions = <Widget>[
    Text('Job View'),
    Text('Resume View'),
    Text('Listing View'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 16.0),  
            child: IconButton(
              icon: const Icon(Icons.notifications_outlined),
              tooltip: 'Notifications',
              onPressed: () {
                // Notification functionality
              },
            ),
          ),
        ],
      ),

      body: Center(
        child: _selectedIndex == 0
            ? jobList.isEmpty
                ? const CircularProgressIndicator()  
                : ListView.builder(
                    itemCount: jobList.length,
                    itemBuilder: (context, index) {
                      // Each job is under 'job' key in the 'data' array
                      final job = jobList[index]['job'];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: Image.network(job['company']['logo']),
                          title: Text(job['title']),
                          subtitle: Column(
                            // property in Flutter's Column widget controls how its children (in this case, the Text widgets) are aligned horizontally within the column.
                            crossAxisAlignment: CrossAxisAlignment.start, // .start means all widgets aligned to the start (left in left-right align.)
                            children: [
                              Text(job['company']['name']),
                              Text(job['location']['name_en']),
                              Text(job['type']['name_en']),
                              Text("Posted on: ${job['created_date']}"),
                            ],
                          ),
                        ),
                      );
                    },
                  )
        : _widgetOptions.elementAt(_selectedIndex),
      ),

      bottomNavigationBar: BottomNavigationBar(

        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            label: 'Jobs',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Resume',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],

        currentIndex: _selectedIndex,
        selectedItemColor: Colors.deepPurple,
        onTap: _onItemTapped,

      ),
    );
    
  }

}

  

