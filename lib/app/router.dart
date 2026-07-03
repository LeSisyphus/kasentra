import 'package:flutter/material.dart';

import '../features/debt/presentation/screens/debt_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/product/presentation/screens/product_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';
import '../features/transaction/presentation/screens/transaction_screen.dart';

class KasentraRoot extends StatefulWidget {
  const KasentraRoot({super.key});

  @override
  State<KasentraRoot> createState() => _KasentraRootState();
}

class _KasentraRootState extends State<KasentraRoot> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    TransactionScreen(),
    ProductScreen(),
    DebtScreen(),
    ProfileScreen(),
  ];

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
