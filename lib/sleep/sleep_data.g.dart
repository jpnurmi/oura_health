// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sleep _$SleepFromJson(Map<String, dynamic> json) => Sleep(
  awakeTime: Sleep._fromSecondsOrNull((json['awake_time'] as num?)?.toInt()),
  bedtimeEnd: DateTime.parse(json['bedtime_end'] as String),
  bedtimeStart: DateTime.parse(json['bedtime_start'] as String),
  day: DateTime.parse(json['day'] as String),
  deepSleepDuration: Sleep._fromSecondsOrNull(
    (json['deep_sleep_duration'] as num?)?.toInt(),
  ),
  efficiency: (json['efficiency'] as num?)?.toInt(),
  latency: Sleep._fromSecondsOrNull((json['latency'] as num?)?.toInt()),
  lightSleepDuration: Sleep._fromSecondsOrNull(
    (json['light_sleep_duration'] as num?)?.toInt(),
  ),
  remSleepDuration: Sleep._fromSecondsOrNull(
    (json['rem_sleep_duration'] as num?)?.toInt(),
  ),
  sleepPhase5Min: json['sleep_phase_5_min'] as String?,
  score: (json['score'] as num?)?.toInt(),
  timeInBed: Sleep._fromSeconds((json['time_in_bed'] as num).toInt()),
  totalSleepDuration: Sleep._fromSecondsOrNull(
    (json['total_sleep_duration'] as num?)?.toInt(),
  ),
  type: $enumDecodeNullable(_$SleepTypeEnumMap, json['type']),
);

Map<String, dynamic> _$SleepToJson(Sleep instance) => <String, dynamic>{
  'awake_time': Sleep._toSecondsOrNull(instance.awakeTime),
  'bedtime_end': instance.bedtimeEnd.toIso8601String(),
  'bedtime_start': instance.bedtimeStart.toIso8601String(),
  'day': instance.day.toIso8601String(),
  'deep_sleep_duration': Sleep._toSecondsOrNull(instance.deepSleepDuration),
  'efficiency': instance.efficiency,
  'latency': Sleep._toSecondsOrNull(instance.latency),
  'light_sleep_duration': Sleep._toSecondsOrNull(instance.lightSleepDuration),
  'rem_sleep_duration': Sleep._toSecondsOrNull(instance.remSleepDuration),
  'sleep_phase_5_min': instance.sleepPhase5Min,
  'score': instance.score,
  'time_in_bed': Sleep._toSeconds(instance.timeInBed),
  'total_sleep_duration': Sleep._toSecondsOrNull(instance.totalSleepDuration),
  'type': _$SleepTypeEnumMap[instance.type],
};

const _$SleepTypeEnumMap = {
  SleepType.deleted: 'deleted',
  SleepType.sleep: 'sleep',
  SleepType.longSleep: 'long_sleep',
  SleepType.lateNap: 'late_nap',
  SleepType.rest: 'rest',
};
