import '../entities/cart_item.dart';
import '../entities/song.dart';

abstract class CartRepository {
  List<CartItem> getCartItems();
  void addToCart(Song song);
  void removeFromCart(Song song);
  void updateQuantity(Song song, int quantity);
  void clearCart();
}
