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
        HealthDataType.SLEEP_SESSION,
        HealthDataType.SLEEP_DEEP,
        HealthDataType.SLEEP_LIGHT,
        HealthDataType.SLEEP_REM,
        HealthDataType.SLEEP_AWAKE,
        HealthDataType.SLEEP_UNKNOWN,
      ],
      permissions: [
        HealthDataAccess.READ_WRITE,
        HealthDataAccess.WRITE,
        HealthDataAccess.WRITE,
        HealthDataAccess.WRITE,
        HealthDataAccess.WRITE,
        HealthDataAccess.WRITE,
      ],
    );
  }

  Future<bool> requestHistory() {
    return _health.requestHealthDataHistoryAuthorization();
  }

  Future<List<HealthDataPoint>> readData(DateTime start, DateTime end) {
    return _health.getHealthDataFromTypes(
      types: [HealthDataType.SLEEP_SESSION],
      startTime: start,
      endTime: end,
    );
  }

  Future<bool> writeData(Sleep sleep) async {
    if (!await _health.writeHealthData(
      value: 0,
      type: HealthDataType.SLEEP_SESSION,
      startTime: sleep.bedtimeStart,
      endTime: sleep.bedtimeEnd,
    )) {
      return false;
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
