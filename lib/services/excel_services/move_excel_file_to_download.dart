import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String> moveFileToDownload(String fileName) async {
  //Request storage permission
  var status = await Permission.storage.request();
  if (!status.isGranted) {
    if (kDebugMode) {
      print("❌ Storage permission denied!");
    }
    return fileName;
  }

  // Get the current file location (for example, in app's documents directory)
  Directory appDocDir = await getApplicationDocumentsDirectory();
  String oldPath = "${appDocDir.path}/$fileName.xlsx"; // Change extension if needed

  // Get the Download folder path
  Directory? downloadDir = Directory("/storage/emulated/0/Download"); // For Android

  if (!await downloadDir.exists()) {
    if (kDebugMode) {
      print("❌ Download folder not found!");
    }
    return fileName;
  }

  String newPath = "${downloadDir.path}/$fileName.xlsx"; // Destination path

  File oldFile = File(oldPath);
  File newFile = File(newPath);

  if (await oldFile.exists()) {
    await oldFile.copy(newFile.path); // Copy the file
    await oldFile.delete(); // Optional: Delete the original file
    if (kDebugMode) {
      print("✅ File moved to: $newPath");
    }
    return newPath;
  } else {
    if (kDebugMode) {
      print("❌ File not found at: $oldPath");
    }
    return fileName;
  }
}
