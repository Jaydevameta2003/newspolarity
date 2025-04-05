import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String url="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            TextField(
              onChanged: (value){
                url = 'http://127.0.0.1:5000/api?Query='+value.toString();
              },
            )
          ],
        ),
      ),
    );
  }
}
