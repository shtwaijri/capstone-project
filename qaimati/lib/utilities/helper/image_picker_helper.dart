import 'dart:io';

import 'package:image_picker/image_picker.dart';

/// Helper class to handle image picking from the device gallery.
class ImagePickerHelper {
  /// Opens the device gallery to pick an image.
  ///
  /// Returns a [File] representing the selected image,
  /// or `null` if no image was selected.
  Future<File?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return File(image.path);
    }
    return null;
  }
}
