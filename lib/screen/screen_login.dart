import 'package:flutter/material.dart';

class Loginform extends StatelessWidget {
  const Loginform({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5), // Border color
                ),
                borderRadius:
                    BorderRadius.circular(10.0), // Rounded border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 3), // Offset for shadow
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Email', // Placeholder text for the email field
                  border: InputBorder.none, // No border for the text field
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20, // Horizontal padding
                    vertical: 14, // Vertical padding
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Space between text fields
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.5), // Border color
                ),
                borderRadius:
                    BorderRadius.circular(10.0), // Rounded border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2), // Shadow color
                    spreadRadius: 2, // Spread radius
                    blurRadius: 5, // Blur radius
                    offset: Offset(0, 3), // Offset for shadow
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  labelText:
                      'Password', // Placeholder text for the password field
                  border: InputBorder.none, // No border for the text field
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20, // Horizontal padding
                    vertical: 14, // Vertical padding
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Space between text fields
            ElevatedButton(
              onPressed: () {
                // Login logic
              },
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                elevation: 10, // Elevation (shadow)
                padding: EdgeInsets.symmetric(
                    horizontal: 40, vertical: 16), // Button padding
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(10), // Button border radius
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
