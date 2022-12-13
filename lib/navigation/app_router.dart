

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/models.dart';
import '../screens/login_screen.dart';

class AppRouter {

  final AppStateManager appStateManager;
  final ProfileManager profileManager;
  final GroceryManager groceryManager;

  AppRouter(
    this.appStateManager,
    this.profileManager,
    this.groceryManager,
  );

  late final router = GoRouter(
    debugLogDiagnostics: true,
    refreshListenable: appStateManager,
    initialLocation: '/login',
    routes: [
      GoRoute(
        name: 'login', // Nombre de la ruta
        path: '/login', // Dirección (URL) de la ruta
        builder: (context, state) => const LoginScreen(), // Página (pantalla) a mostrar
      ),
      // TODO: Add Onboarding Route
      // TODO: Add Home Route
    ],
    // Manejar error de rutas
    errorPageBuilder: (context, state) {
      return MaterialPage(
        key: state.pageKey,
        child: Scaffold(
          body: Center(
            child: Text(state.error.toString()),
          ),
        )
      );
    }
    // TODO: Add Redirect handler

  );

}