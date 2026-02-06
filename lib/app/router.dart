import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/series_list.dart';
import '../screens/gormita_list.dart';
import '../screens/profile.dart';
import '../screens/check_list.dart';
import '../screens/search_bar_screen.dart';
import '../screens/detail.dart';
import '../model/gormita.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SeriesList(),
    ),
    GoRoute(
      path: '/popoli',
      builder: (context, state) {
        final serieName = state.uri.queryParameters['serieName'] ?? '';
        final serieId =
            int.tryParse(state.uri.queryParameters['serieId'] ?? '0') ?? 0;
        return PopoliList(serieName: serieName, serieId: serieId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const Profile(),
    ),
    GoRoute(
      path: '/checklist',
      builder: (context, state) {
        final serieName = state.uri.queryParameters['serieName'];
        return CheckList(serieName: serieName);
      },
    ),
    GoRoute(
      path: '/search',
      builder: (context, state) {
        final query = state.uri.queryParameters['q'];
        return SearchBarScreen(initialQuery: query);
      },
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final gormita = state.extra as Gormita?;
        if (gormita == null) {
          return const Scaffold(
            body: Center(child: Text('Errore: Gormita non trovato')),
          );
        }
        return Detail(gormita: gormita);
      },
    ),
  ],
);
