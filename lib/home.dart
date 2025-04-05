import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String sentiment = "";
  TextEditingController controller = TextEditingController();

  Future<void> fetchSentiment(String query) async {
    final url = Uri.parse('http://127.0.0.1:5000/api?Query=${Uri.encodeComponent(query)}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          sentiment = data['sentiment'];
        });
      } else {
        setState(() {
          sentiment = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        sentiment = 'Error: Could not connect to API';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("News Sentiment Analyzer")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Enter news headline...",
                border: OutlineInputBorder(),
              ),
              onSubmitted: fetchSentiment,
            ),
            const SizedBox(height: 20),
            Text(
              "Sentiment: $sentiment",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
