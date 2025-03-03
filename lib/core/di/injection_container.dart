import 'package:audio_service/audio_service.dart';
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../../data/datasources/song_local_data_source.dart';
import '../../data/datasources/song_remote_data_source.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../data/repositories/song_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';
import '../../domain/repositories/song_repository.dart';
import '../../domain/usecases/cart_usecases.dart';
import '../../domain/usecases/get_top_songs.dart';
import '../../presentation/cubit/cart/cart_cubit.dart';
import '../../presentation/cubit/songs/songs_cubit.dart';
import '../../presentation/cubit/player/audio_player_cubit.dart';
import '../services/audio_handler.dart';
import '../services/permission_service.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Services
  sl.registerLazySingleton(() => PermissionService());

  // Audio Handler
  final audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.itunes_top_songs.audio',
      androidNotificationChannelName: 'iTunes Top Songs',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
  sl.registerSingleton<AudioHandler>(audioHandler);
  sl.registerSingleton<AudioPlayerHandler>(audioHandler);

  // Cubits
  sl.registerFactory(() => SongsCubit(getTopSongs: sl()));
  sl.registerFactory(() => CartCubit(
        getCartItems: sl(),
        addToCart: sl(),
        removeFromCart: sl(),
        updateCartItemQuantity: sl(),
        clearCart: sl(),
      ));
  sl.registerFactory(() => AudioPlayerCubit(sl<AudioPlayerHandler>()));

  // Use cases
  sl.registerLazySingleton(() => GetTopSongs(sl()));
  sl.registerLazySingleton(() => GetCartItems(sl()));
  sl.registerLazySingleton(() => AddToCart(sl()));
  sl.registerLazySingleton(() => RemoveFromCart(sl()));
  sl.registerLazySingleton(() => UpdateCartItemQuantity(sl()));
  sl.registerLazySingleton(() => ClearCart(sl()));

  // Repositories
  sl.registerLazySingleton<SongRepository>(
    () => SongRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<CartRepository>(
    () => CartRepositoryImpl(),
  );

  // Data sources
  sl.registerLazySingleton<SongRemoteDataSource>(
    () => SongRemoteDataSourceImpl(dio: sl()),
  );
  sl.registerLazySingleton<SongLocalDataSource>(
    () => SongLocalDataSourceImpl(database: sl()),
  );

  // External
  sl.registerLazySingleton(() => Dio());

  final database = await SongLocalDataSourceImpl.openDatabase();
  sl.registerLazySingleton(() => database);
}
