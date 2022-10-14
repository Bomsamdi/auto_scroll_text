# AutoScrollText

[AutoScrollText] is package for users which need a single line text widget without overlaping or TextOverflow.elipsis for long texts.

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
