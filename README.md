# iTunes Top Songs

A Flutter application that displays the top 20 songs from iTunes and allows users to add them to a cart.

## Features

- Fetch top 20 songs from iTunes API
- Store songs in a local SQLite database
- Display songs in a list
- Play song previews
- Add songs to cart
- Manage cart items (increase/decrease quantity)
- Checkout functionality

## Architecture

This application follows Clean Architecture principles with the following layers:

- **Domain**: Contains business logic, entities, and use cases
- **Data**: Contains repositories, data sources, and models
- **Presentation**: Contains UI components, screens, and state management

## State Management

The application uses BLoC/Cubit for state management with the following cubits:

- **SongsCubit**: Manages the state of songs
- **CartCubit**: Manages the state of the cart
- **AudioPlayerCubit**: Manages the state of the audio player

## Dependencies

- **flutter_bloc**: For state management
- **get_it**: For dependency injection
- **dio**: For network requests
- **sqflite**: For local database
- **just_audio**: For audio playback
- **cached_network_image**: For image caching

## Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Run `flutter run` to start the application


## License

This project is licensed under the MIT License - see the LICENSE file for details.
