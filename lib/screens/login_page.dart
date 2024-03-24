// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth for user authentication
import 'dashboard_page.dart'; // Import the DashboardPage for navigation

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TextEditingController for username and password fields
    TextEditingController usernameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    // Function for handling login button press
    void _login() async {
      String username = usernameController.text.trim();
      String password = passwordController.text.trim();

      try {
        // Sign in the user with email and password
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: username,
          password: password,
        );
        
        // If login successful, navigate to the dashboard page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
      } catch (e) {
        // Handle any login errors
        print('Login error: $e');
        // Show error message to the user
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Login Failed'),
              content: Text('Invalid username or password. Please try again.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  child: Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image at the top
            Image.asset(
              'lib/img/Nsbm logo.png', // Adjust the path as needed
              height: 100,
            ),
            SizedBox(height: 20), // Add spacing between the logo and input fields
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            Row(
              children: [
                Checkbox(value: false, onChanged: (newValue) {}),
                Text('Remember me'),
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF35C42C)),
              onPressed: _login, // Call the login function on button press
              child: Text('Login', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
