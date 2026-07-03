import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/kasentra_theme.dart';

class KasentraApp extends StatelessWidget {
  const KasentraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasentra',
      debugShowCheckedModeBanner: false,
      theme: KasentraTheme.lightTheme,
      home: const KasentraRoot(),
    );
  }
}
