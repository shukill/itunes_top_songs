import '../../domain/entities/cart_item.dart';
import '../../domain/entities/song.dart';
import '../../domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final List<CartItem> _cartItems = [];

  @override
  List<CartItem> getCartItems() {
    return List.from(_cartItems);
  }

  @override
  void addToCart(Song song) {
    final existingIndex =
        _cartItems.indexWhere((item) => item.song.id == song.id);

    if (existingIndex >= 0) {
      final existingItem = _cartItems[existingIndex];
      _cartItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      _cartItems.add(CartItem(song: song, quantity: 1));
    }
  }

  @override
  void removeFromCart(Song song) {
    _cartItems.removeWhere((item) => item.song.id == song.id);
  }

  @override
  void updateQuantity(Song song, int quantity) {
    final existingIndex =
        _cartItems.indexWhere((item) => item.song.id == song.id);

    if (existingIndex >= 0) {
      if (quantity <= 0) {
        _cartItems.removeAt(existingIndex);
      } else {
        final existingItem = _cartItems[existingIndex];
        _cartItems[existingIndex] = existingItem.copyWith(quantity: quantity);
      }
    }
  }

  @override
  void clearCart() {
    _cartItems.clear();
  }
}
