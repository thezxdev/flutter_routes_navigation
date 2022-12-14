
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../models/models.dart';
import '../screens/screens.dart';

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
      GoRoute(
        name: 'onboarding',
        path: '/onboarding',
        builder:(context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        name: 'home',
        path: '/:tab', // Ruta con parámetros
        builder: (context, state) {
          final tab = int.tryParse(state.params['tab'] ?? '' ) ?? 0;
          return Home(
            key: state.pageKey,
            currentTab: tab,
          );
        },
        // Subrutas
        routes: [
          GoRoute(
            name: 'item',
            path: 'item/:id',
            builder: (context, state) {
              final itemId = state.params['id'] ?? '';
              final item = groceryManager.getGroceryItem(itemId);
              
              return GroceryItemScreen(
                originalItem: item,
                onCreate: (item) {
                  groceryManager.addItem(item);
                },
                onUpdate: (item) {
                  groceryManager.updateItem(item);
                },
              );
            },
          ),
          GoRoute(
            name: 'profile',
            path: 'profile',
            builder: (context, state) {
              final tab = int.tryParse(state.params['tab'] ?? '') ?? 0;

              return ProfileScreen(
                user: profileManager.getUser,
                currentTab: tab
              );
            },
            routes: [
              GoRoute(
                name: 'rw',
                path: 'rw',
                builder: (context, state) => const WebViewScreen(),
              )
            ]
          )
        ]
      )
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
    },
    redirect: (state) {
      final loggedIn = appStateManager.isLoggedIn;
      final logginIn = state.subloc == '/login'; // subloc = path
      if( !loggedIn ) return logginIn ? null : '/login';

      final isOnboardingComplete = appStateManager.isOnboardingComplete;
      final onboarding = state.subloc == '/onboarding';
      if( !isOnboardingComplete ) {
        return onboarding ? null : '/onboarding';
      }
      
      if( logginIn || onboarding ) return '/${FooderlichTab.explore}';

      return null;
    }

  );

}