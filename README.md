Pixabay Image Gallery App
A Flutter-based Image Gallery that allows users to:

Load images from the Pixabay API.
Load images from the device storage.
Mark images as Favorites using SharedPreferences.
Features
Pixabay Image Gallery: Fetch images from the Pixabay API and display them in a dynamic grid.
Load On-Device Images: Allow users to browse and view images stored on their local device.
Mark Favorite Images: Users can favorite/unfavorite images. The favorites are saved locally using SharedPreferences and can be accessed later.
Infinite Scrolling: Automatically loads more images when the user scrolls to the bottom of the gallery.
Search Functionality: Users can search for images from the Pixabay API based on keywords.
Pull-to-Refresh: Refresh the image gallery by pulling down on the grid.
Dark Mode Support: The app supports both light and dark modes.
Screenshots
Add relevant screenshots here (grid view, on-device images, favorites, etc.).

Getting Started
Prerequisites
Flutter SDK
Pixabay API Key
You will need to register on Pixabay to obtain a free API key. Replace the apiKey variable in the code with your own API key.

Installing
Clone the repository:

bash
Copy code
git clone https://github.com/your-username/flutter-image-gallery.git
cd flutter-image-gallery
Install dependencies: Run the following command to install all the required packages:

bash
Copy code
flutter pub get
Configure the Pixabay API: Open the lib/screens/image_gallery.dart file and replace the _apiKey with your Pixabay API key:

dart
Copy code
final String _apiKey = 'YOUR_PIXABAY_API_KEY';
Run the app: Launch the app on an emulator or physical device using:

bash
Copy code
flutter run
