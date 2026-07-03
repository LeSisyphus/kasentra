import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Padding(padding: EdgeInsets.all(16), child: Text('Profil Usaha')),
    );
  }
}
