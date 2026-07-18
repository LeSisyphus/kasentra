import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kasentra/features/transaction/presentation/state/transaction_list_state.dart';
import 'package:kasentra/features/transaction/presentation/widgets/transaction_list_content.dart';

void main() {
  group('TransactionListContent', () {
    testWidgets('shows loading indicator during initial loading', (
      tester,
    ) async {
      await tester.pumpWidget(
        _TestApp(
          child: TransactionListContent(
            state: TransactionListState(isInitialLoading: true),
            contentBuilder: (_) => const Text('Daftar transaksi'),
            onRetry: () {},
          ),
        ),
      );

      expect(find.byKey(const Key('transaction-list-loading')), findsOneWidget);
      expect(find.byKey(const Key('transaction-list-empty')), findsNothing);
      expect(find.byKey(const Key('transaction-list-error')), findsNothing);
      expect(find.text('Daftar transaksi'), findsNothing);
    });

    testWidgets('shows empty state when there are no transactions', (
      tester,
    ) async {
      await tester.pumpWidget(
        _TestApp(
          child: TransactionListContent(
            state: TransactionListState(),
            contentBuilder: (_) => const Text('Daftar transaksi'),
            onRetry: () {},
          ),
        ),
      );

      expect(find.byKey(const Key('transaction-list-empty')), findsOneWidget);
      expect(find.text('Belum ada transaksi'), findsOneWidget);
      expect(
        find.text('Transaksi yang dicatat akan muncul di sini.'),
        findsOneWidget,
      );
      expect(find.text('Daftar transaksi'), findsNothing);
    });

    testWidgets('shows initial error message', (tester) async {
      await tester.pumpWidget(
        _TestApp(
          child: TransactionListContent(
            state: TransactionListState(
              errorMessage: 'Gagal memuat transaksi. Coba lagi.',
            ),
            contentBuilder: (_) => const Text('Daftar transaksi'),
            onRetry: () {},
          ),
        ),
      );

      expect(find.byKey(const Key('transaction-list-error')), findsOneWidget);
      expect(find.text('Gagal memuat transaksi. Coba lagi.'), findsOneWidget);
      expect(find.text('Coba Lagi'), findsOneWidget);
      expect(find.text('Daftar transaksi'), findsNothing);
    });

    testWidgets('calls retry callback from the error state', (tester) async {
      var retryCount = 0;

      await tester.pumpWidget(
        _TestApp(
          child: TransactionListContent(
            state: TransactionListState(
              errorMessage: 'Gagal memuat transaksi. Coba lagi.',
            ),
            contentBuilder: (_) => const Text('Daftar transaksi'),
            onRetry: () {
              retryCount++;
            },
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('transaction-list-retry-button')));

      await tester.pump();

      expect(retryCount, 1);
    });

    testWidgets('does not build content for an empty state', (tester) async {
      var buildCount = 0;

      await tester.pumpWidget(
        _TestApp(
          child: TransactionListContent(
            state: TransactionListState(),
            contentBuilder: (_) {
              buildCount++;
              return const Text('Daftar transaksi');
            },
            onRetry: () {},
          ),
        ),
      );

      expect(buildCount, 0);
      expect(find.text('Daftar transaksi'), findsNothing);
    });
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Scaffold(body: child));
  }
}
