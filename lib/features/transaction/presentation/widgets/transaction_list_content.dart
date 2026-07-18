import 'package:flutter/material.dart';

import '../state/transaction_list_state.dart';

class TransactionListContent extends StatelessWidget {
  const TransactionListContent({
    required this.state,
    required this.contentBuilder,
    required this.onRetry,
    super.key,
  });

  final TransactionListState state;
  final WidgetBuilder contentBuilder;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.isInitialLoading) {
      return const Center(
        child: CircularProgressIndicator(key: Key('transaction-list-loading')),
      );
    }

    if (state.items.isEmpty && state.hasError) {
      return _TransactionListError(
        message: state.errorMessage!,
        onRetry: onRetry,
      );
    }

    if (state.items.isEmpty) {
      return const _TransactionListEmpty();
    }

    return contentBuilder(context);
  }
}

class _TransactionListError extends StatelessWidget {
  const _TransactionListError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('transaction-list-error'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 16),
            FilledButton(
              key: const Key('transaction-list-retry-button'),
              onPressed: onRetry,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionListEmpty extends StatelessWidget {
  const _TransactionListEmpty();

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('transaction-list-empty'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              'Belum ada transaksi',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              'Transaksi yang dicatat akan muncul di sini.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
