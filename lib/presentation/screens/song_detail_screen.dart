import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/song.dart';
import '../cubit/cart/cart_cubit.dart';
import '../cubit/player/audio_player_cubit.dart';
import '../cubit/player/audio_player_state.dart';
import '../widgets/audio_player_controls.dart';
import '../widgets/now_playing_bar.dart';

class SongDetailScreen extends StatelessWidget {
  final Song song;

  const SongDetailScreen({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song Details'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Hero(
                    tag: 'song-image-${song.id}',
                    child: CachedNetworkImage(
                      imageUrl: song.albumImage,
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.music_note,
                            color: Colors.grey, size: 80),
                      ),
                      errorWidget: (context, url, error) => Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey[300],
                        child: const Icon(Icons.error,
                            color: Colors.grey, size: 80),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Text(
                          song.title,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          song.artist,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.grey[700],
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
                          builder: (context, state) {
                            final isCurrentSong =
                                state.currentSong?.id == song.id;
                            return AudioPlayerControls(
                              isPlaying: isCurrentSong &&
                                  state.status == AudioPlayerStatus.playing,
                              isLoading: isCurrentSong &&
                                  state.status == AudioPlayerStatus.loading,
                              position: isCurrentSong
                                  ? state.position
                                  : Duration.zero,
                              duration: isCurrentSong
                                  ? state.duration
                                  : Duration.zero,
                              onPlay: () => context
                                  .read<AudioPlayerCubit>()
                                  .playSong(song),
                              onPause: () =>
                                  context.read<AudioPlayerCubit>().pause(),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<CartCubit>().addSongToCart(song);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${song.title} added to cart'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add_shopping_cart),
                          label: const Text('Add to Cart'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Now Playing Bar (only show if the current song is different from the detail page song)
          BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
            builder: (context, state) {
              if (state.currentSong != null &&
                  state.currentSong!.id != song.id) {
                return const NowPlayingBar();
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
