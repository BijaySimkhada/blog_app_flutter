import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<String?> getImageFromGallery() async {
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      return image.path;
    }
    return null;
  }

  Future<String?> getImageFromCamera() async {
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return image.path;
    }
    return null;
  }
}
