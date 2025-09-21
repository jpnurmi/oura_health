import 'dart:io';

import 'package:health/health.dart';
import 'package:meta/meta.dart';

import 'sleep_x.dart';
import 'sleep_data.dart';

class SleepService {
  SleepService([@visibleForTesting Health? health])
    : _health = health ?? Health();

  final Health _health;

  Future<void> configure() {
    return _health.configure();
  }

  Future<bool> requestAuth() {
    return _health.requestAuthorization(
      [
        if (Platform.isAndroid) HealthDataType.SLEEP_SESSION,
        HealthDataType.SLEEP_DEEP,
        HealthDataType.SLEEP_LIGHT,
        HealthDataType.SLEEP_REM,
        HealthDataType.SLEEP_AWAKE,
        if (Platform.isAndroid) HealthDataType.SLEEP_UNKNOWN,
      ],
      permissions: [
        if (Platform.isAndroid) HealthDataAccess.READ_WRITE,
        HealthDataAccess.WRITE,
        HealthDataAccess.WRITE,
        HealthDataAccess.WRITE,
        HealthDataAccess.WRITE,
        if (Platform.isAndroid) HealthDataAccess.WRITE,
      ],
    );
  }

  Future<bool> requestHistory() {
    return _health.requestHealthDataHistoryAuthorization();
  }

  Future<List<HealthDataPoint>> readData(DateTime start, DateTime end) {
    return _health.getHealthDataFromTypes(
      types: Platform.isAndroid
          ? [HealthDataType.SLEEP_SESSION]
          : [
              HealthDataType.SLEEP_DEEP,
              HealthDataType.SLEEP_LIGHT,
              HealthDataType.SLEEP_REM,
              HealthDataType.SLEEP_AWAKE,
            ],
      startTime: start,
      endTime: end,
    );
  }

  Future<bool> writeData(Sleep sleep) async {
    if (Platform.isAndroid) {
      if (!await _health.writeHealthData(
        value: 0,
        type: HealthDataType.SLEEP_SESSION,
        startTime: sleep.bedtimeStart,
        endTime: sleep.bedtimeEnd,
      )) {
        return false;
      }
    }

    // awake/rem/light/deep
    var offset = Duration.zero;
    final phases = sleep.sleepPhase5Min?.splitContinuousChunks() ?? [];
    for (var i = 0; i < phases.length; ++i) {
      final phase = phases[i];
      final phaseStart = sleep.bedtimeStart.add(offset);
      final phase5Min = phaseStart.add(Duration(minutes: phase.length * 5));
      final phaseEnd = phase5Min.isAfter(sleep.bedtimeEnd)
          ? sleep.bedtimeEnd
          : phase5Min;
      if (!await _health.writeHealthData(
        value: 0,
        type: phase.toHealthDataType(),
        startTime: phaseStart,
        endTime: phaseEnd,
      )) {
        return false;
      }
      offset += phaseEnd.difference(phaseStart);
    }
    return true;
  }
}
