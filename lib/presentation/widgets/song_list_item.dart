import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/song.dart';
import '../cubit/player/audio_player_cubit.dart';
import '../cubit/player/audio_player_state.dart';
import '../cubit/cart/cart_cubit.dart';
import '../cubit/cart/cart_state.dart';

class SongListItem extends StatelessWidget {
  final Song song;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;

  const SongListItem({
    super.key,
    required this.song,
    required this.onTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: CachedNetworkImage(
            imageUrl: song.albumImage,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.music_note, color: Colors.grey),
            ),
            errorWidget: (context, url, error) => Container(
              width: 60,
              height: 60,
              color: Colors.grey[300],
              child: const Icon(Icons.error, color: Colors.grey),
            ),
          ),
        ),
        title: Text(
          song.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          song.artist,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocBuilder<CartCubit, CartState>(
              builder: (context, cartState) {
                // Check if the song is already in the cart
                final isInCart =
                    cartState.items.any((item) => item.song.id == song.id);

                // Only show the add to cart button if the song is not in the cart
                return isInCart
                    ? const SizedBox(
                        width:
                            40) // Use a spacer with the same width as the button
                    : IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: onAddToCart,
                        tooltip: 'Add to Cart',
                      );
              },
            ),
            BlocBuilder<AudioPlayerCubit, AudioPlayerState>(
              builder: (context, state) {
                final isPlaying = state.currentSong?.id == song.id &&
                    state.status == AudioPlayerStatus.playing;
                final isLoading = state.currentSong?.id == song.id &&
                    state.status == AudioPlayerStatus.loading;

                return IconButton(
                  icon: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                  onPressed: () {
                    final audioPlayerCubit = context.read<AudioPlayerCubit>();
                    if (isPlaying) {
                      audioPlayerCubit.pause();
                    } else {
                      audioPlayerCubit.playSong(song);
                    }
                  },
                  tooltip: isPlaying ? 'Pause' : 'Play',
                );
              },
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
