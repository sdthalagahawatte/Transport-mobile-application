import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:nsbm_bus/screens/login_page.dart';
import 'package:nsbm_bus/screens/dashboard_page.dart';
import 'package:nsbm_bus/screens/bus_details_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NSBM Bus Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/dashboard': (context) => DashboardPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/bus_details') {
          final args = settings.arguments as Map<String, dynamic>?;

          if (args != null && args.containsKey('busNumber')) {
            return MaterialPageRoute(
              builder: (context) => BusDetailsPage(busNumber: args['busNumber']),
            );
          }
        }
        return null;
      },
    );
  }
}
