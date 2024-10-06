
---

# Pixabay Image Gallery App

A **Flutter-based Image Gallery** that allows users to:
- Load images from the **Pixabay API**.
- Load images from the **device storage**.
- Mark images as **Favorites** using `SharedPreferences`.

## Features
1. **Pixabay Image Gallery**: Fetch images from the Pixabay API and display them in a dynamic grid.
2. **Load On-Device Images**: Allow users to browse and view images stored on their local device.
3. **Mark Favorite Images**: Users can favorite/unfavorite images. The favorites are saved locally using `SharedPreferences` and can be accessed later.
4. **Infinite Scrolling**: Automatically loads more images when the user scrolls to the bottom of the gallery.
5. **Pull-to-Refresh**: Refresh the image gallery by pulling down on the grid.
6. **Dark Mode Support**: The app supports both light and dark modes.


## Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Pixabay API Key](https://pixabay.com/api/docs/)
  
You will need to register on Pixabay to obtain a free API key. Replace the `apiKey` variable in the code with your own API key.

### Installing

1. **Clone the repository**:
   ```bash
   git clone https://github.com/your-username/flutter-image-gallery.git
   cd flutter-image-gallery
   ```

2. **Install dependencies**:
   Run the following command to install all the required packages:
   ```bash
   flutter pub get
   ```

3. **Configure the Pixabay API**:
   Open the `lib/screens/image_gallery.dart` file and replace the `_apiKey` with your Pixabay API key:
   ```dart
   final String _apiKey = 'YOUR_PIXABAY_API_KEY';
   ```

4. **Run the app**:
   Launch the app on an emulator or physical device using:
   ```bash
   flutter run
   ```
