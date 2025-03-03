import 'package:flutter/foundation.dart';
import 'package:hstu_attendance_tracker/services/db_services/students_db_helper.dart';
import 'package:excel/excel.dart';
import 'package:hstu_attendance_tracker/services/excel_services/move_excel_file_to_download.dart';
import 'package:hstu_attendance_tracker/services/excel_services/open_excle_file.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<void> exportToExcel(String tableName) async {
  print("Entering exportToExcel() function...");
  final dbHelper = DatabaseHelper();
  var columnNames = await dbHelper.getColumnNames(tableName);
  // fetch students data from local database
  var data = await dbHelper.fetchLocalData(tableName);
  if (data.isEmpty) {
    print("No data found in the database for $tableName.");
    return;
  }
  else{
    print("Data found in the database for $tableName.");
  }

  //Create a new Excel workbook
  var excel = Excel.createExcel();
  Sheet sheet = excel['Sheet1'];

  print("Creating Excel file...");

  // Header Add in Excel
  sheet.appendRow(columnNames.map((e) => TextCellValue(e)).toList());

  //
  for (var row in data) {
    List<CellValue> rowData = columnNames.map((column) {
      var value = row[column];
      if (value is int) {
        return IntCellValue(value);
      } else if (value is double) {
        return DoubleCellValue(value);
      } else if (value is String) {
        return TextCellValue(value);
      } else if (value == null) {
        return TextCellValue(""); // Set empty string if value is null
      } else {
        return TextCellValue(value.toString());
      }
    }).toList();

    sheet.appendRow(rowData);
  }
  print("Excel file created successfully.");

  // Save the Excel file
  var directory = await getApplicationDocumentsDirectory();
  var filePath = '${directory.path}/$tableName.xlsx';
  var file = File(filePath);

  print("Saving Excel file to: $filePath");

  var excelBytes = excel.save();

  if (excelBytes != null) {
    await file.writeAsBytes(excelBytes);
    if (kDebugMode) {
      print('✅ Excel File Created: $filePath');
      if (Platform.isAndroid) {
        print('ℹ️ Opening Excel file...');
        // Open the Excel file
        await File(filePath).open(mode: FileMode.read);
        print('✅ Excel file opened.');
      }
      try {
        var newFile = await moveFileToDownload(tableName);
        print('✅ File moved to: $newFile');
        await openExcelFile(newFile);
      } catch (e) {
        if (kDebugMode) {
          print('❌ Error: Failed to open Excel file.');
          print(e);
        }
      }
    }
  } else {
    if (kDebugMode) {
      print('❌ Error: Failed to encode Excel file.');
    }
  }
}

