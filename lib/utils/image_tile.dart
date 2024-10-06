import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pixabay_lite_app/Database/database.dart';
import 'package:shimmer/shimmer.dart';

// ignore: must_be_immutable
class ImageTile extends StatefulWidget {
  final String imageUrl;
  int? likes;
  int? views;

  ImageTile({
    Key? key,
    required this.imageUrl,
    this.likes,
    this.views,
  }) : super(key: key);

  @override
  _ImageTileState createState() => _ImageTileState();
}

class _ImageTileState extends State<ImageTile> {
  bool isFavorited = false;

  @override
  void initState() {
    super.initState();
    _checkIfFavorited(); // Check if the image is in favorites
  }

  void _checkIfFavorited() async {
    bool exists = await DataBaseHelper().isImageInFavorites(widget.imageUrl);
    setState(() {
      isFavorited = exists; // Set favorite status
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        Card(
          elevation: 2,
          child: Column(
            children: [
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: widget.imageUrl,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor:
                        isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                    highlightColor:
                        isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                    child: Container(
                      color: isDarkMode ? Colors.black : Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.red,
                            ),
                            SizedBox(width: 4),
                            Text('Likes', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                        Text('${widget.likes}',
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(
                              Icons.remove_red_eye,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 4),
                            Text('Views', style: TextStyle(fontSize: 13)),
                          ],
                        ),
                        Text('${widget.views}',
                            style: const TextStyle(fontSize: 14)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                color: const Color.fromARGB(89, 255, 255, 255),
                borderRadius: BorderRadius.circular(50)),
            child: IconButton(
              icon: Icon(
                isFavorited ? Icons.favorite : Icons.favorite_border,
                color: isFavorited ? Colors.red : Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isFavorited = !isFavorited; // Toggle favorite status
                });
                isFavorited
                    ? DataBaseHelper().addImageToFavorites(widget.imageUrl)
                    : DataBaseHelper()
                        .removeImageFromFavorites(widget.imageUrl);
              },
            ),
          ),
        ),
      ],
    );
  }
}
