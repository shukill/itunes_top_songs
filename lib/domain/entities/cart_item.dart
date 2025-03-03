import 'package:equatable/equatable.dart';
import 'song.dart';

class CartItem extends Equatable {
  final Song song;
  final int quantity;

  const CartItem({
    required this.song,
    required this.quantity,
  });

  CartItem copyWith({
    Song? song,
    int? quantity,
  }) {
    return CartItem(
      song: song ?? this.song,
      quantity: quantity ?? this.quantity,
    );
  }

  @override
  List<Object?> get props => [song, quantity];
}
