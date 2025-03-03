import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/song.dart';
import '../../../domain/usecases/cart_usecases.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  final GetCartItems getCartItems;
  final AddToCart addToCart;
  final RemoveFromCart removeFromCart;
  final UpdateCartItemQuantity updateCartItemQuantity;
  final ClearCart clearCart;

  CartCubit({
    required this.getCartItems,
    required this.addToCart,
    required this.removeFromCart,
    required this.updateCartItemQuantity,
    required this.clearCart,
  }) : super(const CartState());

  void loadCart() {
    final items = getCartItems();
    emit(CartState(items: items));
  }

  void addSongToCart(Song song) {
    addToCart(song);
    loadCart();
  }

  void removeSongFromCart(Song song) {
    removeFromCart(song);
    loadCart();
  }

  void updateQuantity(Song song, int quantity) {
    updateCartItemQuantity(song, quantity);
    loadCart();
  }

  void checkout() {
    clearCart();
    loadCart();
  }
}
