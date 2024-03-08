import 'package:flutter/material.dart';
import 'package:visionguard/reusable_widgets/reusable_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:visionguard/pages/sign_in.dart';
import 'package:visionguard/pages/home.dart';
// import 'package:visionguard/controllers/info_controller.dart';
// import 'package:get/get.dart';

class InfoPage extends StatefulWidget {
  late Map<String, String> infoDict;
  InfoPage({Key? key, required this.infoDict}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  bool isLoading = true;
  // final InfoController controller = Get.put(InfoController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Info Page'), // Title for the AppBar
        actions: [
          IconButton(
            icon: Icon(Icons.home_rounded), // Logout button icon
            onPressed: () {
              // Handling logout
              print("Redirecting to Home");
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Home()));
            },
          ),
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
        decoration: BoxDecoration(
          color:
              Color(int.parse('FF1E2838', radix: 16)), // Set background color
        ),
        // child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Looking for plate: ${widget.infoDict['plt']}",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Last known time: ${widget.infoDict['time']}",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Last seen by camera ID: ${widget.infoDict['loc']}",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : SizedBox(height: 20),
                firebaseUIButton(
                  context,
                  'Continue Searching',
                  () {
                    //async?
                    setState(() => isLoading = true);
                    // Supposed to reach remote servers,
                    // do a round of searching,
                    // and display results below
                    // controller.addResult('result');

                    setState(() => isLoading = false);
                  },
                ),
                // Expanded(
                //   child: Obx(() => ListView.builder(
                //         itemCount: controller.itemCount.value,
                //         itemBuilder: ((context, index) {
                //           return ListTile(
                //             title: Text(controller.results.value[index]),
                //           );
                //         }),
                //       )),
                // )
              ],
            ),
          ),
        ),
        // ),
      ),
    );
  }
}
