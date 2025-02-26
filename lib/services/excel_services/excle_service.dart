import 'package:file_picker/file_picker.dart';

class FilePickerService {
  static Future<String?> pickExcelFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['xlsx'],
    );

    return result?.files.single.path; // Return file path
  }
}
