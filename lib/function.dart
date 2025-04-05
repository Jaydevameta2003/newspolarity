import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> getSentiment(String query) async {
  final url = Uri.parse('http://127.0.0.1:5000/api?Query=${Uri.encodeComponent(query)}');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['sentiment'];
  } else {
    throw Exception('Failed to fetch sentiment');
  }
}
