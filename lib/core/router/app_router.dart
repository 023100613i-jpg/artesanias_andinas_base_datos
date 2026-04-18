import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/products/presentation/pages/product_list_page.dart';
import '../../features/products/presentation/pages/product_detail_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';

final appRouter = GoRouter(
  initialLocation: '/products',
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (_, __) => const ProductListPage(),
      routes: [
        GoRoute(
          path: ':id',
          name: 'product-detail',
          builder: (_, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
            return ProductDetailPage(productId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (_, __) => const FavoritesPage(),
    ),
  ],
  errorBuilder: (_, state) => Scaffold(
    appBar: AppBar(title: const Text('Página no encontrada')),
    body: Center(child: Text('Ruta no encontrada: ${state.uri}')),
  ),
);
