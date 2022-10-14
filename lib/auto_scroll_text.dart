library auto_scroll_text;

//  Created by Bomsamdi on 2022
//  Copyright © 2022 Bomsamdi. All rights reserved.
import 'dart:async';

import 'package:flutter/material.dart';

/// AutoScrollText widget automatically scrolls provided [text]
///
/// ### Example:
///
/// ```dart
/// AutoScrollText(
///     "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
///     mode: AutoScrollTextMode.bouncing,
///     velocity: Velocity(pixelsPerSecond: Offset(150, 0)),
///     delayBefore: Duration(milliseconds: 500),
///     numberOfReps: 5,
///     pauseBetween: Duration(milliseconds: 50),
///     style: TextStyle(color: Colors.green),
///     textAlign: TextAlign.right,
///     selectable: true,
///     scrollDirection: Axis.horizontal,
///     curve: Curves.linear,
/// )
/// ```
class AutoScrollText extends StatefulWidget {
  const AutoScrollText(
    this.text, {
    Key? key,
    this.style,
    this.textAlign,
    this.textDirection = TextDirection.ltr,
    this.numberOfReps,
    this.delayBefore,
    this.pauseBetween,
    this.mode = AutoScrollTextMode.endless,
    this.velocity = const Velocity(pixelsPerSecond: Offset(80, 0)),
    this.selectable = false,
    this.intervalSpaces,
    this.scrollDirection = Axis.horizontal,
    this.curve = Curves.linear,
  }) : super(key: key);

  /// The text string, that would be scrolled.
  /// In case text does fit into allocated space, it wouldn't be scrolled
  /// and would be shown as is.
  ///
  /// ### Example:
  ///
  /// ```dart
  /// AutoScrollText('A sample text for AutoScrollText widget.')
  /// ```
  final String text;

  /// Provides [TextAlign] alignment if text string is not long enough to be scrolled.
  ///
  /// ### Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'Short text',
  ///   textAlign: TextAlign.right,
  /// )
  /// ```
  final TextAlign? textAlign;

  /// Provides [TextDirection] - a direction in which text flows.
  /// Default is [TextDirection.ltr].
  /// Default scrolling direction would be opposite to [textDirection],
  /// e.g. for [TextDirection.rtl] scrolling would be from left to right
  ///
  /// ### Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'This is a RTL text. This is a RTL text. This is a RTL text. This is a RTL text. ',
  ///   textDirection: TextDirection.rtl,
  /// )
  /// ```
  final TextDirection textDirection;

  /// Allows to apply custom [TextStyle] to [text].
  ///
  /// `null` by default.
  ///
  /// ### Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'Text with TextStyle',
  ///   style: TextStyle(
  ///     color: Colors.white,
  ///   ),
  /// )
  /// ```
  final TextStyle? style;

  /// Limits number of scroll animation rounds.
  ///
  /// Default is infinity.
  ///
  /// ### Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'Limit scroll rounds to 10',
  ///   numberOfReps: 10,
  /// )
  /// ```
  final int? numberOfReps;

  /// Delay before first animation round.
  ///
  /// Default is [Duration.zero].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'Start animation after 1 sec delay',
  ///   delayBefore: Duration(seconds: 1),
  /// )
  /// ```
  final Duration? delayBefore;

  /// Determines pause interval between animation rounds.
  ///
  /// Only allowed if [mode] is set to [AutoScrollTextMode.bouncing].
  ///
  /// Default is [Duration.zero].
  ///
  /// ### Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'Text with pause between animations',
  ///   mode: AutoScrollTextMode.bouncing,
  ///   pauseBetween: Duration(milliseconds: 300),
  /// )
  /// ```
  final Duration? pauseBetween;

  /// Sets one of two different types of scrolling behavior.
  /// [AutoScrollTextMode.endless] - default, scrolls text in one direction endlessly.
  /// [AutoScrollTextMode.bouncing] - when [text] string is scrolled to its end,
  /// starts animation to opposite direction.
  ///
  /// ### Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'Animate text string back and forth',
  ///   mode: AutoScrollTextMode.bouncing,
  /// )
  /// ```
  final AutoScrollTextMode mode;

  /// Allows to customize animation speed.
  ///
  /// Default is `Velocity(pixelsPerSecond: Offset(80, 0))`
  ///
  /// ### Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'Text with animation of 100px per second',
  ///   velocity: Velocity(pixelsPerSecond: Offset(100, 0)),
  /// )
  final Velocity velocity;

  /// Allows users to select provided [text], copy it to clipboard etc.
  ///
  /// Default is `false`.
  ///
  /// Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'This text is has possibility to select and copy it to clipboard',
  ///   selectable: true,
  /// )
  /// ```
  final bool selectable;

  /// Adds blank spaces between two nearby text sentences
  /// in case of [AutoScrollTextMode.endless]
  ///
  /// Default is `1`.
  ///
  /// Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'This is the sample text for AutoScrollText widget. ',
  ///   blankSpaces: 10,
  /// )
  /// ```
  final int? intervalSpaces;

  /// Allows users to define scrollDirection of [AutoScrollText]
  ///
  /// Default is [Axis.horizontal].
  ///
  /// Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'Text with vertical scroll direction',
  ///   scrollDirection: Axis.vertical,
  /// )
  /// ```
  final Axis scrollDirection;

  /// [Curve] of scroll animation
  /// Allows users to define [Curve] of animation for [AutoScrollText]
  ///
  /// Default is [Curves.linear].
  ///
  /// Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'Text with linear animation,
  ///   curve: Curves.linear,
  /// )
  /// ```
  final Curve curve;

