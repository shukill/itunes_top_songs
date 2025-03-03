import '../entities/cart_item.dart';
import '../entities/song.dart';
import '../repositories/cart_repository.dart';

class GetCartItems {
  final CartRepository repository;

  GetCartItems(this.repository);

  List<CartItem> call() {
    return repository.getCartItems();
  }
}

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  void call(Song song) {
    repository.addToCart(song);
  }
}

class RemoveFromCart {
  final CartRepository repository;

  RemoveFromCart(this.repository);

  void call(Song song) {
    repository.removeFromCart(song);
  }
}

class UpdateCartItemQuantity {
  final CartRepository repository;

  UpdateCartItemQuantity(this.repository);

  void call(Song song, int quantity) {
    repository.updateQuantity(song, quantity);
  }
}

class ClearCart {
  final CartRepository repository;

  ClearCart(this.repository);

  void call() {
    repository.clearCart();
  }
}
