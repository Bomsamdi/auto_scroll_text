import 'package:auto_scroll_text/auto_scroll_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const String _longText =
    'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
    'Lorem Ipsum has been the industry standard dummy text ever since the 1500s.';

/// Hosts [child] in a viewport narrow enough for [_longText] to overflow.
Widget _host(Widget child, {double width = 100}) => MaterialApp(
  home: Scaffold(
    body: Center(
      child: SizedBox(width: width, child: child),
    ),
  ),
);

ScrollController _controllerOf(WidgetTester tester) =>
    tester.widget<Scrollable>(find.byType(Scrollable).first).controller!;

void main() {
  group('rendering', () {
    testWidgets('shows the provided text', (WidgetTester tester) async {
      await tester.pumpWidget(_host(const AutoScrollText(_longText)));

      expect(find.text(_longText), findsOneWidget);
    });

    testWidgets('shows short text as is, without scrolling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_host(const AutoScrollText('Short')));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Short'), findsOneWidget);
      expect(_controllerOf(tester).position.maxScrollExtent, 0);
    });

    testWidgets('splits text per line in vertical scroll direction', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const AutoScrollText('abc', scrollDirection: Axis.vertical)),
      );

      expect(find.text('a\nb\nc'), findsOneWidget);
    });
  });

  // Regression tests for "A Timer is still pending even after the widget tree
  // was disposed". Every delay used to be a bare Future.delayed, which cannot
  // be cancelled; the test framework fails the test if any timer outlives the
  // widget tree, so disposing mid-delay is the whole assertion here.
  group('disposal', () {
    testWidgets('leaves no pending timer when disposed during delayBefore', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AutoScrollText(_longText, delayBefore: Duration(seconds: 10)),
        ),
      );

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('leaves no pending timer when disposed during pauseAtEnd', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AutoScrollText(
            _longText,
            mode: AutoScrollTextMode.bouncing,
            velocity: Velocity(pixelsPerSecond: Offset(10000, 0)),
            pauseAtEnd: Duration(seconds: 10),
          ),
        ),
      );
      // 50 ms starts a round, 1 s finishes the forward animation and enters
      // the pause.
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('leaves no pending timer when disposed during pauseBetween', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AutoScrollText(
            _longText,
            mode: AutoScrollTextMode.bouncing,
            velocity: Velocity(pixelsPerSecond: Offset(10000, 0)),
            pauseBetween: Duration(seconds: 10),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    });

    testWidgets('leaves no pending timer when disposed while scrolling', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(const AutoScrollText(_longText, delayBefore: Duration.zero)),
      );
      await tester.pump(const Duration(milliseconds: 50));

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pump(const Duration(seconds: 1));
    });
  });

  group('pauseAtEnd', () {
    testWidgets('holds the text at its far end before scrolling back', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AutoScrollText(
            _longText,
            mode: AutoScrollTextMode.bouncing,
            velocity: Velocity(pixelsPerSecond: Offset(10000, 0)),
            numberOfReps: 1,
            pauseAtEnd: Duration(seconds: 5),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      final ScrollController controller = _controllerOf(tester);
      expect(controller.position.maxScrollExtent, greaterThan(0));
      expect(controller.offset, controller.position.maxScrollExtent);

      // Still held one second later - the pause has not elapsed yet.
      await tester.pump(const Duration(seconds: 1));
      expect(controller.offset, controller.position.maxScrollExtent);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('without it the text is already back at the start', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AutoScrollText(
            _longText,
            mode: AutoScrollTextMode.bouncing,
            velocity: Velocity(pixelsPerSecond: Offset(10000, 0)),
            numberOfReps: 1,
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 50));
      // Forward animation, then a second frame budget for the way back - the
      // reverse animateTo only starts once the forward one has completed.
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      final ScrollController controller = _controllerOf(tester);
      expect(controller.offset, controller.position.minScrollExtent);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('is rejected outside bouncing mode', (
      WidgetTester tester,
    ) async {
      expect(
        () => AutoScrollText(_longText, pauseAtEnd: const Duration(seconds: 1)),
        throwsAssertionError,
      );
    });
  });

  group('overflow', () {
    testWidgets('lays the text out within the viewport once reps are done', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AutoScrollText(
            _longText,
            numberOfReps: 1,
            velocity: Velocity(pixelsPerSecond: Offset(10000, 0)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
      expect(find.byType(SingleChildScrollView), findsOneWidget);

      double maxOffsetSeen = 0;
      for (int i = 0; i < 16; i++) {
        await tester.pump(const Duration(milliseconds: 50));
        if (find.byType(Scrollable).evaluate().isNotEmpty) {
          maxOffsetSeen = maxOffsetSeen > _controllerOf(tester).offset
              ? maxOffsetSeen
              : _controllerOf(tester).offset;
        }
      }

      // The round really scrolled before the widget settled - in endless mode
      // the first pass only lays out the repeated text and must not count as
      // one of numberOfReps.
      expect(maxOffsetSeen, greaterThan(0));

      expect(find.byType(SingleChildScrollView), findsNothing);
      final Text text = tester.widget<Text>(find.byType(Text));
      expect(text.overflow, TextOverflow.ellipsis);
      expect(text.maxLines, 1);
      expect(text.softWrap, isFalse);
    });

    testWidgets('does not settle before the last round has finished', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AutoScrollText(
            _longText,
            // Default velocity, so a single round takes seconds.
            numberOfReps: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );

      // Used to collapse to the ellipsis after ~150 ms: the counter was read
      // right after being incremented, so the third tick ended the animation
      // that the second tick had just started.
      for (int i = 0; i < 6; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(_controllerOf(tester).offset, greaterThan(0));

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('new text resumes scrolling after the animation had stopped', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _host(
          const AutoScrollText(
            _longText,
            numberOfReps: 1,
            velocity: Velocity(pixelsPerSecond: Offset(10000, 0)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
      for (int i = 0; i < 16; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
      expect(find.byType(SingleChildScrollView), findsNothing);

      await tester.pumpWidget(
        _host(
          const AutoScrollText(
            'A different long text that also does not fit the viewport at all.',
            numberOfReps: 1,
            velocity: Velocity(pixelsPerSecond: Offset(10000, 0)),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(SingleChildScrollView), findsOneWidget);

      await tester.pumpWidget(const SizedBox.shrink());
    });

    testWidgets('is rejected without numberOfReps', (
      WidgetTester tester,
    ) async {
      expect(
        () => AutoScrollText(_longText, overflow: TextOverflow.ellipsis),
        throwsAssertionError,
      );
    });

    testWidgets('is rejected together with selectable', (
      WidgetTester tester,
    ) async {
      expect(
        () => AutoScrollText(
          _longText,
          numberOfReps: 1,
          selectable: true,
          overflow: TextOverflow.ellipsis,
        ),
        throwsAssertionError,
      );
    });
  });
}
