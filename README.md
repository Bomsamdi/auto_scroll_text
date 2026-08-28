# AutoScrollText

[![Pub](https://img.shields.io/pub/v/auto_scroll_text.svg)](https://pub.dev/packages/auto_scroll_text)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![pub points](https://img.shields.io/pub/points/auto_scroll_text)](https://pub.dev/packages/auto_scroll_text/score)
[![likes](https://img.shields.io/pub/likes/auto_scroll_text)](https://pub.dev/packages/auto_scroll_text/score)

`AutoScrollText` is a single line text widget that scrolls its content
automatically, so long texts stay readable instead of overlapping or being cut
off by `TextOverflow.ellipsis`.

## Installation

```yaml
dependencies:
  auto_scroll_text: ^1.0.0
```

Requires Dart 3.8 / Flutter 3.32 or newer.

## Features

https://user-images.githubusercontent.com/94292009/195745400-79f7c6ba-bd4c-47ff-bea6-ee1e4d8bf44c.mp4

- endless and bouncing scroll modes
- horizontal and vertical scroll direction
- configurable velocity, curve, delays and number of rounds
- selectable text
- optional `TextOverflow` once scrolling has stopped

## Usage

```dart
import 'package:auto_scroll_text/auto_scroll_text.dart';

AutoScrollText(
  "Lorem Ipsum is simply dummy text of the printing and typesetting industry.",
  style: TextStyle(fontSize: 24),
)
```

Bouncing mode, holding each end long enough to be read:

```dart
AutoScrollText(
  "A slightly too long text whose last word should stay readable",
  mode: AutoScrollTextMode.bouncing,
  pauseAtEnd: Duration(milliseconds: 500),
  pauseBetween: Duration(milliseconds: 300),
)
```

Scroll a few rounds, then settle for an ellipsis:

```dart
AutoScrollText(
  "Scroll three times, then cut the rest off",
  numberOfReps: 3,
  overflow: TextOverflow.ellipsis,
)
```

More in the `/example` folder.

## Parameters

| Parameter | Type | Default | Description |
|---|---|---|---|
| `text` | `String` | required | Text to scroll. Shown as is when it fits the available space. |
| `style` | `TextStyle?` | `null` | Style applied to the text. |
| `textAlign` | `TextAlign?` | `null` | Alignment used when the text is not long enough to scroll. |
| `textDirection` | `TextDirection` | `ltr` | Text flow direction; scrolling goes the opposite way. |
| `mode` | `AutoScrollTextMode` | `endless` | `endless` scrolls in one direction, `bouncing` goes back and forth. |
| `scrollDirection` | `Axis` | `horizontal` | In `vertical` the text is laid out one character per line. |
| `velocity` | `Velocity` | `80 px/s` | Scroll speed. |
| `curve` | `Curve` | `Curves.linear` | Animation curve. |
| `numberOfReps` | `int?` | `null` | Limits the number of rounds. Unlimited when `null`. |
| `delayBefore` | `Duration?` | `null` | Delay before the first round. |
| `pauseAtEnd` | `Duration?` | `null` | Bouncing only. Pause at the far end, before scrolling back. |
| `pauseBetween` | `Duration?` | `null` | Bouncing only. Pause after returning to the start, between rounds. |
| `intervalSpaces` | `int?` | `null` | Endless only. Blank spaces inserted between the repeated text. |
| `selectable` | `bool` | `false` | Renders a `SelectableText`, so the text can be copied. |
| `padding` | `EdgeInsets` | `EdgeInsets.zero` | Padding around the text. |
| `overflow` | `TextOverflow?` | `null` | Applied once scrolling has stopped. Requires `numberOfReps`. |

### Notes on `overflow`

While the text scrolls it lives inside a scroll view, where it is laid out
unconstrained and no overflow can occur. `overflow` therefore takes effect only
after the last of `numberOfReps` rounds: from that point the text is laid out
within the available space and the part that does not fit is treated according
to the given `TextOverflow`.

It requires `numberOfReps` (without it the animation never stops) and is not
supported together with `selectable: true`, because `SelectableText` has no
overflow parameter. Both cases are asserted.

## Additional information

`AutoScrollText` is a solution when you need a text widget for long texts
without overlapping or `TextOverflow.ellipsis`, in both `Axis.horizontal` and
`Axis.vertical`.

Issues and pull requests are welcome at
[github.com/Bomsamdi/auto_scroll_text](https://github.com/Bomsamdi/auto_scroll_text).
