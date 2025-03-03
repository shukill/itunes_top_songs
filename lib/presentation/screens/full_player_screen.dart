import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../domain/entities/song.dart';
import '../cubit/player/audio_player_cubit.dart';
import '../cubit/player/audio_player_state.dart';
import '../widgets/audio_player_controls.dart';

class FullPlayerScreen extends StatelessWidget {
  final Song song;

  const FullPlayerScreen({
    super.key,
    required this.song,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing'),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Album artwork
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: Hero(
                          tag: 'song-image-${song.id}',
                          child: CachedNetworkImage(
                            imageUrl: song.albumImage,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[800],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[800],
                              child: const Icon(Icons.music_note, size: 80),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Song info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          Text(
                            song.title,
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            song.artist,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Colors.white70,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Player controls
              Padding(
                padding: const EdgeInsets.only(bottom: 48, left: 24, right: 24),
                child: BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
                  builder: (context, state) {
                    final isCurrentSong = state.currentSong?.id == song.id;
                    return AudioPlayerControls(
                      isPlaying: isCurrentSong &&
                          state.status == AudioPlayerStatus.playing,
                      isLoading: isCurrentSong &&
                          state.status == AudioPlayerStatus.loading,
                      position: isCurrentSong ? state.position : Duration.zero,
                      duration: isCurrentSong ? state.duration : Duration.zero,
                      onPlay: () =>
                          context.read<AudioPlayerCubit>().playSong(song),
                      onPause: () => context.read<AudioPlayerCubit>().pause(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
