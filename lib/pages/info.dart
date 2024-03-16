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
  // static late Image? imageInfo;

  // void updateImage(Image? image) {
  //   setState(() {
  //     imageInfo = image;
  //   });
  // }

  Future<Map<String, dynamic>> fetchData() async {
    // var url = 'https://robotics2-production.up.railway.app';
    var url = 'http://127.0.0.1:5000/?';
    var params =
        '/plt=${widget.infoDict['plt']}&loc=${widget.infoDict['loc']}&time=${widget.infoDict['time']}&inc=${controller.itemCount.value}';
    var response =
        await http.get(Uri.parse(url + params)); // Make HTTP GET request
    if (response.statusCode == 200) {
      // Parse JSON array and extract object
      // var jsonArray = jsonDecode(response.body) as List;
      // var jsonObject = jsonArray.isNotEmpty ? jsonArray[0] : null;
      var jsonObject = jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonObject);
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
        child: ListView(
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
            Center(
              child: isLoading
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                        left: 8.0, // Adjust left padding as needed
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
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
                  // List<dynamic> myList = responseBody.values.toList();
                  controller.addResult(responseBody);
                  // print(responseBody);
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
            Text(
              'Result: ' + controller.itemCount.value.toString(),
              style: TextStyle(
                color: Color(int.parse('FF344663', radix: 16)),
              ),
            ),
            Container(
              child: controller.image != null
                  ? controller.image
                  : SizedBox.shrink(),
            ),
            Obx(
              () => controller.itemCount.value == 0
                  ? SizedBox.shrink()
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: controller.itemCount.value,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            controller.results.value[index],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
