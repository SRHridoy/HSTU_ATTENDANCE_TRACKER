import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> openExcelFile(String filePath) async {
  final Uri fileUri = Uri.file(filePath);
  if (await canLaunchUrl(fileUri)) {
    await launchUrl(fileUri);
  } else {
    if (kDebugMode) {
      print("❌ Could not open file: $filePath");
    }
  }
}
