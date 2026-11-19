import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streaming_hub/main.dart';

void main() {
  testWidgets('Shows streaming service catalog', (tester) async {
    await tester.pumpWidget(const StreamingHub());
    expect(find.text('Streaming Hub'), findsOneWidget);
    expect(find.text('YouTube'), findsOneWidget);
    expect(find.text('TV4 Play'), findsOneWidget);
    expect(find.text('SVT Play'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
