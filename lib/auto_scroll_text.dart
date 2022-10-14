library auto_scroll_text;

//  Created by Bomsamdi on 2022
//  Copyright © 2022 Bomsamdi. All rights reserved.
import 'dart:async';
import 'package:flutter/material.dart';
import 'after_layout_mixin.dart';

/// [AutoScrollText] is a solution when you need
/// text widget for long texts without overlaping or overflow.elipsis
/// [AutoScrollText] supports both directions [Axis.horizontal] and [Axis.vertical]
class AutoScrollText extends StatefulWidget {
  /// [Text.text] of [AutoScrollText]
  final String text;

  /// [TextStyle] of [Text]
  final TextStyle? textStyle;

  /// [SingleChildScrollView.scrollDirection] default value [Axis.horizontal]
  final Axis scrollDirection;

  /// [Curve] of scroll animation
  final Curve curve;

  /// Distance per tick
  final double moveDistance;

  /// Reset timer
  final int timerRest;

  const AutoScrollText({
    super.key,
    required this.text,
    this.textStyle,
    this.scrollDirection = Axis.horizontal,
    this.curve = Curves.linear,
    this.moveDistance = 1.0,
    this.timerRest = 100,
  });

  @override
  State<StatefulWidget> createState() {
    return AutoScrollTextState();
  }
}

class AutoScrollTextState extends State<AutoScrollText>
    with SingleTickerProviderStateMixin, AfterLayoutMixin {
  /// Final text for scrolling
  String textToScroll = "";

  /// SingleChildScrollView controller
  final ScrollController _scrollController = ScrollController();

  /// Actual position of scroll
  double position = 0.0;

  /// Repeatable timer
  Timer? timer;

  /// if text is to long for axis, define auto scroll action
  bool _isScrollable = false;

  /// SingleChildScrollView key
  final GlobalKey _scrollKey = GlobalKey();

  /// Default [TextStyle] if [widget.textStyle] is null
  TextStyle get defaultTextStyle => const TextStyle();

  @override
  void initState() {
    textToScroll = widget.text;
    super.initState();
  }

  /// Timer for animation
  void _startTimer() {
    if (_scrollKey.currentContext != null) {
      timer = Timer.periodic(Duration(milliseconds: widget.timerRest), (timer) {
        double maxScrollExtent = _scrollController.position.maxScrollExtent;
        double pixels = _scrollController.position.pixels;
        if (pixels + widget.moveDistance >= maxScrollExtent) {
          position = 0;
          _scrollController.jumpTo(position);
        }
        position += widget.moveDistance;
        _scrollController.animateTo(position,
            duration: Duration(milliseconds: widget.timerRest),
            curve: widget.curve);
      });
    }
  }

  /// Check if autoscroll animation is needed
  void _checkIsAutoScrollNeeded() {
    setState(() {
      _isScrollable = _scrollController.position.maxScrollExtent > 0;
    });
  }

  /// Text builder
  Widget _text() {
    if (widget.scrollDirection == Axis.vertical) {
      String newString = textToScroll.split("").join("\n");
      return Text(
        newString,
        style: widget.textStyle ?? defaultTextStyle,
        textAlign: TextAlign.center,
      );
    }
    return Text(
      textToScroll,
      style: widget.textStyle ?? defaultTextStyle,
      textAlign: TextAlign.justify,
    );
  }

  @override
  void dispose() {
    super.dispose();
    // dispose timer when needed
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: _scrollKey,
      scrollDirection: widget.scrollDirection,
      controller: _scrollController,
      physics: _isScrollable
          ? const AlwaysScrollableScrollPhysics()
          : const NeverScrollableScrollPhysics(),
      child: _text(),
    );
  }

  @override
  FutureOr<void> afterFirstLayout(BuildContext context) {
    _checkIsAutoScrollNeeded();
    if (_isScrollable) {
      setState(() {
        textToScroll = "     $textToScroll     ";
      });
      _startTimer();
    }
  }
}
