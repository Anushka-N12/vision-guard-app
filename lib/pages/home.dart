import 'package:flutter/material.dart';
import 'package:visionguard/pages/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:visionguard/reusable_widgets/reusable_widget.dart';
import 'package:visionguard/pages/info.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _plateTextController = TextEditingController();
  TextEditingController _timeTextController = TextEditingController();
  TextEditingController _camTextController = TextEditingController();
  late Map<String, String> infoData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'), // Title for the AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.logout), // Logout button icon
            onPressed: () {
              // Handling logout
              FirebaseAuth.instance.signOut().then(
                (value) {
                  print("Signed Out");
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                },
              );
            },
          ),
        ],
      ),
      body: Container(
        color: Color(int.parse('FF1E2838', radix: 16)), // Set background color
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Automatically scan countless cameras across the city!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  reusableTextField(
                    'Enter License Plate Number',
                    Icons.search,
                    false,
                    _plateTextController,
                  ),
                  SizedBox(height: 20),
                  reusableTextField(
                    'Enter Last Seen Time',
                    Icons.access_time,
                    false,
                    _timeTextController,
                  ),
                  SizedBox(height: 20),
                  reusableTextField(
                    'Enter Last Seen Location (Camera ID)',
                    Icons.location_on_outlined,
                    false,
                    _camTextController,
                  ),
                  SizedBox(height: 20),
                  firebaseUIButton(
                    context,
                    'Submit',
                    () {
                      infoData = {
                        'plt': _plateTextController.text,
                        'time': _timeTextController.text,
                        'loc': _camTextController.text
                      };

                      // Navigate to the InfoPage and pass the info dictionary
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoPage(infoDict: infoData),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
