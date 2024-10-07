import 'package:flutter/material.dart';

void showImagePreviewDialog(BuildContext context, String imageUrl) {
  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Full-screen image preview
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Hero(
                    tag: imageUrl,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
            // Top-right cancel button
            Positioned(
              right: 0.0,
              child: IconButton(
                icon: const Icon(Icons.cancel),
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}
