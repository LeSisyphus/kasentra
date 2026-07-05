import 'package:flutter/material.dart';

import 'package:kasentra/app/theme/kasentra_colors.dart';
import 'package:kasentra/app/theme/kasentra_spacing.dart';
import 'package:kasentra/features/product/presentation/screens/add_product_screen.dart';
import 'package:kasentra/features/product/presentation/screens/product_detail_screen.dart';
import 'package:kasentra/features/product/presentation/widgets/product_list_item.dart';
import 'package:kasentra/features/product/presentation/widgets/product_search_bar.dart';
import 'package:kasentra/features/product/presentation/widgets/product_stat_card.dart';
import 'package:kasentra/shared/widgets/kasentra_button.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(
                KasentraSpacing.screenPadding,
                KasentraSpacing.lg,
                KasentraSpacing.screenPadding,
                KasentraSpacing.xxl,
              ),
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Produk',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.notifications_none_rounded),
                      color: KasentraColors.textPrimary,
                    ),
                  ],
                ),
                const SizedBox(height: KasentraSpacing.xxl),
                const Row(
                  children: [
                    Expanded(
                      child: ProductStatCard(
                        title: 'Total\nProduk',
                        value: '42',
                        icon: Icons.inventory_2_outlined,
                      ),
                    ),
                    SizedBox(width: KasentraSpacing.lg),
                    Expanded(
                      child: ProductStatCard(
                        title: 'Hampir\nHabis',
                        value: '1',
                        icon: Icons.warning_amber_rounded,
                        isWarning: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: KasentraSpacing.xxl),
                const ProductSearchBar(),
                const SizedBox(height: KasentraSpacing.xxl),
                ProductListItem(
                  name: 'Beras Putih 5kg',
                  category: 'Sembako',
                  stock: 12,
                  price: 65000,
                  icon: Icons.inventory_2_outlined,
                  isLowStock: false,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProductDetailScreen(),
                      ),
                    );
                  },
                ),
                ProductListItem(
                  name: 'Minyak Goreng',
                  category: 'Sembako',
                  stock: 3,
                  price: 18000,
                  icon: Icons.water_drop_outlined,
                  isLowStock: true,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProductDetailScreen(),
                      ),
                    );
                  },
                ),
                ProductListItem(
                  name: 'Gula Pasir 1kg',
                  category: 'Sembako',
                  stock: 25,
                  price: 14500,
                  icon: Icons.cookie_outlined,
                  isLowStock: false,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const ProductDetailScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(
              KasentraSpacing.screenPadding,
              KasentraSpacing.md,
              KasentraSpacing.screenPadding,
              KasentraSpacing.lg,
            ),
            decoration: BoxDecoration(
              color: KasentraColors.background,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: KasentraButton(
              label: 'Tambah Produk',
              icon: Icons.add_rounded,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const AddProductScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
