import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/transaction_list_state.dart';
import '../viewmodels/transaction_list_view_model.dart';
import 'transaction_list_content.dart';

typedef TransactionListSectionBuilder =
    Widget Function(
      BuildContext context,
      TransactionListState state,
      Future<void> Function() onRefresh,
      Future<void> Function() onLoadMore,
    );

class TransactionListSection extends ConsumerWidget {
  const TransactionListSection({required this.contentBuilder, super.key});

  final TransactionListSectionBuilder contentBuilder;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionListViewModelProvider);
    final viewModel = ref.read(transactionListViewModelProvider.notifier);

    return TransactionListContent(
      state: state,
      onRetry: () {
        viewModel.refresh();
      },
      contentBuilder: (context) {
        return contentBuilder(
          context,
          state,
          viewModel.refresh,
          viewModel.loadMore,
        );
      },
    );
  }
}
