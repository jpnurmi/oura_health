import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;

import 'sleep_x.dart';
import 'sleep_data.dart';
import 'sleep_service.dart';

class SleepNotifier extends ChangeNotifier {
  SleepNotifier([@visibleForTesting SleepService? service])
    : _service = service ?? SleepService();

  final SleepService _service;
  double? _progress;

  double? get progress => _progress;

  Future<void> init() => _service.configure();

  void _setProgress(double? value) {
    if (value == _progress) {
      return;
    }
    _progress = value;
    notifyListeners();
  }

  Future<bool> import(String path, {required bool full}) async {
    _setProgress(0);

    if (!await _service.requestAuth() || !await _service.requestHistory()) {
      _setProgress(null);
      return false;
    }

    final file = File(path);
    if (!await file.exists()) {
      _setProgress(null);
      return false;
    }

    if (p.extension(path) == '.zip') {
      await _importZip(file, full: full);
    } else if (p.extension(path) == '.json') {
      await _importJson(await file.readAsString(), full: full);
    } else if (p.extension(path) == '.csv') {
      await _importCsv(await file.readAsString(), full: full);
    } else {
      _setProgress(null);
      return false;
    }

    _setProgress(null);
    return true;
  }

  Future<void> _importZip(File file, {required bool full}) async {
    final bytes = await file.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);
    for (final file in archive) {
      if (file.isFile &&
          file.name.contains("sleep") &&
          file.name.endsWith('.csv')) {
        var csv = utf8.decode(file.content);
        var header = LineSplitter().convert(csv).firstOrNull;
        if (header?.contains('bedtime_start') == true ||
            header?.contains('bedtime_end') == true) {
          await _importCsv(csv, full: full);
        }
      }
    }
  }

  Future<void> _importJson(String str, {required bool full}) async {
    var i = 0;
    final json = jsonDecode(str) as Map<String, dynamic>;
    final entries = json['sleep'] as List<dynamic>;
    for (final entry in entries.reversed) {
      _setProgress(i++ / entries.length);

      final sleep = Sleep.fromJson(entry as Map<String, dynamic>);
      if (!await _importSleep(sleep) && !full) {
        break;
      }
    }
  }

  Future<void> _importCsv(String str, {required bool full}) async {
    var i = 0;
    var lines = LineSplitter().convert(str);
    var header = lines.first.split(';');
    var body = lines.skip(1).map((line) => line.split(';')).toList();

    for (final fields in body.reversed) {
      _setProgress(i++ / body.length);

      final sleep = Sleep.fromCsv(header, fields);
      if (!await _importSleep(sleep) && !full) {
        break;
      }
    }
  }

  Future<bool> _importSleep(Sleep sleep) async {
    final data = await _service.readData(
      sleep.bedtimeStart,
      sleep.bedtimeEnd,
    );
    if (sleep.matches(data)) {
      return false;
    }
    await _service.writeData(sleep);
    return true;
  }
}
