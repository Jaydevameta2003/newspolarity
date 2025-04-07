import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';

class LinkPage extends StatefulWidget {
  const LinkPage({super.key});

  @override
  State<LinkPage> createState() => _LinkPageState();
}

class _LinkPageState extends State<LinkPage> {
  TextEditingController urlController = TextEditingController();

  double score = 0.0;
  String sentiment = "";

  // Use your IP address instead of localhost
  final String urlApiBaseUrl = 'http://192.168.1.5:5001/news-sentiment';

  Future<void> fetchSentimentFromUrl(String articleUrl) async {
    final url = Uri.parse(urlApiBaseUrl);
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({'url': articleUrl}),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey("error")) {
          setState(() {
            sentiment = "Error: ${data["error"]}";
            score = 0.0;
          });
        } else {
          setState(() {
            sentiment = "Polarity: ${data["polarity"]}, Subjectivity: ${data["subjectivity"]}";
            score = (data["polarity"] + 1) / 2;
          });
        }
      } else {
        setState(() {
          sentiment = 'Error: ${response.statusCode}';
          score = 0.0;
        });
      }
    } catch (e) {
      setState(() {
        sentiment = 'Error: Could not connect to URL API';
        score = 0.0;
      });
    }
  }

  void clearInput() {
    setState(() {
      urlController.clear();
      sentiment = "";
      score = 0.0;
    });
  }

  Color getProgressColor(double value) {
    if (value < 0.5) return Colors.red;
    if (value == 0.5) return Colors.blue;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade100,
      appBar: AppBar(
        title: const Text("Link Sentiment Analyzer"),
        backgroundColor: Colors.deepPurple.shade200,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: urlController,
              decoration: const InputDecoration(
                hintText: "Paste news article URL...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => fetchSentimentFromUrl(urlController.text),
              icon: const Icon(Icons.link),
              label: const Text("Analyze URL"),
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: clearInput,
              icon: const Icon(Icons.clear),
              label: const Text("Clear"),
            ),
            const SizedBox(height: 30),
            CircularPercentIndicator(
              animation: true,
              animationDuration: 1000,
              radius: 120,
              lineWidth: 20,
              percent: score.clamp(0.0, 1.0),
              progressColor: getProgressColor(score),
              backgroundColor: Colors.deepPurple.shade200,
              circularStrokeCap: CircularStrokeCap.round,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${(score * 100).toStringAsFixed(0)}%",
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sentiment,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