  @override
  State<AutoScrollText> createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText> {
  final _scrollController = ScrollController();
  String _text = "";
  String? _endlessText;
  double? _originalTextWidth;
  Timer? _timer;
  bool _running = false;
  int _counter = 0;
  @override
  void initState() {
    super.initState();
    if (widget.scrollDirection == Axis.vertical) {
      String newString = widget.text.split("").join("\n");
      _text = newString;
    } else {
      _text = widget.text;
    }
    final WidgetsBinding binding = WidgetsBinding.instance;
    binding.addPostFrameCallback(_initScroll);
  }

  @override
  void didUpdateWidget(covariant AutoScrollText oldWidget) {
    _onUpdate(oldWidget);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    assert(
        widget.pauseBetween == null ||
            widget.mode == AutoScrollTextMode.bouncing,
        'pauseBetween is only available in AutoScrollTextMode.bouncing mode');
    assert(
        widget.intervalSpaces == null ||
            widget.mode == AutoScrollTextMode.endless,
        'intervalSpaces is only available in AutoScrollTextMode.endless mode');
    return Directionality(
      textDirection: widget.textDirection,
      child: Scrollbar(
        controller: _scrollController,
        thickness: 0,
        child: SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: widget.scrollDirection,
          child: widget.selectable
              ? SelectableText(
                  _endlessText ?? _text,
                  style: widget.style,
                  textAlign: widget.textAlign,
                )
              : Text(
                  _endlessText ?? _text,
                  style: widget.style,
                  textAlign: widget.textAlign,
                ),
        ),
      ),
    );
  }

  Future<void> _initScroll(_) async {
    await _delayBeforeStartAnimation();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      if (!_available) {
        timer.cancel();
        return;
      }
      final int? maxReps = widget.numberOfReps;
      if (maxReps != null && _counter >= maxReps) {
        timer.cancel();
        return;
      }
      if (!_running) _runAnimation();
    });
  }

  Future<void> _runAnimation() async {
    _running = true;
    final int? maxReps = widget.numberOfReps;
    if (maxReps == null || _counter < maxReps) {
      _counter++;
      switch (widget.mode) {
        case AutoScrollTextMode.bouncing:
          {
            await _animateBouncing();
            break;
          }
        default:
          {
            await _animateEndless();
          }
      }
    }
    _running = false;
  }

  Future<void> _animateEndless() async {
    if (!_available) return;
    final ScrollPosition position = _scrollController.position;
    final bool needsScrolling = position.maxScrollExtent > 0;
    if (!needsScrolling) {
      if (_endlessText != null) setState(() => _endlessText = null);
      return;
    }
    if (_endlessText == null || _originalTextWidth == null) {
      setState(() {
        _originalTextWidth =
            position.maxScrollExtent + position.viewportDimension;
        _endlessText = _text + _getSpaces(widget.intervalSpaces ?? 1) + _text;
      });
      return;
    }
    final double endlessTextWidth =
        position.maxScrollExtent + position.viewportDimension;
    final double singleRoundExtent = endlessTextWidth - _originalTextWidth!;
    final Duration duration = _getDuration(singleRoundExtent);
    if (duration == Duration.zero) return;
    if (!_available) return;
    await _scrollController.animateTo(
      singleRoundExtent,
      duration: duration,
      curve: widget.curve,
    );
    if (!_available) return;
    _scrollController.jumpTo(position.minScrollExtent);
  }

  Future<void> _animateBouncing() async {
    final double maxExtent = _scrollController.position.maxScrollExtent;
    final double minExtent = _scrollController.position.minScrollExtent;
    final double extent = maxExtent - minExtent;
    final Duration duration = _getDuration(extent);
    if (duration == Duration.zero) return;
    if (!_available) return;
    await _scrollController.animateTo(
      maxExtent,
      duration: duration,
      curve: widget.curve,
    );
    if (!_available) return;
    await _scrollController.animateTo(
      minExtent,
      duration: duration,
      curve: widget.curve,
    );
    if (!_available) return;
    if (widget.pauseBetween != null) {
      await Future<dynamic>.delayed(widget.pauseBetween!);
    }
  }

  Future<void> _delayBeforeStartAnimation() async {
    final Duration? delayBefore = widget.delayBefore;
    if (delayBefore == null) return;
    await Future<dynamic>.delayed(delayBefore);
  }

  Duration _getDuration(double extent) {
    final int milliseconds =
        (extent * 1000 / widget.velocity.pixelsPerSecond.dx).round();
    return Duration(milliseconds: milliseconds);
  }

  void _onUpdate(AutoScrollText oldWidget) {
    if (widget.text != oldWidget.text && _endlessText != null) {
      setState(() {
        _endlessText = null;
        _originalTextWidth = null;
        if (widget.scrollDirection == Axis.vertical) {
          String newString = widget.text.split("").join("\n");
          _text = newString;
        } else {
          _text = widget.text;
        }
      });
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
  }

  String _getSpaces(int number) {
    String spaces = '';
    for (int i = 0; i < number; i++) {
      spaces += '\u{00A0}';
    }
    return spaces;
  }

  bool get _available => mounted && _scrollController.hasClients;
}

/// Animation types for [AutoScrollText] widget.
/// [endless] - scrolls text in one direction endlessly.
/// [bouncing] - when text is scrolled to its end,
/// starts animation to opposite direction.
enum AutoScrollTextMode {
  bouncing,
  endless,
}
