import 'package:app_flutter/config_service.dart';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'coaches/coaches_page.dart';
import 'customers/customers_page.dart';
import 'tips/tips_page.dart';
import 'events/events_page.dart';
import 'astro_page.dart';
import 'navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Nécessaire pour charger dotenv avant runApp
  await ConfigService.loadConfig(); // Charger le fichier JSON
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Soul Connection',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    HomePage(),
    CoachesPage(),
    CustomersPage(),
    TipsPage(),
    EventsPage(),
    AstroPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}
