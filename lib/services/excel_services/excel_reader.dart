import 'dart:io';
import 'package:excel/excel.dart';

class ExcelReaderService {
  static Future<List<Map<String, dynamic>>> readExcelData(
      String filePath) async {
    var bytes = File(filePath).readAsBytesSync();
    var excel = Excel.decodeBytes(bytes);

    List<Map<String, dynamic>> dataList = [];
    for (var table in excel.tables.keys) {
      for (var row in excel.tables[table]!.rows.skip(1)) {
        // Skip headers
        if (row[0] == null || row[1] == null || row[2] == null || row[3] == null) {
          continue; // Skip empty rows
        }

        dataList.add({
          "student_id": row[0]?.value?.toString(),
          "name": row[1]?.value?.toString(),
          "dept": row[2]?.value?.toString(),
          "session": row[3]?.value?.toString(),
        });
      }
    }
    return dataList;
  }
}
