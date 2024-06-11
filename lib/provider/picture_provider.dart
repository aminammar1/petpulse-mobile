import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:petpulse/config/config.dart';
import 'package:http_parser/http_parser.dart';
import 'package:logger/logger.dart';

class ImageData {
  final File file;
  final String id;

  ImageData({required this.file, required this.id});
}

class PetGalleryProvider with ChangeNotifier {
  List<ImageData> _images = [];
  String? _scanLabel;
  double? _scanScore;
  bool _isScanning = false;

  List<ImageData> get images => _images;
  String? get scanLabel => _scanLabel;
  double? get scanScore => _scanScore;
  bool get isScanning => _isScanning;

  PetGalleryProvider() {
    init();
  }

  Future<void> init() async {
    if (_images.isEmpty) {
      await fetchImages();
    }
  }

  Future<void> takePicture() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = path.join(directory.path, path.basename(photo.path));
      final File newImage = File(photo.path).copySync(imagePath);
      await uploadImage(newImage);
      notifyListeners();
    }
  }

  Future<void> importImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.gallery);
    if (photo != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath = path.join(directory.path, path.basename(photo.path));
      final File newImage = File(photo.path).copySync(imagePath);
      await uploadImage(newImage);
      notifyListeners();
    }
  }

  Future<String> uploadImage(File image) async {
    String imageId = '';
    try {
      final uri = Uri.parse(URL.picturespets);
      var request = http.MultipartRequest('POST', uri)
        ..files.add(
          http.MultipartFile.fromBytes(
            'image',
            await image.readAsBytes(),
            filename: path.basename(image.path),
            contentType: MediaType('image', 'jpeg'),
          ),
        );
      var response = await request.send();
      if (response.statusCode == 201) {
        Logger().d('Image uploaded successfully');
        final respStr = await response.stream.bytesToString();
        final respJson = jsonDecode(respStr);
        if (respJson['id'] != null) {
          imageId = respJson['id'];
          _images.add(ImageData(file: image, id: imageId));
          notifyListeners();
        } else {
          Logger().e('Error: id is null');
        }
      } else {
        Logger().e('Failed to upload image: ${response.statusCode}');
        response.stream.transform(utf8.decoder).listen((value) {});
      }
    } catch (e) {
      Logger().e('Error uploading image: $e');
    }
    return imageId;
  }

  Future<void> fetchImages() async {
    try {
      final uri = Uri.parse(URL.getpictures);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        List<dynamic> imageDataList = json.decode(response.body);
        _images = await _convertBase64ToFiles(imageDataList);
        notifyListeners();
      }
    } catch (e) {
      Logger().e('Error fetching images: $e');
    }
  }

  Future<List<ImageData>> _convertBase64ToFiles(
      List<dynamic> imageDataList) async {
    List<ImageData> fileList = [];
    final tempDir = await getTemporaryDirectory();
    for (var imageData in imageDataList) {
      String base64String = imageData['content'];
      String imageId = imageData['id'];
      List<int> imageBytes = base64Decode(base64String);
      String fileName = 'image_$imageId.jpeg';
      File file = File(path.join(tempDir.path, fileName));
      await file.writeAsBytes(imageBytes);
      fileList.add(ImageData(file: file, id: imageId));
    }
    return fileList;
  }

  Future<void> deleteImage(String imageId) async {
    try {
      final uri = Uri.parse('${URL.deleteimage}/$imageId');
      final response = await http.delete(uri);

      if (response.statusCode == 200) {
        _images.removeWhere((imageData) => imageData.id == imageId);
        notifyListeners();
        Logger().d('Image deleted successfully');
      } else {
        Logger().e('Failed to delete image: ${response.statusCode}');
      }
    } catch (e) {
      Logger().e('Error deleting image: $e');
    }
  }

  Future<void> scanImage(BuildContext context, String imageId) async {
    _isScanning = true;
    notifyListeners();

    try {
      final uri = Uri.parse(URL.analyzeImage);
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'id': imageId}),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        _scanLabel = result['label'];
      } else {
        throw Exception('Failed to analyze image: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error analyzing image: $e');
    } finally {
      _isScanning = false;
      notifyListeners();
    }
  }
}
