import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class ImagePickerService {
  Future<File?> pickFromCamera();
  Future<File?> pickFromGallery();
}

class ImagePickerServiceImpl implements ImagePickerService {
  final ImagePicker _picker;

  ImagePickerServiceImpl({ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  @override
  Future<File?> pickFromCamera() async {
    return _pickImage(ImageSource.camera);
  }

  @override
  Future<File?> pickFromGallery() async {
    return _pickImage(ImageSource.gallery);
  }

  Future<File?> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile == null) return null;

      return File(pickedFile.path);
    } catch (_) {
      rethrow;
    }
  }
}
