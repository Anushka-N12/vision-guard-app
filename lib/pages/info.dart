import 'package:flutter/material.dart';
import 'package:visionguard/references/info_controller.dart';
import 'package:visionguard/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:visionguard/pages/sign_in.dart';
import 'package:get/get.dart';
// import 'package:visionguard/references/get_req.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InfoPage extends StatefulWidget {
  final Map<String, String> infoDict;

  const InfoPage({Key? key, required this.infoDict}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  late InfoController controller;
  bool isLoading = true;
  // final url = 'https://robotics2-production.up.railway.app/';

  static Future<Map<String, dynamic>> fetchData() async {
    var url = 'https://robotics2-production.up.railway.app';

    var response = await http.get(Uri.parse(url)); // Make HTTP GET request
    if (response.statusCode == 200) {
      // Parse JSON array and extract object
      var jsonArray = jsonDecode(response.body) as List;
      var jsonObject = jsonArray.isNotEmpty ? jsonArray[0] : null;
      return jsonObject; // Return the extracted object
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    controller = Get.put(InfoController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.home_rounded),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut().then(
                    (value) => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => SignIn())),
                  );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Color(int.parse('FF1E2838', radix: 16)),
        ),
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Looking for plate: ${widget.infoDict['plt']}",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Last known time: ${widget.infoDict['time']}",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Last seen by camera ID: ${widget.infoDict['loc']}",
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Padding(
                    padding: EdgeInsets.only(
                        left: 8.0), // Adjust left padding as needed
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white, // Color of the checkmark icon
                    ),
                  ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                // Perform async operation here
                fetchData().then((responseBody) {
                  List<dynamic> myList = responseBody.values.toList();
                  controller.addResult(myList);
                  print(responseBody);
                  // Use the response body as needed
                }).catchError((error) {
                  print('Error: $error');
                });

                setState(() {
                  isLoading = false;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              ),
              child: Text('Continue Searching',
                  style: TextStyle(
                    color: Color(int.parse('FF1E2838', radix: 16)),
                  )),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.itemCount.value,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        controller.results.value[index],
                        style: TextStyle(
                          color: Colors.white, // Set text color to white
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
