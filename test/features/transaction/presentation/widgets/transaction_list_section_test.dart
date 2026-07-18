import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/features/transaction/presentation/widgets/transaction_list_section.dart';

void main() {
  group('TransactionListSection', () {
    testWidgets('reads the initial provider state and shows the empty state', (
      tester,
    ) async {
      var contentBuildCount = 0;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: TransactionListSection(
                contentBuilder: (context, state, onRefresh, onLoadMore) {
                  contentBuildCount++;

                  return const Text('Daftar transaksi');
                },
              ),
            ),
          ),
        ),
      );

      expect(find.byKey(const Key('transaction-list-empty')), findsOneWidget);
      expect(find.text('Belum ada transaksi'), findsOneWidget);
      expect(find.text('Daftar transaksi'), findsNothing);
      expect(contentBuildCount, 0);
    });
  });
}
