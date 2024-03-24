import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'bus_details_page.dart';

class TimetablePage extends StatefulWidget {
  @override
  _TimetablePageState createState() => _TimetablePageState();
}

class _TimetablePageState extends State<TimetablePage> {
  Stream<List<QueryDocumentSnapshot>> fetchBusSchedules() {
    return FirebaseFirestore.instance
        .collection('busDetails')
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Timetable'),
      ),
      body: StreamBuilder<List<QueryDocumentSnapshot>>(
        stream: fetchBusSchedules(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('No bus schedules found.'));
          }

          final busSchedules = snapshot.data!;
          return ListView.builder(
            itemCount: busSchedules.length,
            itemBuilder: (context, index) {
              final schedule = busSchedules[index].data() as Map<String, dynamic>;
              return ListTile(
                title: Text('${schedule['busNumber']} - ${schedule['startLocation']} to ${schedule['endLocation']}'),
                subtitle: Text('Start Time: ${schedule['startTime']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BusDetailsPage(busNumber: schedule['busNumber']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
