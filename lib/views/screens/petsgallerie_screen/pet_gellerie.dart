import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/Picture_Provider.dart';

class PetPictures extends StatelessWidget {
  const PetPictures({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Provider.of<PetGalleryProvider>(context, listen: false)
          .images
          .isEmpty) {
        Provider.of<PetGalleryProvider>(context, listen: false).fetchImages();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Pictures Gallery'),
        titleTextStyle: const TextStyle(color: Colors.black, fontSize: 20),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt, color: Colors.black),
            onPressed: () {
              Provider.of<PetGalleryProvider>(context, listen: false)
                  .takePicture();
            },
          ),
          IconButton(
            icon: const Icon(Icons.image, color: Colors.black),
            onPressed: () {
              Provider.of<PetGalleryProvider>(context, listen: false)
                  .importImage();
            },
          ),
        ],
      ),
      body: Consumer<PetGalleryProvider>(
        builder: (context, model, child) {
          return SingleChildScrollView(
            child: _buildImageGrid(context, model.images),
          );
        },
      ),
    );
  }

  Widget _buildImageGrid(BuildContext context, List<ImageData> images) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      primary: false,
      padding: const EdgeInsets.all(5),
      itemCount: images.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 200 / 200,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.all(5.0),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Confirm'),
                    content: const Text('Do you want to delete this image?'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: const Text('Delete'),
                        onPressed: () {
                          Provider.of<PetGalleryProvider>(context,
                                  listen: false)
                              .deleteImage(images[index].id);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
                child: Image.file(images[index].file, fit: BoxFit.cover),
              ),
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                  onPressed: () {
                    _showScanDialog(context, images[index].id);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showScanDialog(BuildContext context, String imageId) {
    final petGalleryProvider =
        Provider.of<PetGalleryProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.microtask(() {
          petGalleryProvider.scanImage(context, imageId);
        });

        return Consumer<PetGalleryProvider>(
          builder: (context, model, child) {
            return AlertDialog(
              title: const Text('Scanning'),
              content: model.isScanning
                  ? const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Scan in progress, please wait...'),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Scan complete!'),
                        const SizedBox(height: 20),
                        Text('Emotion: ${model.scanLabel ?? "Unknown"}'),
                        if (model.scanLabel != null)
                          _getEmojiForEmotion(model.scanLabel!),
                      ],
                    ),
              actions: [
                if (!model.isScanning)
                  TextButton(
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _getEmojiForEmotion(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
        return const Text('😊', style: TextStyle(fontSize: 30));
      case 'angry':
        return const Text('😠', style: TextStyle(fontSize: 30));
      case 'sad':
        return const Text('😢', style: TextStyle(fontSize: 30));
      case 'relaxed':
        return const Text('😌', style: TextStyle(fontSize: 30));
      default:
        return const Text('🤔', style: TextStyle(fontSize: 30));
    }
  }
}
