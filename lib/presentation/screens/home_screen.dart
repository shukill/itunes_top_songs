import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/song.dart';
import '../cubit/cart/cart_cubit.dart';
import '../cubit/cart/cart_state.dart';
import '../cubit/songs/songs_cubit.dart';
import '../cubit/songs/songs_state.dart';
import '../widgets/now_playing_bar.dart';
import '../widgets/song_list_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SongsCubit>().loadSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('iTunes Top Songs'),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/cart');
                    },
                  ),
                  if (state.totalItems > 0)
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${state.totalItems}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<SongsCubit, SongsState>(
              builder: (context, state) {
                if (state.status == SongsStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state.status == SongsStatus.error) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${state.errorMessage}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            context.read<SongsCubit>().loadSongs();
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else if (state.status == SongsStatus.loaded) {
                  if (state.songs.isEmpty) {
                    return const Center(child: Text('No songs available'));
                  }

                  return ListView.builder(
                    itemCount: state.songs.length,
                    itemBuilder: (context, index) {
                      final song = state.songs[index];
                      return SongListItem(
                        song: song,
                        onTap: () => _navigateToSongDetail(song),
                        onAddToCart: () => _addToCart(song),
                      );
                    },
                  );
                }
                return const Center(child: Text('No songs available'));
              },
            ),
          ),
          // Now Playing Bar
          const NowPlayingBar(),
        ],
      ),
    );
  }

  void _navigateToSongDetail(Song song) {
    Navigator.of(context).pushNamed('/song-detail', arguments: song);
  }

  void _addToCart(Song song) {
    context.read<CartCubit>().addSongToCart(song);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${song.title} added to cart'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}
