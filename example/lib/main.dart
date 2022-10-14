import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/material.dart';

//  Created by Bomsamdi on 2022
//  Copyright © 2022 Bomsamdi. All rights reserved.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Auto Scroll Text',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Auto Scroll Text'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
                onPressed: _openHorizontal,
                child: const Text("Open HORIZONTAL example")),
            ElevatedButton(
                onPressed: _openVertical,
                child: const Text("Open VERTICAL example")),
          ],
        ),
      ),
    );
  }

  void _openHorizontal() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const HorizontalExample(),
    ));
  }

  void _openVertical() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const VerticalExample(),
    ));
  }
}

class HorizontalExample extends StatefulWidget {
  const HorizontalExample({Key? key}) : super(key: key);

  @override
  State<HorizontalExample> createState() => _HorizontalExampleState();
}

class _HorizontalExampleState extends State<HorizontalExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Horizontal Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const <Widget>[
            AutoScrollText(
              text:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              textStyle: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}

class VerticalExample extends StatefulWidget {
  const VerticalExample({Key? key}) : super(key: key);

  @override
  State<VerticalExample> createState() => _VerticalExampleState();
}

class _VerticalExampleState extends State<VerticalExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vertical Example"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const <Widget>[
            AutoScrollText(
              text:
                  "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              textStyle: TextStyle(fontSize: 24),
              scrollAxis: Axis.vertical,
            ),
          ],
        ),
      ),
    );
  }
}
