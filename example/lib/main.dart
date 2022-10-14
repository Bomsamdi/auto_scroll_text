import 'package:auto_scroll_text/auto_scroll_text_impl.dart';
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
            ElevatedButton(
                onPressed: _openBouncingHorizontal,
                child: const Text("Open BOUNCING HORIZONTAL example")),
            ElevatedButton(
                onPressed: _openBouncingVertical,
                child: const Text("Open BOUNCING VERTICAL example")),
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

  void _openBouncingHorizontal() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const BouncingHorizontalExample(),
    ));
  }

  void _openBouncingVertical() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const BouncingVerticalExample(),
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
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              style: TextStyle(fontSize: 24),
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
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              style: TextStyle(fontSize: 24),
              scrollDirection: Axis.vertical,
            ),
          ],
        ),
      ),
    );
  }
}

class BouncingHorizontalExample extends StatefulWidget {
  const BouncingHorizontalExample({Key? key}) : super(key: key);

  @override
  State<BouncingHorizontalExample> createState() =>
      _BouncingHorizontalExampleState();
}

class _BouncingHorizontalExampleState extends State<BouncingHorizontalExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bouncing Horizontal Example"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const <Widget>[
            AutoScrollText(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              style: TextStyle(fontSize: 24),
              mode: AutoScrollTextMode.bouncing,
            ),
          ],
        ),
      ),
    );
  }
}

class BouncingVerticalExample extends StatefulWidget {
  const BouncingVerticalExample({Key? key}) : super(key: key);

  @override
  State<BouncingVerticalExample> createState() =>
      _BouncingVerticalExampleState();
}

class _BouncingVerticalExampleState extends State<BouncingVerticalExample> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bouncing Vertical Example"),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const <Widget>[
            AutoScrollText(
              "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
              style: TextStyle(fontSize: 24),
              scrollDirection: Axis.vertical,
              mode: AutoScrollTextMode.bouncing,
            ),
          ],
        ),
      ),
    );
  }
}
