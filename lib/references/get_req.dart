import 'package:http/http.dart' as http;

class getReq {
  static Future<String> fetchData() async {
    var url = 'robotics2-production.up.railway.app';
    var response = await http.get(Uri.parse(url)); // Make HTTP GET request
    if (response.statusCode == 200) {
      return response.body; // Return the response body as a string
    } else {
      throw Exception('Failed to load data');
    }
  }
}
