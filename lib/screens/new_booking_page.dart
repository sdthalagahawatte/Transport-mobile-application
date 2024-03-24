import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewBookingPage extends StatefulWidget {
  @override
  _NewBookingPageState createState() => _NewBookingPageState();
}

class _NewBookingPageState extends State<NewBookingPage> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedBusTime;
  int? _selectedSeatCount;
  String? _userName;
  List<String> busTimes = [];

  @override
  void initState() {
    super.initState();
    _fetchBusTimes();
  }

  Future<void> _fetchBusTimes() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('busDetails').get();
      List<String> busNumbers = querySnapshot.docs.map((doc) => doc['busNumber'] as String).toList();
      setState(() {
        busTimes = busNumbers;
      });
    } catch (error) {
      print('Error fetching bus times: $error');
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection('bookings').add({
        'busNumber': _selectedBusTime,
        'bookingTime': Timestamp.now(),
        'seatsReserved': _selectedSeatCount,
        'name': _userName,
      }).then((_) {
        Navigator.pop(context);
      }).catchError((error) {
        print('Error adding booking: $error');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Booking'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                onChanged: (value) {
                  setState(() {
                    _userName = value;
                  });
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedBusTime,
                hint: Text('Select Bus'),
                onChanged: (newValue) {
                  setState(() {
                    _selectedBusTime = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a bus time' : null,
                items: busTimes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _selectedSeatCount,
                hint: Text('Select Seat Count'),
                onChanged: (newValue) {
                  setState(() {
                    _selectedSeatCount = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select the count of seats' : null,
                items: List.generate(5, (index) => index + 1).map<DropdownMenuItem<int>>((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: _submitBooking,
                child: Text('Confirm Booking'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
