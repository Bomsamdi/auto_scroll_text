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
///     pauseAtEnd: Duration(milliseconds: 500),
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
    super.key,
    this.style,
    this.textAlign,
    this.textDirection = TextDirection.ltr,
    this.numberOfReps,
    this.delayBefore,
    this.pauseBetween,
    this.pauseAtEnd,
    this.mode = AutoScrollTextMode.endless,
    this.velocity = const Velocity(pixelsPerSecond: Offset(80, 0)),
    this.selectable = false,
    this.intervalSpaces,
    this.scrollDirection = Axis.horizontal,
    this.curve = Curves.linear,
    this.padding = EdgeInsets.zero,
    this.overflow,
  }) : assert(
         pauseBetween == null || mode == AutoScrollTextMode.bouncing,
         'pauseBetween is only available in AutoScrollTextMode.bouncing mode',
       ),
       assert(
         pauseAtEnd == null || mode == AutoScrollTextMode.bouncing,
         'pauseAtEnd is only available in AutoScrollTextMode.bouncing mode',
       ),
       assert(
         intervalSpaces == null || mode == AutoScrollTextMode.endless,
         'intervalSpaces is only available in AutoScrollTextMode.endless mode',
       ),
       assert(
         overflow == null || !selectable,
         'overflow is not supported when selectable is true, because '
         'SelectableText has no overflow parameter',
       ),
       assert(
         overflow == null || numberOfReps != null,
         'overflow is only applied once scrolling has stopped, so it requires '
         'numberOfReps to be set',
       );

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

  /// Determines pause interval between animation rounds, i.e. after the text
  /// has scrolled back to its starting position.
  ///
  /// Only allowed if [mode] is set to [AutoScrollTextMode.bouncing].
  ///
  /// Default is [Duration.zero].
  ///
  /// See also [pauseAtEnd], which pauses at the opposite edge.
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

  /// Determines how long the animation waits at the far end of the text,
  /// before scrolling back to the start.
  ///
  /// Useful for texts that only slightly overflow their viewport: the scroll
  /// extent is then short, so without a pause the last word bounces back
  /// before it can be read.
  ///
  /// Only allowed if [mode] is set to [AutoScrollTextMode.bouncing].
  ///
  /// Default is [Duration.zero], which keeps the pre-1.0.0 behaviour of
  /// turning back immediately.
  ///
  /// ### Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'A slightly too long text whose end should stay readable',
  ///   mode: AutoScrollTextMode.bouncing,
  ///   pauseAtEnd: Duration(milliseconds: 500),
  /// )
  /// ```
  final Duration? pauseAtEnd;

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

  /// [EdgeInsets] of padding for non-scrollable animation
  ///
  /// Default is [EdgeInsets.zero].
  ///
  /// Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'Text with linear animation,
  ///   padding: EdgeInsets.all(8),
  /// )
  /// ```
  final EdgeInsets padding;

  /// [TextOverflow] applied to the text once scrolling has stopped, i.e. after
  /// [numberOfReps] rounds have been played.
  ///
  /// While the text is scrolling it lives inside a scroll view and is therefore
  /// laid out unconstrained, where no overflow can occur. Once the animation
  /// stops, the text is laid out within the available space instead, and this
  /// value decides how the part that does not fit is treated.
  ///
  /// Requires [numberOfReps] to be set - without it the animation never stops.
  /// Not supported together with `selectable: true`, because [SelectableText]
  /// has no overflow parameter. Intended for [Axis.horizontal].
  ///
  /// `null` by default, which keeps the text scrollable after the last round.
  ///
  /// Example:
  ///
  /// ```dart
  /// AutoScrollText(
  ///   'Scroll three times, then cut the rest off with an ellipsis',
  ///   numberOfReps: 3,
  ///   overflow: TextOverflow.ellipsis,
  /// )
  /// ```
  final TextOverflow? overflow;

  @override
  State<AutoScrollText> createState() => _AutoScrollTextState();
}

class _AutoScrollTextState extends State<AutoScrollText> {
  final ScrollController _scrollController = ScrollController();
  String _text = "";
  String? _endlessText;
  double? _originalTextWidth;

  /// Drives the animation rounds.
  Timer? _timer;

