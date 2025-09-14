import 'package:json_annotation/json_annotation.dart';

part 'sleep_data.g.dart';

/// Possible sleep period types.
@JsonEnum(fieldRename: FieldRename.snake)
enum SleepType {
  /// Deleted sleep by user.
  deleted,

  /// User confirmed sleep / nap, min 15 minutes, max 3 hours, contributes to daily scores.
  sleep,

  /// Sleep that is long enough (>3h) to automatically contribute to daily scores.
  longSleep,

  /// User confirmed sleep / nap, min 15 minutes, ended after sleep day change (6 pm), contributes to next days daily scores.
  lateNap,

  /// Falsely detected sleep / nap, rejected in confirm prompt by user.
  rest,
}

@JsonSerializable(fieldRename: FieldRename.snake)
class Sleep {
  /// Duration spent awake.
  @JsonKey(toJson: _toSecondsOrNull, fromJson: _fromSecondsOrNull)
  final Duration? awakeTime;

  /// Bedtime end of the sleep.
  final DateTime bedtimeEnd;

  /// Bedtime start of the sleep.
  final DateTime bedtimeStart;

  /// Day that the sleep belongs to.
  final DateTime day;

  /// Duration spent in deep sleep.
  @JsonKey(toJson: _toSecondsOrNull, fromJson: _fromSecondsOrNull)
  final Duration? deepSleepDuration;

  /// Sleep efficiency rating in range [1, 100].
  final int? efficiency;

  /// Sleep latency. This is the time it took for the user to fall asleep after going to bed.
  @JsonKey(toJson: _toSecondsOrNull, fromJson: _fromSecondsOrNull)
  final Duration? latency;

  /// Duration spent in light sleep.
  @JsonKey(toJson: _toSecondsOrNull, fromJson: _fromSecondsOrNull)
  final Duration? lightSleepDuration;

  /// Duration spent in REM sleep.
  @JsonKey(toJson: _toSecondsOrNull, fromJson: _fromSecondsOrNull)
  final Duration? remSleepDuration;

  /// 5-minute sleep phase classification for the period where every character corresponds to:
  // '1' = deep sleep,
  // '2' = light sleep,
  // '3' = REM sleep
  // '4' = awake.
  @JsonKey(name: 'sleep_phase_5_min')
  final String? sleepPhase5Min;

  final int? score;

  /// Duration spent in bed.
  @JsonKey(toJson: _toSeconds, fromJson: _fromSeconds)
  final Duration timeInBed;

  /// Total sleep duration.
  @JsonKey(toJson: _toSecondsOrNull, fromJson: _fromSecondsOrNull)
  final Duration? totalSleepDuration;

  /// Sleep period type.
  final SleepType? type;

  Sleep({
    required this.awakeTime,
    required this.bedtimeEnd,
    required this.bedtimeStart,
    required this.day,
    required this.deepSleepDuration,
    required this.efficiency,
    required this.latency,
    required this.lightSleepDuration,
    required this.remSleepDuration,
    required this.sleepPhase5Min,
    required this.score,
    required this.timeInBed,
    required this.totalSleepDuration,
    required this.type,
  });

  factory Sleep.fromJson(Map<String, dynamic> json) => _$SleepFromJson(json);
  Map<String, dynamic> toJson() => _$SleepToJson(this);

  // TODO: [List<String>? headers]
  factory Sleep.fromCsv(List<dynamic> fields) {
    return Sleep(
      // 0: day
      day: DateTime.parse(fields[0] as String),
      // 1: type
      type: _toSleepType(fields[1] as String?),
      // 2: total_sleep_duration
      totalSleepDuration: _fromSecondsOrNull(fields[2] as int?),
      // 3: average_breath
      // 4: average_heart_rate,
      // 5: average_hrv,
      // 6: awake_time,
      awakeTime: _fromSecondsOrNull(fields[6] as int?),
      // 7: bedtime_end,
      bedtimeEnd: DateTime.parse(fields[7] as String),
      // 8: bedtime_start,
      bedtimeStart: DateTime.parse(fields[8] as String),
      // 9: deep_sleep_duration,
      deepSleepDuration: _fromSecondsOrNull(fields[9] as int?),
      // 10: efficiency,
      efficiency: fields[10] as int?,
      // 11: heart_rate,
      // 12: hrv,
      // 13: latency,
      latency: _fromSecondsOrNull(fields[13] as int?),
      // 14: light_sleep_duration,
      lightSleepDuration: _fromSecondsOrNull(fields[14] as int?),
      // 15: low_battery_alert,
      // 16: lowest_heart_rate,
      // 16: movement_30_sec,
      // 18: period,
      // 19: readiness,
      // 20: readiness_score_delta,
      // 21: rem_sleep_duration,
      remSleepDuration: _fromSecondsOrNull(fields[21] as int?),
      // 22: restless_periods,
      // 23: sleep_algorithm_version,
      // 24: sleep_analysis_reason,
      // 25: sleep_phase_5_min,
      sleepPhase5Min: fields[25] as String?,
      // 26: sleep_score_delta, // TODO: delta?
      score: int.tryParse(fields[26].toString()), // fields[26] as int?
      // 27: time_in_bed,
      timeInBed: _fromSeconds(fields[27] as int),
      // 28: id
    );
  }

  static int _toSeconds(Duration value) => value.inSeconds;
  static Duration _fromSeconds(int value) => Duration(seconds: value);

  static int? _toSecondsOrNull(Duration? value) => value?.inSeconds;
  static Duration? _fromSecondsOrNull(int? value) =>
      value != null ? Duration(seconds: value) : null;

  static SleepType? _toSleepType(String? value) {
    return switch (value) {
      'deleted' => SleepType.deleted,
      'sleep' => SleepType.sleep,
      'long_sleep' => SleepType.longSleep,
      'late_nap' => SleepType.lateNap,
      'rest' => SleepType.rest,
      _ => null,
    };
  }

  @override
  int get hashCode => Object.hashAll([
    awakeTime,
    bedtimeEnd,
    bedtimeStart,
    day,
    deepSleepDuration,
    efficiency,
    latency,
    lightSleepDuration,
    remSleepDuration,
    sleepPhase5Min,
    score,
    timeInBed,
    totalSleepDuration,
    type,
  ]);

  @override
  bool operator ==(Object other) =>
      other is Sleep &&
      awakeTime == other.awakeTime &&
      bedtimeEnd == other.bedtimeEnd &&
      bedtimeStart == other.bedtimeStart &&
      day == other.day &&
      deepSleepDuration == other.deepSleepDuration &&
      efficiency == other.efficiency &&
      latency == other.latency &&
      lightSleepDuration == other.lightSleepDuration &&
      remSleepDuration == other.remSleepDuration &&
      sleepPhase5Min == other.sleepPhase5Min &&
      score == other.score &&
      timeInBed == other.timeInBed &&
      totalSleepDuration == other.totalSleepDuration &&
      type == other.type;

  @override
  String toString() =>
      'Sleep('
      'awakeTime: $awakeTime, '
      'bedtimeEnd: $bedtimeEnd, '
      'bedtimeStart: $bedtimeStart, '
      'day: $day, '
      'deepSleepDuration: $deepSleepDuration, '
      'efficiency: $efficiency, '
      'latency: $latency, '
      'lightSleepDuration: $lightSleepDuration, '
      'remSleepDuration: $remSleepDuration, '
      'sleepPhase5Min: $sleepPhase5Min, '
      'score: $score, '
      'timeInBed: $timeInBed, '
      'totalSleepDuration: $totalSleepDuration, '
      'type: $type'
      ')';
}
