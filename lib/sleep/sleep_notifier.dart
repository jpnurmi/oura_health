import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

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

    var i = 0;
    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    final entries = json['sleep'] as List<dynamic>;
    for (final entry in entries.reversed) {
      _setProgress(i++ / entries.length);

      final sleep = Sleep.fromJson(entry as Map<String, dynamic>);

      final data = await _service.readData(
        sleep.bedtimeStart,
        sleep.bedtimeEnd,
      );
      if (!sleep.matches(data)) {
        await _service.writeData(sleep);
      } else if (!full) {
        break;
      }
    }

    _setProgress(null);
    return true;
  }
}
