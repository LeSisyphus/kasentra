import 'dart:async';

import 'package:flutter/material.dart';

import '../features/debt/presentation/screens/debt_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/product/presentation/screens/product_screen.dart';
import '../features/profile/domain/entities/business.dart';
import '../features/profile/presentation/screens/profile_form_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/transaction/presentation/screens/transaction_screen.dart';

class KasentraRoot extends StatefulWidget {
  const KasentraRoot({super.key});

  @override
  State<KasentraRoot> createState() {
    return _KasentraRootState();
  }
}

class _KasentraRootState extends State<KasentraRoot> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    _screens = [
      const HomeScreen(),
      const TransactionScreen(),
      const ProductScreen(),
      const DebtScreen(),
      ProfileScreen(onEditBusiness: _openProfileForm),
    ];
  }

  void _openProfileForm(Business? business) {
    unawaited(
      Navigator.of(context).push<bool>(
        MaterialPageRoute<bool>(
          builder: (_) {
            return ProfileFormScreen(initialBusiness: business);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Transaksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined),
            activeIcon: Icon(Icons.inventory_2),
            label: 'Produk',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined),
            activeIcon: Icon(Icons.account_balance_wallet),
            label: 'Utang',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
