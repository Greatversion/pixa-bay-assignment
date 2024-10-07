import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:http/browser_client.dart' as https;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pixabay_lite_app/utils/image_tile.dart';
import 'package:pixabay_lite_app/utils/preview_dialgoue.dart';
import 'package:shimmer/shimmer.dart';

class ImageGallery extends StatefulWidget {
  const ImageGallery({super.key});

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final String _apiKey = dotenv.env['API_KEY']!;
  final String _baseUrl = 'https://pixabay.com/api/';
  List images = [];
  int _page = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false; // For loading more images
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.extentAfter < 300) {
        print('Reached near the bottom, loading more images...');
        _fetchMoreImages();
      }
    });

    // Only fetch images if the images list is empty
    if (images.isEmpty) {
      print('Fetching images for the first time.');
      _fetchImages();
    }
  }

  Future<void> _fetchImages() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.get(
        Uri.parse(
            '$_baseUrl?key=$_apiKey&image_type=photo&per_page=100&page=$_page'),
      );

      if (response.statusCode == 200) {
        setState(() {
          images.addAll(json.decode(response.body)['hits']);
          _page++;
        });
      } else {
        throw Exception('Failed to load images');
      }
    } catch (error) {
      print('Error fetching images: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchMoreImages() async {
    if (_isLoadingMore) return;
    setState(() {
      _isLoadingMore = true;
    });

    final response = await http.get(
      Uri.parse(
          '$_baseUrl?key=$_apiKey&image_type=photo&per_page=20&page=$_page'),
    );
    if (response.statusCode == 200) {
      setState(() {
        images.addAll(json.decode(response.body)['hits']);
        _page++;
        _isLoadingMore = false;
      });
    } else {
      setState(() {
        _isLoadingMore = false;
      });
      throw Exception('Failed to load more images');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: images.isEmpty && _isLoading
          ? _buildShimmerGrid() // Show shimmer effect while loading the first page
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  int columns = (constraints.maxWidth / 150).floor();
                  return GridView.builder(
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: columns,
                      crossAxisSpacing: 6.0,
                      mainAxisSpacing: 4.0,
                      childAspectRatio: 1,
                    ),
                    itemCount: images.length +
                        (_isLoadingMore
                            ? 1
                            : 0), // Extra item for loading indicator
                    itemBuilder: (context, index) {
                      if (index == images.length) {
                        return _buildCenteredLoadingIndicator();
                      }
                      final image = images[index];
                      return GestureDetector(
                        onTap: () {
                          showImagePreviewDialog(
                              context, image['webformatURL']);
                        },
                        child: ImageTile(
                          imageUrl: image['webformatURL'],
                          likes: image['likes'],
                          views: image['views'],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
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

  // Centered green loading indicator for pagination
  Widget _buildCenteredLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
