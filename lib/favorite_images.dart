import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:pixabay_lite_app/Database/database.dart';
import 'package:pixabay_lite_app/utils/image_tile.dart';
import 'package:shimmer/shimmer.dart';

class FavouriteScreen extends StatefulWidget {
  @override
  _FavouriteScreenState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends State<FavouriteScreen> {
  List<String> _images = [];

  @override
  void initState() {
    super.initState();
    fetchImages();
  }

  fetchImages() async {
    List<String> fetchedImages = await DataBaseHelper().getFavoriteImages();
    print("Fetched Images: $fetchedImages"); // Debugging
    setState(() {
      _images = fetchedImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      // appBar: AppBar(title: const Text('Gallery')),
      body: _images.isEmpty
          ? const Center(child: Text("No Images Available"))
          : LayoutBuilder(builder: (context, constraints) {
              int columns = (constraints.maxWidth / 150).floor();
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                ),
                itemCount: _images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Card(
                      elevation: 2,
                      child: Column(
                        children: [
                          Expanded(
                            child: CachedNetworkImage(
                              imageUrl: _images[index],
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: isDarkMode
                                    ? Colors.grey[800]!
                                    : Colors.grey[300]!,
                                highlightColor: isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[100]!,
                                child: Container(
                                  color:
                                      isDarkMode ? Colors.black : Colors.white,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
    );
  }

  // Shimmer effect for first page
  Widget _buildShimmerGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = (constraints.maxWidth / 150).floor();
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 6.0,
            mainAxisSpacing: 4.0,
            childAspectRatio: 1,
          ),
          itemCount: 20, // Placeholder for shimmer effect
          itemBuilder: (context, index) {
            // Get current brightness (light or dark mode)
            final isDarkMode = Theme.of(context).brightness == Brightness.dark;

            return Shimmer.fromColors(
              baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
              highlightColor:
                  isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
              child: Container(
                color: isDarkMode ? Colors.black : Colors.white,
              ),
            );
          },
        );
      },
    );
  }
}
