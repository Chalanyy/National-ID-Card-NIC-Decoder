import 'package:flutter/material.dart';
import 'nic_decoder.dart'; // Import NIC decoder screen

void main() {
  runApp(NICDecoderApp());
}

class NICDecoderApp extends StatelessWidget {
  const NICDecoderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'NIC Decoder', // App title
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 166, 89, 230), // Main color
        scaffoldBackgroundColor: Colors.grey[200], // Background color
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 166, 89, 230), // Button color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),// Rounded corners
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24), // Button padding
          ),
        ),
      ),
      home: NICInputScreen(),// Set home screen
    );
  }
}
