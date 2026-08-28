## 1.0.0

* **Fix**: no timer outlives the widget any more. `delayBefore`, `pauseBetween`
  and the new `pauseAtEnd` are backed by cancellable timers instead of
  `Future.delayed`, which could not be cancelled and made widget tests fail with
  "A Timer is still pending even after the widget tree was disposed".
* **Fix**: the internal `ScrollController` is now disposed with the widget.
* **Fix**: changing `text` after `numberOfReps` rounds had been played restarts
  scrolling instead of leaving the widget frozen, and no longer throws when the
  scroll view has no clients yet.
* **New**: `pauseAtEnd` holds the text at its far end before scrolling back, so
  the last word of a slightly overflowing text stays readable in bouncing mode.
* **New**: `overflow` applies a `TextOverflow` once scrolling has stopped after
  the last of `numberOfReps` rounds.
* Parameter combinations that cannot work (`pauseAtEnd`/`pauseBetween` outside
  bouncing mode, `intervalSpaces` outside endless mode, `overflow` without
  `numberOfReps` or together with `selectable`) are now asserted in the
  constructor instead of during build.
* Requires Dart 3.8 / Flutter 3.32; `flutter_lints` 6, and the widget is covered
  by a widget test suite.
* Docs: the README usage example used a `textStyle` parameter that does not
  exist - it is `style`.

## 0.0.7

* Fix issue with updating short text

## 0.0.6

* Padding for non-scrollable text added

## 0.0.5

* Docs fix

## 0.0.4

* Minor changes

## 0.0.3

* Minor fixes

## 0.0.2

* Bouncing animation added

## 0.0.1

* Initial release.
