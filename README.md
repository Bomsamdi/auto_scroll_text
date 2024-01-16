# AutoScrollText

[![Pub](https://img.shields.io/pub/v/auto_scroll_text.svg)](https://pub.dev/packages/auto_scroll_text)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![pub points](https://img.shields.io/pub/points/auto_scroll_text)](https://pub.dev/packages/auto_scroll_text/score) 
[![popularity](https://img.shields.io/pub/popularity/auto_scroll_text)](https://pub.dev/packages/auto_scroll_text/score)

[AutoScrollText] is package for users which need a single line text widget without overlaping or TextOverflow.elipsis for long texts.

## Installation

Include your package in your `pubspec.yaml` file:

```yaml
dependencies:
  auto_scroll_text: ^0.0.6
```

## Features

https://user-images.githubusercontent.com/94292009/195745400-79f7c6ba-bd4c-47ff-bea6-ee1e4d8bf44c.mp4

## Usage

```dart
import 'package:auto_scroll_text/auto_scroll_text.dart';

Scaffold(
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
              textStyle: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
```

Example usage in `/example` folder.

## Additional information

[AutoScrollText] is a solution when you need
text widget for long texts without overlaping or overflow.elipsis
[AutoScrollText] supports both directions [Axis.horizontal] and [Axis.vertical]
