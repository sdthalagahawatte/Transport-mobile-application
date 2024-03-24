import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusDetailsPage extends StatelessWidget {
  final String busNumber;

  BusDetailsPage({required this.busNumber});

  @override
  Widget build(BuildContext context) {
    // Debug: Print the busNumber to ensure it's passed correctly
    print("Fetching details for bus number: $busNumber");

    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('busDetails').doc(busNumber).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error: ${snapshot.error}");
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (!snapshot.hasData || snapshot.data!.data() == null) {
                // Debug: Indicate when no data is found
                print("No data found for bus number: $busNumber");
                return Center(child: Text("No bus details found for bus number: $busNumber"));
              } else {
                var busDetails = snapshot.data!.data() as Map<String, dynamic>;
                // Ensure the data structure matches what you expect
                print("Bus Details: $busDetails");
                return ListView(
                  padding: EdgeInsets.all(8),
                  children: <Widget>[
                    ListTile(
                      title: Text("Bus Number"),
                      subtitle: Text(busNumber),
                    ),
                    ListTile(
                      title: Text("From"),
                      subtitle: Text(busDetails['startLocation']),
                    ),
                    ListTile(
                      title: Text("To"),
                      subtitle: Text(busDetails['endLocation']),
                    ),
                    ListTile(
                      title: Text("Start Coordinates"),
                      subtitle: Text("Latitude: ${busDetails['startCoordinates'].latitude}, Longitude: ${busDetails['startCoordinates'].longitude}"),
                    ),
                    ListTile(
                      title: Text("End Coordinates"),
                      subtitle: Text("Latitude: ${busDetails['endCoordinates'].latitude}, Longitude: ${busDetails['endCoordinates'].longitude}"),
                    ),
                    // Add any other details you wish to display
                  ],
                );
              }
          }
        },
      ),
    );
  }
}