  /// Tracks [AutoScrollText.delayBefore], [AutoScrollText.pauseAtEnd] and
  /// [AutoScrollText.pauseBetween] so that no timer outlives this state.
  /// A bare `Future.delayed` cannot be cancelled, which left a pending timer
  /// behind whenever the widget was disposed mid-delay.
  Timer? _delayTimer;
  Completer<void>? _delayCompleter;

  bool _running = false;
  bool _finished = false;
  int _counter = 0;

  /// What the last round did. A round that only prepared the repeated text, or
  /// that bailed out because the widget went away, must not count towards
  /// [AutoScrollText.numberOfReps].
  _RoundOutcome _lastOutcome = _RoundOutcome.skipped;

  @override
  void initState() {
    super.initState();
    _text = _resolveText(widget.text);
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
    _timer = null;
    _cancelPendingDelay();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_finished && widget.overflow != null) {
      return Directionality(
        textDirection: widget.textDirection,
        child: Padding(
          padding: widget.padding,
          child: Text(
            _text,
            style: widget.style,
            textAlign: widget.textAlign,
            overflow: widget.overflow,
            softWrap: false,
            maxLines: widget.scrollDirection == Axis.vertical ? null : 1,
          ),
        ),
      );
    }
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
              : Padding(
                  padding: widget.padding,
                  child: Text(
                    _endlessText ?? _text,
                    style: widget.style,
                    textAlign: widget.textAlign,
                  ),
                ),
        ),
      ),
    );
  }

  void _initScroll(Duration _) {
    final Duration? delayBefore = widget.delayBefore;
    if (delayBefore == null || delayBefore <= Duration.zero) {
      _startTimer();
      return;
    }
    _delayTimer = Timer(delayBefore, () {
      _delayTimer = null;
      if (!mounted) return;
      _startTimer();
    });
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (Timer timer) {
      if (!_available) {
        timer.cancel();
        return;
      }
      // A round in flight must be allowed to finish - checking the counter
      // here would stop the widget mid-animation.
      if (_running) return;
      if (_lastOutcome == _RoundOutcome.fits) {
        timer.cancel();
        _onAnimationFinished();
        return;
      }
      final int? maxReps = widget.numberOfReps;
      if (maxReps != null && _counter >= maxReps) {
        timer.cancel();
        _onAnimationFinished();
        return;
      }
      _runAnimation();
    });
  }

  /// Called once the last round of [AutoScrollText.numberOfReps] has been
  /// played. Only matters when [AutoScrollText.overflow] asked for the text to
  /// be laid out within the available space afterwards.
  void _onAnimationFinished() {
    if (!mounted || _finished || widget.overflow == null) return;
    setState(() => _finished = true);
  }

  Future<void> _runAnimation() async {
    _running = true;
    final _RoundOutcome outcome = switch (widget.mode) {
      AutoScrollTextMode.bouncing => await _animateBouncing(),
      AutoScrollTextMode.endless => await _animateEndless(),
    };
    if (outcome == _RoundOutcome.played) _counter++;
    _lastOutcome = outcome;
    _running = false;
  }

  Future<_RoundOutcome> _animateEndless() async {
    if (!_available) return _RoundOutcome.skipped;
    final ScrollPosition position = _scrollController.position;
    final bool needsScrolling = position.maxScrollExtent > 0;
    if (!needsScrolling) {
      if (_endlessText != null) setState(() => _endlessText = null);
      return _RoundOutcome.fits;
    }
    if (_endlessText == null || _originalTextWidth == null) {
      setState(() {
        _originalTextWidth =
            position.maxScrollExtent + position.viewportDimension;
        _endlessText = _text + _getSpaces(widget.intervalSpaces ?? 1) + _text;
      });
      // Only laid the repeated text out - the next round does the scrolling.
      return _RoundOutcome.skipped;
    }
    final double endlessTextWidth =
        position.maxScrollExtent + position.viewportDimension;
    final double singleRoundExtent = endlessTextWidth - _originalTextWidth!;
    final Duration duration = _getDuration(singleRoundExtent);
    if (duration == Duration.zero) return _RoundOutcome.fits;
    if (!_available) return _RoundOutcome.skipped;
    await _scrollController.animateTo(
      singleRoundExtent,
      duration: duration,
      curve: widget.curve,
    );
    if (!_available) return _RoundOutcome.skipped;
    _scrollController.jumpTo(position.minScrollExtent);
    return _RoundOutcome.played;
  }

  Future<_RoundOutcome> _animateBouncing() async {
    if (!_available) return _RoundOutcome.skipped;
    final double maxExtent = _scrollController.position.maxScrollExtent;
    final double minExtent = _scrollController.position.minScrollExtent;
    final double extent = maxExtent - minExtent;
    final Duration duration = _getDuration(extent);
    if (duration == Duration.zero) return _RoundOutcome.fits;
    if (!_available) return _RoundOutcome.skipped;
    await _scrollController.animateTo(
      maxExtent,
      duration: duration,
      curve: widget.curve,
    );
    if (!_available) return _RoundOutcome.skipped;
    final Duration? pauseAtEnd = widget.pauseAtEnd;
    if (pauseAtEnd != null && pauseAtEnd > Duration.zero) {
      await _delay(pauseAtEnd);
      if (!_available) return _RoundOutcome.skipped;
    }
    await _scrollController.animateTo(
      minExtent,
      duration: duration,
      curve: widget.curve,
    );
    if (!_available) return _RoundOutcome.skipped;
    final Duration? pauseBetween = widget.pauseBetween;
    if (pauseBetween != null && pauseBetween > Duration.zero) {
      await _delay(pauseBetween);
    }
    return _RoundOutcome.played;
  }

  /// A cancellable [Future.delayed]. The returned future also completes when
  /// this state is disposed, so callers resume and bail out on [_available]
  /// instead of leaving a pending timer behind.
  Future<void> _delay(Duration duration) {
    _cancelPendingDelay();
    final Completer<void> completer = Completer<void>();
    _delayCompleter = completer;
    _delayTimer = Timer(duration, () {
      _delayTimer = null;
      _delayCompleter = null;
      if (!completer.isCompleted) completer.complete();
    });
    return completer.future;
  }

  void _cancelPendingDelay() {
    _delayTimer?.cancel();
    _delayTimer = null;
    final Completer<void>? completer = _delayCompleter;
    _delayCompleter = null;
    if (completer != null && !completer.isCompleted) completer.complete();
  }

  Duration _getDuration(double extent) {
    final int milliseconds =
        (extent * 1000 / widget.velocity.pixelsPerSecond.dx).round();
    return Duration(milliseconds: milliseconds);
  }

  void _onUpdate(AutoScrollText oldWidget) {
    if (widget.text == oldWidget.text) return;
    setState(() {
      _endlessText = null;
      _originalTextWidth = null;
      _counter = 0;
      _finished = false;
      _lastOutcome = _RoundOutcome.skipped;
      _text = _resolveText(widget.text);
    });
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(_scrollController.position.minScrollExtent);
    }
    final Timer? timer = _timer;
    if (timer == null || !timer.isActive) {
      WidgetsBinding.instance.addPostFrameCallback((Duration _) {
        if (mounted) _startTimer();
      });
    }
  }

  /// In [Axis.vertical] the text is laid out one character per line.
  String _resolveText(String text) => widget.scrollDirection == Axis.vertical
      ? text.split("").join("\n")
      : text;

  String _getSpaces(int number) {
    String spaces = '';
    for (int i = 0; i < number; i++) {
      spaces += '\u{00A0}';
    }
    return spaces;
  }

  bool get _available => mounted && _scrollController.hasClients;
}

/// What a single animation round ended up doing.
enum _RoundOutcome {
  /// The text was actually scrolled - counts towards `numberOfReps`.
  played,

  /// Nothing was scrolled, but there is more to do: the endless text was just
  /// laid out, or the widget went away mid-round.
  skipped,

  /// The text fits the available space, so there is nothing left to scroll.
  fits,
}

/// Animation types for [AutoScrollText] widget.
/// [endless] - scrolls text in one direction endlessly.
/// [bouncing] - when text is scrolled to its end,
/// starts animation to opposite direction.
enum AutoScrollTextMode { bouncing, endless }
