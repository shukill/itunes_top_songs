import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart' as di;
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/cubit/cart/cart_cubit.dart';
import 'presentation/cubit/player/audio_player_cubit.dart';
import 'presentation/cubit/songs/songs_cubit.dart';
import 'core/services/permission_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SongsCubit>(
          create: (_) => di.sl<SongsCubit>(),
        ),
        BlocProvider<CartCubit>(
          create: (_) => di.sl<CartCubit>()..loadCart(),
        ),
        BlocProvider<AudioPlayerCubit>(
          create: (_) => di.sl<AudioPlayerCubit>(),
        ),
      ],
      child: MaterialApp(
        title: 'iTunes Top Songs',
        theme: AppTheme.darkTheme,
        onGenerateRoute: _appRouter.onGenerateRoute,
        initialRoute: '/',
        builder: (context, child) {
          // Request permissions after the app is built
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _requestPermissions(context);
          });
          return child ?? const SizedBox.shrink();
        },
      ),
    );
  }

  Future<void> _requestPermissions(BuildContext context) async {
    final permissionService = di.sl<PermissionService>();

    // Check if notification permission is already granted
    final isNotificationGranted =
        await permissionService.isNotificationPermissionGranted();
    if (!isNotificationGranted) {
      // Show dialog for notification permission
      await permissionService.showPermissionDialog(
        context,
        title: 'Notification Permission',
        content:
            'We need notification permission to show playback controls and updates.',
        onRequestPermission: () async {
          await permissionService.requestNotificationPermission();
        },
      );
    }

    // Check if battery optimization permission is already granted
    final isBatteryOptimizationGranted =
        await permissionService.isBatteryOptimizationPermissionGranted();
    if (!isBatteryOptimizationGranted) {
      // Show dialog for battery optimization permission
      await permissionService.showPermissionDialog(
        context,
        title: 'Battery Optimization',
        content:
            'Please disable battery optimization for this app to ensure uninterrupted playback in the background.',
        onRequestPermission: () async {
          await permissionService.requestBatteryOptimizationPermission();
        },
      );
    }
  }
}
