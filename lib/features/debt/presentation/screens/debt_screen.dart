import 'package:flutter/material.dart';

class DebtScreen extends StatelessWidget {
  const DebtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(padding: EdgeInsets.all(16), child: Text('Utang')),
    );
  }
}
