import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';


// Define a Booking model that matches the structure of your Firestore document
class Booking {
  final String busNumber;
  final Timestamp bookingTime; // Assuming bookingTime is stored as Timestamp
  final String bookingId;

  Booking({required this.busNumber, required this.bookingTime, required this.bookingId});

  factory Booking.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Booking(
      busNumber: data['busNumber'] ?? '',
      bookingTime: data['bookingTime'],
      bookingId: doc.id,
    );
  }
}

class MyBookingsPage extends StatefulWidget {
  @override
  _MyBookingsPageState createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  void _cancelBooking(String bookingId) {
    // Use Firestore to delete the booking
    FirebaseFirestore.instance.collection('bookings').doc(bookingId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Bookings'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bookings').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final bookingsList = snapshot.data!.docs.map((doc) => Booking.fromFirestore(doc)).toList();

          return ListView.builder(
            itemCount: bookingsList.length,
            itemBuilder: (context, index) {
              final booking = bookingsList[index];
              return Card(
                child: ListTile(
                  title: Text('${booking.busNumber} - ${DateFormat('hh:mm a').format(booking.bookingTime.toDate())}'), // Formatting Timestamp to readable time
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _cancelBooking(booking.bookingId),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
