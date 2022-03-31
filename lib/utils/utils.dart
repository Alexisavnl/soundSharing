import 'package:image_picker/image_picker.dart';

// for picking up image from gallery
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file = await _imagePicker.pickImage(source: source, imageQuality: 85, maxHeight: 500, maxWidth: 500);
  if (_file != null) {
    return await _file.readAsBytes();
  }
  print('No Image Selected');
}