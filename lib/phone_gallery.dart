import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:shimmer/shimmer.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<AssetEntity> _images = [];

  @override
  void initState() {
    super.initState();
    _fetchGalleryImages();
  }

  Future<void> _fetchGalleryImages() async {
    final permitted = await PhotoManager.requestPermissionExtend();
    if (permitted.isAuth) {
      List<AssetPathEntity> galleries = await PhotoManager.getAssetPathList(
        type: RequestType.image,
      );
      List<AssetEntity> images =
          await galleries[0].getAssetListPaged(page: 0, size: 100);
      setState(() {
        _images = images;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      // appBar: AppBar(title: const Text('Gallery')),
      body: _images.isEmpty
          ?  _buildShimmerGrid()
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
                    child: FutureBuilder<Uint8List?>(
                      future: _images[index].thumbnailData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.data != null) {
                          return Image.memory(snapshot.data!,
                              fit: BoxFit.cover);
                        }
                        return Shimmer.fromColors(
                          baseColor: isDarkMode
                              ? Colors.grey[800]!
                              : Colors.grey[300]!,
                          highlightColor: isDarkMode
                              ? Colors.grey[700]!
                              : Colors.grey[100]!,
                          child: Container(
                            color: isDarkMode ? Colors.black : Colors.white,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }),
    );
  }

  // Shimmer effect for first page
  Widget _buildShimmerGrid() {
    if(Platform.isAndroid){
      return const Text("Access Device Images in Android only");
    }
    return   LayoutBuilder(
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
