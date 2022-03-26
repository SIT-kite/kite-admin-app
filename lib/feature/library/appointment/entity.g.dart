// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notice _$NoticeFromJson(Map<String, dynamic> json) => Notice(
      DateTime.parse(json['ts'] as String),
      json['html'] as String,
    );

PeriodStatusRecord _$PeriodStatusRecordFromJson(Map<String, dynamic> json) =>
    PeriodStatusRecord(
      json['period'] as int,
      json['count'] as int,
      json['applied'] as int,
      json['text'] as String,
    );

ApplicationRecord _$ApplicationRecordFromJson(Map<String, dynamic> json) =>
    ApplicationRecord(
      json['id'] as int,
      json['period'] as int,
      json['user'] as String,
      json['index'] as int,
      json['text'] as String,
      json['status'] as int,
    );

ApplyResponse _$ApplyResponseFromJson(Map<String, dynamic> json) =>
    ApplyResponse(
      json['id'] as int,
      json['text'] as String,
      json['index'] as int,
    );

CurrentPeriodResponse _$CurrentPeriodResponseFromJson(
        Map<String, dynamic> json) =>
    CurrentPeriodResponse(
      DateTime.parse(json['after'] as String),
      DateTime.parse(json['before'] as String),
      json['period'] as int,
    );
