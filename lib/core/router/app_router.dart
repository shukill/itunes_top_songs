import 'package:flutter/material.dart';
import '../../domain/entities/song.dart';
import '../../presentation/screens/cart_screen.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/song_detail_screen.dart';

class AppRouter {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
      case '/song-detail':
        final song = settings.arguments as Song;
        return MaterialPageRoute(
          builder: (_) => SongDetailScreen(song: song),
        );
      case '/cart':
        return MaterialPageRoute(
          builder: (_) => const CartScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        );
    }
  }
}

// Run the following command to generate the router:
// flutter packages pub run build_runner build 