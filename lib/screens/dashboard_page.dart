import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'my_bookings_page.dart'; 
import 'timetable_page.dart';
import 'new_booking_page.dart'; 

class DashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome!'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Center(
                child: Image.asset(
                  'lib/img/Nsbm logo.png',
                  width: 100,
                  height: 100,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Card(
                child: Column(
                  children: <Widget>[
                    ButtonBar(
                      alignment: MainAxisAlignment.start,
                      children: <Widget>[
                        ElevatedButton.icon(
                          icon: Icon(Icons.book_online),
                          label: Text('My Bookings'),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyBookingsPage())),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.schedule),
                          label: Text('Bus Timetable'),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TimetablePage())),
                        ),
                        ElevatedButton.icon(
                          icon: Icon(Icons.add_circle_outline),
                          label: Text('New Booking'),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NewBookingPage())),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('busDetails').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasData) {
                  final busData = snapshot.data!.docs;
                  final nextBus = busData.isNotEmpty ? busData.first : null;
                  if (nextBus != null) {
                    final nextBusData = nextBus.data() as Map<String, dynamic>;
                    return Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Card(
                        child: ListTile(
                          title: Text('Next Bus'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Time: ${nextBusData['startTime']}'),
                              Text('From: ${nextBusData['startLocation']}'),
                              Text('To: ${nextBusData['endLocation']}'),
                              Text('Seats Available: ${nextBusData['seatsAvailable']}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                }
                return SizedBox(); // Return an empty SizedBox if no data or error
              },
            ),
          ],
        ),
      ),
    );
  }
}
