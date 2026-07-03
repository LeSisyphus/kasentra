import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/app/app.dart';

void main() {
  testWidgets('Kasentra app renders home screen', (tester) async {
    await tester.pumpWidget(const KasentraApp());

    expect(find.text('Kasentra'), findsOneWidget);
    expect(find.text('Toko Berkah'), findsOneWidget);
  });
}
