import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/theme/app_theme.dart';
import '../cubit/player/audio_player_cubit.dart';
import '../cubit/player/audio_player_state.dart';
import '../screens/full_player_screen.dart';

class NowPlayingBar extends StatelessWidget {
  const NowPlayingBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
      buildWhen: (previous, current) =>
          previous.currentSong != current.currentSong ||
          previous.status != current.status ||
          (current.status == AudioPlayerStatus.playing &&
              previous.position.inSeconds != current.position.inSeconds),
      builder: (context, state) {
        if (state.currentSong == null ||
            state.status == AudioPlayerStatus.stopped ||
            state.status == AudioPlayerStatus.initial) {
          return const SizedBox.shrink();
        }

        return Material(
          elevation: 8,
          color: AppTheme.cardColor,
          child: InkWell(
            onTap: () {
              // Navigate to full player screen
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      FullPlayerScreen(song: state.currentSong!),
                ),
              );
            },
            child: Container(
              height: 72,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Album artwork
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: state.currentSong!.albumImage,
                      width: 48,
                      height: 48,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[800],
                        child: const Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.music_note),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Song info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          state.currentSong!.title,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          state.currentSong!.artist,
                          style: Theme.of(context).textTheme.bodyMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Progress indicator
                  if (state.duration.inMilliseconds > 0)
                    SizedBox(
                      width: 40,
                      child: Text(
                        _formatDuration(state.position),
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Play/Pause button
                  IconButton(
                    icon: Icon(
                      state.status == AudioPlayerStatus.playing
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_filled,
                      color: AppTheme.primaryColor,
                      size: 36,
                    ),
                    onPressed: () {
                      final cubit = context.read<AudioPlayerCubit>();
                      if (state.status == AudioPlayerStatus.playing) {
                        cubit.pause();
                      } else {
                        cubit.resume();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
