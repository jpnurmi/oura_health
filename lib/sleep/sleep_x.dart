import 'package:health/health.dart';

import 'sleep_data.dart';

extension SleepX on Sleep {
  bool matches(List<HealthDataPoint> data) {
    return data.any((d) => d.dateFrom.isAtSameMomentAs(bedtimeStart)) &&
        data.any((d) => d.dateTo.isAtSameMomentAs(bedtimeEnd));
  }
}

extension StringX on String {
  List<String> splitContinuousChunks() {
    return codeUnits
        .fold<List<List<int>>>([], (chunks, code) {
          if (chunks.isEmpty || chunks.last.first != code) {
            chunks.add([code]);
          } else {
            chunks.last.add(code);
          }
          return chunks;
        })
        .map((chunk) => String.fromCharCodes(chunk))
        .toList();
  }

  HealthDataType toHealthDataType() {
    return switch (this[0]) {
      '1' => HealthDataType.SLEEP_DEEP,
      '2' => HealthDataType.SLEEP_LIGHT,
      '3' => HealthDataType.SLEEP_REM,
      '4' => HealthDataType.SLEEP_AWAKE,
      _ => HealthDataType.SLEEP_UNKNOWN,
    };
  }
}
