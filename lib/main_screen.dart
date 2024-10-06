import 'package:flutter/material.dart';
import 'package:pixabay_lite_app/favorite_images.dart';
import 'package:pixabay_lite_app/image_gallery.dart';
import 'package:pixabay_lite_app/phone_gallery.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pixabay Gallery',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.satellite_alt_rounded), text: "Pixabay API"),
            Tab(icon: Icon(Icons.favorite), text: "Saved"),
            Tab(icon: Icon(Icons.phone_android_rounded), text: "Storage"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [const ImageGallery(), FavouriteScreen(), GalleryScreen()],
      ),
    );
  }
}
