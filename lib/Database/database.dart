import 'package:shared_preferences/shared_preferences.dart';

class DataBaseHelper {
  List<String> images = [];
  Future<void> addImageToFavorites(String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteImages = prefs.getStringList('favoriteImages') ?? [];
    favoriteImages.add(imageUrl);
    await prefs.setStringList('favoriteImages', favoriteImages);
  }

  Future<bool> isImageInFavorites(String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteImages = prefs.getStringList('favoriteImages') ?? [];

    return favoriteImages.contains(imageUrl);
  }

  Future<void> removeImageFromFavorites(String imageUrl) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteImages = prefs.getStringList('favoriteImages') ?? [];
    favoriteImages.remove(imageUrl);
    await prefs.setStringList('favoriteImages', favoriteImages);
  }

  Future<List<String>> getFavoriteImages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    images = prefs.getStringList('favoriteImages')!;

    return prefs.getStringList('favoriteImages') ?? [];
  }
}
