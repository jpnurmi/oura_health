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

  factory Sleep.fromCsv(List<String> header, List<String> fields) {
    return Sleep(
      day: DateTime.parse(fields[header.indexOf('day')]),
      type: _toSleepType(fields[header.indexOf('type')]),
      totalSleepDuration: _fromSecondsOrNull(
        int.tryParse(fields[header.indexOf('total_sleep_duration')]),
      ),
      awakeTime: _fromSecondsOrNull(
        int.tryParse(fields[header.indexOf('awake_time')]),
      ),
      bedtimeEnd: DateTime.parse(
        fields[header.indexOf('bedtime_end')],
      ),
      bedtimeStart: DateTime.parse(
        fields[header.indexOf('bedtime_start')],
      ),
      deepSleepDuration: _fromSecondsOrNull(
        int.tryParse(fields[header.indexOf('deep_sleep_duration')]),
      ),
      efficiency: int.tryParse(fields[header.indexOf('efficiency')]),
      latency: _fromSecondsOrNull(
        int.tryParse(fields[header.indexOf('latency')]),
      ),
      lightSleepDuration: _fromSecondsOrNull(
        int.tryParse(fields[header.indexOf('light_sleep_duration')]),
      ),
      remSleepDuration: _fromSecondsOrNull(
        int.tryParse(fields[header.indexOf('rem_sleep_duration')]),
      ),
      sleepPhase5Min: fields[header.indexOf('sleep_phase_5_min')],
      // TODO: delta? fields[26] as int?
      score: int.tryParse(fields[header.indexOf('sleep_score_delta')]),
      timeInBed: _fromSeconds(int.parse(fields[header.indexOf('time_in_bed')])),
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
