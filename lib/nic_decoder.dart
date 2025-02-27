import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NICInputScreen extends StatefulWidget {
  const NICInputScreen({super.key});

  @override
  _NICInputScreenState createState() => _NICInputScreenState();
}

class _NICInputScreenState extends State<NICInputScreen> {
  final TextEditingController _controller = TextEditingController();

  void _decodeNIC() {
    String nic = _controller.text.trim();
    Map<String, dynamic>? details = decodeNIC(nic);

    if (details != null) {  
      // If NIC is valid, go to result screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => NICResultScreen(details: details),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid NIC format! Please check again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NIC Decoder'), // Title of the app
        backgroundColor: Color.fromARGB(255, 166, 89, 230), // Set app bar color
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Center items in the column
          children: [
            Text(
              "Enter your Sri Lankan NIC",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Bold title
            ),
            SizedBox(height: 15),// Space between elements
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'NIC Number',
                border: OutlineInputBorder(), // Add a border around text field
                prefixIcon: Icon(Icons.badge, color: Color.fromARGB(255, 166, 89, 230)), 
              ),
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _decodeNIC,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color.fromARGB(255, 166, 89, 230), 
              ),
              child: Text('Decode', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class NICResultScreen extends StatelessWidget {
  final Map<String, dynamic> details;

  const NICResultScreen({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('NIC Details'),
        backgroundColor: Color.fromARGB(255, 166, 89, 230), 
      ),
      body: Center(
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "NIC Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Divider(),
                buildDetailRow("Date of Birth", details['dob']),
                buildDetailRow("Day of the Week", details['weekday']),
                buildDetailRow("Age", details['age'].toString()),
                buildDetailRow("Gender", details['gender']),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context), // Go back
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Color.fromARGB(255, 166, 89, 230), 
                  ),
                  child: Text('Back', style: TextStyle(fontSize: 16, color: Colors.white)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

Map<String, dynamic>? decodeNIC(String nic) {
  int birthYear;
  int dayOfYear;
  String gender;

  if (RegExp(r'^\d{9}[VXvx]$').hasMatch(nic)) {
    birthYear = 1900 + int.parse(nic.substring(0, 2));
    dayOfYear = int.parse(nic.substring(2, 5));
  } else if (RegExp(r'^\d{12}$').hasMatch(nic)) {
    birthYear = int.parse(nic.substring(0, 4));
    dayOfYear = int.parse(nic.substring(4, 7));
  } else {
    return null; // Invalid NIC
  }
// If day > 500, person is female
  if (dayOfYear > 500) {
    dayOfYear -= 500;
    gender = "Female";
  } else {
    gender = "Male";
  }
// Calculate date of birth
  DateTime dob = DateTime(birthYear, 1, 1).add(Duration(days: dayOfYear - 1));
  String weekday = DateFormat('EEEE').format(dob);
  int age = DateTime.now().year - birthYear;

  return {
    "dob": DateFormat('yyyy-MM-dd').format(dob),
    "weekday": weekday,
    "age": age,
    "gender": gender,
  };
}
